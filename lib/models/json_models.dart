// GENERATED: Models imported from the upstream repository.
// These models represent cards and picture references.  They are unchanged
// relative to commit e5f882677617a327c4915bed61778983998ae276.

import 'dart:convert';
import 'dart:typed_data';

class PicRef {
  final String type; // file | dataUri | asset
  final String uri; // path or data-uri or asset path
  const PicRef({required this.type, required this.uri});

  Map<String, dynamic> toJson() => {"type": type, "uri": uri};
  factory PicRef.fromJson(dynamic j) {
    if (j is String) {
      if (j.startsWith('data:image/')) return PicRef(type: 'dataUri', uri: j);
      if (j.startsWith('asset://')) return PicRef(type: 'asset', uri: j.substring('asset://'.length));
      return PicRef(type: 'file', uri: j);
    }
    final m = j as Map<String, dynamic>;
    return PicRef(type: m['type'] ?? 'file', uri: m['uri'] ?? '');
  }
}

class RiddleJson {
  final String id;
  final String question;
  final String answer;
  final List<String> tags;
  final List<PicRef> questionPics;
  final List<PicRef> answerPics;

  RiddleJson({
    required this.id,
    required this.question,
    required this.answer,
    required this.tags,
    required this.questionPics,
    required this.answerPics,
  });

  factory RiddleJson.fromDynamic(Map<String, dynamic> j) {
    final id = j['id'] ?? j['pair_id'] ?? j['card_id'] ?? j['riddle_id'] ?? '';
    final q = j['question'] ?? j['kysymys'] ?? j['q'] ?? '';
    final a = j['answer'] ?? j['vastaus'] ?? j['a'] ?? '';
    final tagsRaw = j['tags'] ?? j['tagit'] ?? j['kategoriat'] ?? j['categories'] ?? [];
    final qp = j['question_pics'] ?? j['questionPics'] ?? [];
    final ap = j['answer_pics'] ?? j['answerPics'] ?? [];

    List<String> tags;
    if (tagsRaw is List) {
      tags = tagsRaw.map((e) => e.toString()).toList();
    } else if (tagsRaw is String) {
      tags = tagsRaw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    } else {
      tags = [];
    }

    List<PicRef> toPics(dynamic arr) => (arr as List).map((e) => PicRef.fromJson(e)).toList();

    return RiddleJson(
      id: id.toString(),
      question: q.toString(),
      answer: a.toString(),
      tags: tags,
      questionPics: toPics(qp),
      answerPics: toPics(ap),
    );
  }

  Map<String, dynamic> toJson() => {
        "pair_id": id,
        "question": question,
        "answer": answer,
        "tags": tags,
        "question_pics": questionPics.map((e) => e.toJson()).toList(),
        "answer_pics": answerPics.map((e) => e.toJson()).toList(),
      };
}

String picsToDbJson(List<PicRef> pics) => jsonEncode(pics.map((e) => e.toJson()).toList());

List<PicRef> picsFromDbJson(String s) {
  final list = jsonDecode(s) as List;
  return list.map((e) => PicRef.fromJson(e)).toList();
}

Uint8List? decodeDataUriToBytes(String dataUri) {
  final idx = dataUri.indexOf(',');
  if (idx == -1) return null;
  final b64 = dataUri.substring(idx + 1);
  return base64Decode(b64);
}

String guessDataUriMime(String dataUri) {
  final m = RegExp(r"data:([^;]+);base64").firstMatch(dataUri);
  return m?.group(1) ?? 'image/png';
}