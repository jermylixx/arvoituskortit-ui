import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../data/db.dart';
import '../data/importer.dart';
import '../models/json_models.dart';
import 'riddle_card.dart';
import 'riddle_editor.dart';

class HomePage extends StatefulWidget {
  final AppDatabase db;
  const HomePage({super.key, required this.db});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';
  String _tag = 'Kaikki';
  bool _grid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arvoituskortit'),
        actions: [
          IconButton(
            tooltip: _grid ? 'Lista' : 'Ruudukko',
            onPressed: () => setState(() => _grid = !_grid),
            icon: Icon(_grid ? Icons.view_list : Icons.grid_view),
          ),
          if (kDebugMode)
            PopupMenuButton<String>(
              onSelected: _onDevAction,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'import', child: Text('Import JSON from file')),
                PopupMenuItem(value: 'seed', child: Text('Import bundled seed.json')),
                PopupMenuItem(value: 'export', child: Text('Export JSON')),
                PopupMenuItem(value: 'reset', child: Text('Reset database')),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNew,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Haku'),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ArvoitusCard>>(
              stream: widget.db.watchAll(),
              builder: (context, snapshot) {
                final rows = snapshot.data ?? <ArvoitusCard>[];
                final tags = <String>{'Kaikki'};
                for (final c in rows) {
                  tags.addAll(c.tags.split(',').where((e) => e.isNotEmpty));
                }
                final tagList = tags.toList()..sort();
                final filtered = rows.where((c) {
                  final qOk = _query.isEmpty ||
                      c.question.toLowerCase().contains(_query) ||
                      c.answer.toLowerCase().contains(_query);
                  final tOk = _tag == 'Kaikki' || c.tags.split(',').contains(_tag);
                  return qOk && tOk;
                }).toList();

                return Column(
                  children: [
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: tagList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final t = tagList[i];
                          return ChoiceChip(
                            label: Text(t),
                            selected: t == _tag,
                            onSelected: (_) => setState(() => _tag = t),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(child: Text('Ei osumia'))
                          : Padding(
                        padding: const EdgeInsets.all(12),
                        child: _grid
                            ? GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.78,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => _cardItem(filtered[i]),
                        )
                            : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) => _cardItem(filtered[i]),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardItem(ArvoitusCard c) {
    final fp = picsFromDbJson(c.questionPics);
    final ap = picsFromDbJson(c.answerPics);
    return RiddleCardView(
      titleFront: 'Kysymys',
      titleBack: 'Vastaus',
      textFront: c.question,
      textBack: c.answer,
      frontPics: fp,
      backPics: ap,
      onEdit: () => _editCard(c),
    );
  }

  Future<void> _createNew() async {
    final res = await Navigator.of(context)
        .push<CardsCompanion>(MaterialPageRoute(builder: (_) => const RiddleEditorPage()));
    if (res != null) {
      await widget.db.upsertCard(res);
    }
  }

  Future<void> _editCard(ArvoitusCard row) async {
    final res = await Navigator.of(context)
        .push<CardsCompanion>(MaterialPageRoute(builder: (_) => RiddleEditorPage(cardRow: row)));
    if (res != null) {
      await widget.db.upsertCard(res);
    }
  }

  Future<void> _onDevAction(String action) async {
    final importer = Importer(widget.db);
    if (action == 'import') {
      final picked = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      if (picked == null || picked.files.single.path == null) return;
      final file = File(picked.files.single.path!);
      final json = await file.readAsString();
      await importer.importFromJsonString(json, isBaseline: false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Import ok')));
    } else if (action == 'seed') {
      final json = await DefaultAssetBundle.of(context).loadString('assets/seed.json');
      await importer.importFromJsonString(json, isBaseline: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seed import ok')));
    } else if (action == 'export') {
      final json = await importer.exportToJsonString();
      final temp = await _writeTemp(json);
      await Share.shareXFiles([XFile(temp.path)], text: 'Arvoituskortit export');
    } else if (action == 'reset') {
      await widget.db.clearAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tietokanta tyhjennetty')));
    }
  }

  Future<File> _writeTemp(String content) async {
    final dir = await Directory.systemTemp.createTemp('riddles_export');
    final f = File('${dir.path}/export.json');
    await f.writeAsString(content);
    return f;
  }
}
