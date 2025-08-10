// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, ArvoitusCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _questionPicsMeta =
      const VerificationMeta('questionPics');
  @override
  late final GeneratedColumn<String> questionPics = GeneratedColumn<String>(
      'question_pics', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _answerPicsMeta =
      const VerificationMeta('answerPics');
  @override
  late final GeneratedColumn<String> answerPics = GeneratedColumn<String>(
      'answer_pics', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isUserAddedMeta =
      const VerificationMeta('isUserAdded');
  @override
  late final GeneratedColumn<bool> isUserAdded = GeneratedColumn<bool>(
      'is_user_added', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_user_added" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isModifiedMeta =
      const VerificationMeta('isModified');
  @override
  late final GeneratedColumn<bool> isModified = GeneratedColumn<bool>(
      'is_modified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_modified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        question,
        answer,
        tags,
        questionPics,
        answerPics,
        isUserAdded,
        isModified,
        deleted,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<ArvoitusCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('question_pics')) {
      context.handle(
          _questionPicsMeta,
          questionPics.isAcceptableOrUnknown(
              data['question_pics']!, _questionPicsMeta));
    }
    if (data.containsKey('answer_pics')) {
      context.handle(
          _answerPicsMeta,
          answerPics.isAcceptableOrUnknown(
              data['answer_pics']!, _answerPicsMeta));
    }
    if (data.containsKey('is_user_added')) {
      context.handle(
          _isUserAddedMeta,
          isUserAdded.isAcceptableOrUnknown(
              data['is_user_added']!, _isUserAddedMeta));
    }
    if (data.containsKey('is_modified')) {
      context.handle(
          _isModifiedMeta,
          isModified.isAcceptableOrUnknown(
              data['is_modified']!, _isModifiedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArvoitusCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArvoitusCard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      questionPics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_pics'])!,
      answerPics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer_pics'])!,
      isUserAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_user_added'])!,
      isModified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_modified'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class ArvoitusCard extends DataClass implements Insertable<ArvoitusCard> {
  final String id;
  final String question;
  final String answer;
  final String tags;
  final String questionPics;
  final String answerPics;
  final bool isUserAdded;
  final bool isModified;
  final bool deleted;
  final DateTime updatedAt;
  const ArvoitusCard(
      {required this.id,
      required this.question,
      required this.answer,
      required this.tags,
      required this.questionPics,
      required this.answerPics,
      required this.isUserAdded,
      required this.isModified,
      required this.deleted,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['question'] = Variable<String>(question);
    map['answer'] = Variable<String>(answer);
    map['tags'] = Variable<String>(tags);
    map['question_pics'] = Variable<String>(questionPics);
    map['answer_pics'] = Variable<String>(answerPics);
    map['is_user_added'] = Variable<bool>(isUserAdded);
    map['is_modified'] = Variable<bool>(isModified);
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      question: Value(question),
      answer: Value(answer),
      tags: Value(tags),
      questionPics: Value(questionPics),
      answerPics: Value(answerPics),
      isUserAdded: Value(isUserAdded),
      isModified: Value(isModified),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
    );
  }

  factory ArvoitusCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArvoitusCard(
      id: serializer.fromJson<String>(json['id']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String>(json['answer']),
      tags: serializer.fromJson<String>(json['tags']),
      questionPics: serializer.fromJson<String>(json['questionPics']),
      answerPics: serializer.fromJson<String>(json['answerPics']),
      isUserAdded: serializer.fromJson<bool>(json['isUserAdded']),
      isModified: serializer.fromJson<bool>(json['isModified']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String>(answer),
      'tags': serializer.toJson<String>(tags),
      'questionPics': serializer.toJson<String>(questionPics),
      'answerPics': serializer.toJson<String>(answerPics),
      'isUserAdded': serializer.toJson<bool>(isUserAdded),
      'isModified': serializer.toJson<bool>(isModified),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ArvoitusCard copyWith(
          {String? id,
          String? question,
          String? answer,
          String? tags,
          String? questionPics,
          String? answerPics,
          bool? isUserAdded,
          bool? isModified,
          bool? deleted,
          DateTime? updatedAt}) =>
      ArvoitusCard(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        tags: tags ?? this.tags,
        questionPics: questionPics ?? this.questionPics,
        answerPics: answerPics ?? this.answerPics,
        isUserAdded: isUserAdded ?? this.isUserAdded,
        isModified: isModified ?? this.isModified,
        deleted: deleted ?? this.deleted,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ArvoitusCard copyWithCompanion(CardsCompanion data) {
    return ArvoitusCard(
      id: data.id.present ? data.id.value : this.id,
      question: data.question.present ? data.question.value : this.question,
      answer: data.answer.present ? data.answer.value : this.answer,
      tags: data.tags.present ? data.tags.value : this.tags,
      questionPics: data.questionPics.present
          ? data.questionPics.value
          : this.questionPics,
      answerPics:
          data.answerPics.present ? data.answerPics.value : this.answerPics,
      isUserAdded:
          data.isUserAdded.present ? data.isUserAdded.value : this.isUserAdded,
      isModified:
          data.isModified.present ? data.isModified.value : this.isModified,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArvoitusCard(')
          ..write('id: $id, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('tags: $tags, ')
          ..write('questionPics: $questionPics, ')
          ..write('answerPics: $answerPics, ')
          ..write('isUserAdded: $isUserAdded, ')
          ..write('isModified: $isModified, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, question, answer, tags, questionPics,
      answerPics, isUserAdded, isModified, deleted, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArvoitusCard &&
          other.id == this.id &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.tags == this.tags &&
          other.questionPics == this.questionPics &&
          other.answerPics == this.answerPics &&
          other.isUserAdded == this.isUserAdded &&
          other.isModified == this.isModified &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt);
}

class CardsCompanion extends UpdateCompanion<ArvoitusCard> {
  final Value<String> id;
  final Value<String> question;
  final Value<String> answer;
  final Value<String> tags;
  final Value<String> questionPics;
  final Value<String> answerPics;
  final Value<bool> isUserAdded;
  final Value<bool> isModified;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.tags = const Value.absent(),
    this.questionPics = const Value.absent(),
    this.answerPics = const Value.absent(),
    this.isUserAdded = const Value.absent(),
    this.isModified = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required String question,
    required String answer,
    this.tags = const Value.absent(),
    this.questionPics = const Value.absent(),
    this.answerPics = const Value.absent(),
    this.isUserAdded = const Value.absent(),
    this.isModified = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        question = Value(question),
        answer = Value(answer);
  static Insertable<ArvoitusCard> custom({
    Expression<String>? id,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<String>? tags,
    Expression<String>? questionPics,
    Expression<String>? answerPics,
    Expression<bool>? isUserAdded,
    Expression<bool>? isModified,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (tags != null) 'tags': tags,
      if (questionPics != null) 'question_pics': questionPics,
      if (answerPics != null) 'answer_pics': answerPics,
      if (isUserAdded != null) 'is_user_added': isUserAdded,
      if (isModified != null) 'is_modified': isModified,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? question,
      Value<String>? answer,
      Value<String>? tags,
      Value<String>? questionPics,
      Value<String>? answerPics,
      Value<bool>? isUserAdded,
      Value<bool>? isModified,
      Value<bool>? deleted,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CardsCompanion(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      tags: tags ?? this.tags,
      questionPics: questionPics ?? this.questionPics,
      answerPics: answerPics ?? this.answerPics,
      isUserAdded: isUserAdded ?? this.isUserAdded,
      isModified: isModified ?? this.isModified,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (questionPics.present) {
      map['question_pics'] = Variable<String>(questionPics.value);
    }
    if (answerPics.present) {
      map['answer_pics'] = Variable<String>(answerPics.value);
    }
    if (isUserAdded.present) {
      map['is_user_added'] = Variable<bool>(isUserAdded.value);
    }
    if (isModified.present) {
      map['is_modified'] = Variable<bool>(isModified.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('tags: $tags, ')
          ..write('questionPics: $questionPics, ')
          ..write('answerPics: $answerPics, ')
          ..write('isUserAdded: $isUserAdded, ')
          ..write('isModified: $isModified, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cards];
}

typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  required String id,
  required String question,
  required String answer,
  Value<String> tags,
  Value<String> questionPics,
  Value<String> answerPics,
  Value<bool> isUserAdded,
  Value<bool> isModified,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<String> id,
  Value<String> question,
  Value<String> answer,
  Value<String> tags,
  Value<String> questionPics,
  Value<String> answerPics,
  Value<bool> isUserAdded,
  Value<bool> isModified,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionPics => $composableBuilder(
      column: $table.questionPics, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answerPics => $composableBuilder(
      column: $table.answerPics, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUserAdded => $composableBuilder(
      column: $table.isUserAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isModified => $composableBuilder(
      column: $table.isModified, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionPics => $composableBuilder(
      column: $table.questionPics,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answerPics => $composableBuilder(
      column: $table.answerPics, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUserAdded => $composableBuilder(
      column: $table.isUserAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isModified => $composableBuilder(
      column: $table.isModified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get questionPics => $composableBuilder(
      column: $table.questionPics, builder: (column) => column);

  GeneratedColumn<String> get answerPics => $composableBuilder(
      column: $table.answerPics, builder: (column) => column);

  GeneratedColumn<bool> get isUserAdded => $composableBuilder(
      column: $table.isUserAdded, builder: (column) => column);

  GeneratedColumn<bool> get isModified => $composableBuilder(
      column: $table.isModified, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardsTable,
    ArvoitusCard,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (ArvoitusCard, BaseReferences<_$AppDatabase, $CardsTable, ArvoitusCard>),
    ArvoitusCard,
    PrefetchHooks Function()> {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> questionPics = const Value.absent(),
            Value<String> answerPics = const Value.absent(),
            Value<bool> isUserAdded = const Value.absent(),
            Value<bool> isModified = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsCompanion(
            id: id,
            question: question,
            answer: answer,
            tags: tags,
            questionPics: questionPics,
            answerPics: answerPics,
            isUserAdded: isUserAdded,
            isModified: isModified,
            deleted: deleted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String question,
            required String answer,
            Value<String> tags = const Value.absent(),
            Value<String> questionPics = const Value.absent(),
            Value<String> answerPics = const Value.absent(),
            Value<bool> isUserAdded = const Value.absent(),
            Value<bool> isModified = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsCompanion.insert(
            id: id,
            question: question,
            answer: answer,
            tags: tags,
            questionPics: questionPics,
            answerPics: answerPics,
            isUserAdded: isUserAdded,
            isModified: isModified,
            deleted: deleted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardsTable,
    ArvoitusCard,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (ArvoitusCard, BaseReferences<_$AppDatabase, $CardsTable, ArvoitusCard>),
    ArvoitusCard,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
}
