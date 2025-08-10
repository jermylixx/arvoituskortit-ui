import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

@DataClassName('ArvoitusCard') // <— tämä estää törmäyksen Flutterin Card-widgetin kanssa
class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  TextColumn get tags => text().withDefault(const Constant(''))(); // comma-joined
  TextColumn get questionPics => text().withDefault(const Constant('[]'))(); // json list
  TextColumn get answerPics => text().withDefault(const Constant('[]'))(); // json list
  BoolColumn get isUserAdded => boolean().withDefault(const Constant(false))();
  BoolColumn get isModified => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Cards])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDb());

  @override
  int get schemaVersion => 1;

  // Huom: nyt käytetään ArvoitusCard-tyyppiä
  Future<List<ArvoitusCard>> allCards() => select(cards).get();
  Stream<List<ArvoitusCard>> watchAll() =>
      (select(cards)..where((c) => c.deleted.equals(false))).watch();

  Future<void> upsertCard(CardsCompanion data) async {
    await into(cards).insertOnConflictUpdate(data);
  }

  Future<void> markDeleted(String id) async {
    await (update(cards)..where((c) => c.id.equals(id)))
        .write(const CardsCompanion(deleted: Value(true)));
  }

  Future<void> clearAll() async {
    await delete(cards).go();
  }
}

LazyDatabase _openDb() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'arvoituskortit.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
