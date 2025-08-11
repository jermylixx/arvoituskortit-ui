import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value; // tarvitaan Value
import 'package:image_picker/image_picker.dart';
import 'components/glass.dart';

import '../data/db.dart';
import '../models/json_models.dart';

/// A page for creating or editing a single riddle card.  This is copied
/// directly from the original repository and applies only minimal styling.
class RiddleEditorPage extends StatefulWidget {
  final ArvoitusCard? cardRow; // null = uusi
  const RiddleEditorPage({super.key, this.cardRow});

  @override
  State<RiddleEditorPage> createState() => _RiddleEditorPageState();
}

class _RiddleEditorPageState extends State<RiddleEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _q;
  late TextEditingController _a;
  late TextEditingController _tags;
  List<PicRef> _qPics = [];
  List<PicRef> _aPics = [];

  @override
  void initState() {
    super.initState();
    _q = TextEditingController(text: widget.cardRow?.question ?? '');
    _a = TextEditingController(text: widget.cardRow?.answer ?? '');
    _tags = TextEditingController(text: widget.cardRow?.tags ?? '');
    if (widget.cardRow != null) {
      _qPics = picsFromDbJson(widget.cardRow!.questionPics);
      _aPics = picsFromDbJson(widget.cardRow!.answerPics);
    }
  }

  @override
  void dispose() {
    _q.dispose();
    _a.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool forQuestion) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (x == null) return;
    final ref = PicRef(type: 'file', uri: x.path);
    setState(() {
      (forQuestion ? _qPics : _aPics).add(ref);
    });
  }

  void _removePic(bool forQuestion, int index) {
    setState(() {
      (forQuestion ? _qPics : _aPics).removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cardRow == null ? 'Uusi arvoitus' : 'Muokkaa arvoitusta')),
      body: Stack(
        children: [
          const AuroraBackground(),
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                EdgeGlass(
                  borderRadius: BorderRadius.circular(20),
                  glow: true,
                  vignette: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextFormField(
                      controller: _q,
                      decoration: const InputDecoration(
                        hintText: 'Kysymys',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      minLines: 3,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Kirjoita kysymys' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _PicStrip(
                  pics: _qPics,
                  onAdd: () => _pickImage(true),
                  onRemove: (i) => _removePic(true, i),
                  title: 'Kysymyksen kuvat',
                ),
                const SizedBox(height: 12),
                EdgeGlass(
                  borderRadius: BorderRadius.circular(20),
                  glow: true,
                  vignette: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextFormField(
                      controller: _a,
                      decoration: const InputDecoration(
                        hintText: 'Vastaus',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      minLines: 2,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Kirjoita vastaus' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _PicStrip(
                  pics: _aPics,
                  onAdd: () => _pickImage(false),
                  onRemove: (i) => _removePic(false, i),
                  title: 'Vastauksen kuvat',
                ),
                const SizedBox(height: 12),
                EdgeGlass(
                  borderRadius: BorderRadius.circular(20),
                  glow: true,
                  vignette: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextFormField(
                      controller: _tags,
                      decoration: const InputDecoration(
                        hintText: 'Tagit pilkuilla',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GlassButton(
                  label: 'Tallenna',
                  onPressed: () {
                    final result = _buildResult();
                    if (result != null) Navigator.of(context).pop(result);
                  },
                  borderRadius: 24,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CardsCompanion? _buildResult() {
    if (!_formKey.currentState!.validate()) return null;
    final id = widget.cardRow?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    return CardsCompanion(
      id: Value(id),
      question: Value(_q.text.trim()),
      answer: Value(_a.text.trim()),
      tags: Value(_tags.text.trim()),
      questionPics: Value(picsToDbJson(_qPics)),
      answerPics: Value(picsToDbJson(_aPics)),
      isUserAdded: const Value(true),
      isModified: const Value(true),
    );
  }
}

class _PicStrip extends StatelessWidget {
  final List<PicRef> pics;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final String title;
  const _PicStrip({required this.pics, required this.onAdd, required this.onRemove, required this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            TextButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Lisää kuva')),
          ],
        ),
        const SizedBox(height: 8),
        if (pics.isEmpty) const Text('Ei kuvia'),
        if (pics.isNotEmpty)
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: pics.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final p = pics[i];
                final Widget w;
                if (p.type == 'file') {
                  w = Image.file(File(p.uri), width: 120, height: 84, fit: BoxFit.cover);
                } else if (p.type == 'dataUri') {
                  final bytes = decodeDataUriToBytes(p.uri);
                  w = bytes == null
                      ? const SizedBox.shrink()
                      : Image.memory(bytes, width: 120, height: 84, fit: BoxFit.cover);
                } else {
                  w = Image.asset(p.uri, width: 120, height: 84, fit: BoxFit.cover);
                }
                return Stack(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(10), child: w),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      iconSize: 20,
                      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      icon: const Icon(Icons.close),
                      onPressed: () => onRemove(i),
                    ),
                  ),
                ]);
              },
            ),
          ),
      ],
    );
  }
}