import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart' as d;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/json_models.dart';
import 'db.dart';

class Importer {
  final AppDatabase db;
  Importer(this.db);

  Future<void> importFromJsonString(String json, {bool isBaseline = true}) async {
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    final list = (decoded['pairs'] ?? decoded['riddles'] ?? decoded['items'] ?? []) as List;
    for (final item in list) {
      final r = RiddleJson.fromDynamic(item as Map<String, dynamic>);
      await _mergeRiddle(r, isBaseline: isBaseline);
    }
  }

  Future<void> _mergeRiddle(RiddleJson r, {required bool isBaseline}) async {
    final existing = await (db.select(db.cards)..where((c) => c.id.equals(r.id))).getSingleOrNull();
    final tagsCsv = r.tags.join(',');
    final qpSaved = await _ensurePicsMaterialized(r.questionPics, r.id, 'q');
    final apSaved = await _ensurePicsMaterialized(r.answerPics, r.id, 'a');

    if (existing == null) {
      await db.upsertCard(CardsCompanion(
        id: d.Value(r.id),
        question: d.Value(r.question.trim()),
        answer: d.Value(r.answer.trim()),
        tags: d.Value(tagsCsv),
        questionPics: d.Value(picsToDbJson(qpSaved)),
        answerPics: d.Value(picsToDbJson(apSaved)),
        isUserAdded: d.Value(!isBaseline),
        isModified: const d.Value(false),
      ));
      return;
    }

    final canOverwrite = isBaseline && !existing.isModified && !existing.isUserAdded;

    if (canOverwrite) {
      await db.upsertCard(CardsCompanion(
        id: d.Value(r.id),
        question: d.Value(r.question.trim()),
        answer: d.Value(r.answer.trim()),
        tags: d.Value(tagsCsv),
        questionPics: d.Value(picsToDbJson(qpSaved)),
        answerPics: d.Value(picsToDbJson(apSaved)),
      ));
    } else if (!isBaseline) {
      await db.upsertCard(CardsCompanion(
        id: d.Value(r.id),
        question: d.Value(r.question.trim()),
        answer: d.Value(r.answer.trim()),
        tags: d.Value(tagsCsv),
        questionPics: d.Value(picsToDbJson(qpSaved)),
        answerPics: d.Value(picsToDbJson(apSaved)),
        isModified: const d.Value(true),
      ));
    }
  }

  Future<List<PicRef>> _ensurePicsMaterialized(List<PicRef> src, String id, String side) async {
    final out = <PicRef>[];
    for (final pic in src) {
      if (pic.type == 'dataUri') {
        final bytes = decodeDataUriToBytes(pic.uri);
        if (bytes == null) continue;
        final mime = guessDataUriMime(pic.uri);
        final ext = _mimeToExt(mime);
        final file = await _createImageFileFor(id, side, ext);
        await file.writeAsBytes(bytes);
        out.add(PicRef(type: 'file', uri: file.path));
      } else {
        out.add(pic);
      }
    }
    return out;
  }

  Future<File> _createImageFileFor(String id, String side, String ext) async {
    final dir = await getApplicationDocumentsDirectory();
    final imgDir = Directory(p.join(dir.path, 'images'));
    if (!await imgDir.exists()) await imgDir.create(recursive: true);
    final name = '${id}_${side}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}.$ext';
    return File(p.join(imgDir.path, name));
  }

  String _mimeToExt(String mime) {
    switch (mime) {
      case 'image/jpeg': return 'jpg';
      case 'image/gif':  return 'gif';
      case 'image/webp': return 'webp';
      default:           return 'png';
    }
  }

  Future<String> exportToJsonString() async {
    final rows = await (db.select(db.cards)..where((c) => c.deleted.equals(false))).get();
    final items = <Map<String, dynamic>>[];

    for (final c in rows) {
      final qPics = picsFromDbJson(c.questionPics);
      final aPics = picsFromDbJson(c.answerPics);

      final qOut = <PicRef>[];
      for (final pRef in qPics) {
        if (pRef.type == 'file') {
          final f = File(pRef.uri);
          if (await f.exists()) {
            final b64 = base64Encode(await f.readAsBytes());
            qOut.add(PicRef(type: 'dataUri', uri: 'data:image/png;base64,$b64'));
          }
        } else {
          qOut.add(pRef);
        }
      }

      final aOut = <PicRef>[];
      for (final pRef in aPics) {
        if (pRef.type == 'file') {
          final f = File(pRef.uri);
          if (await f.exists()) {
            final b64 = base64Encode(await f.readAsBytes());
            aOut.add(PicRef(type: 'dataUri', uri: 'data:image/png;base64,$b64'));
          }
        } else {
          aOut.add(pRef);
        }
      }

      items.add({
        "pair_id": c.id,
        "question": c.question,
        "answer": c.answer,
        "tags": c.tags.split(',').where((e) => e.isNotEmpty).toList(),
        "question_pics": qOut.map((e) => e.toJson()).toList(),
        "answer_pics": aOut.map((e) => e.toJson()).toList(),
      });
    }

    final out = {"pairs": items, "dataset_name": "export", "dataset_version": DateTime.now().millisecondsSinceEpoch};
    return const JsonEncoder.withIndent('  ').convert(out);
  }
}
