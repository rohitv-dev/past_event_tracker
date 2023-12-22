import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:past_event_tracker/database/tables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

enum EventState { all, active, inactive }

enum EventMode { add, edit }

enum EventSort { title, date, createdDate }

@DriftDatabase(tables: [Events])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> updateEvent(EventsCompanion event) {
    return into(events).insert(
      event,
      onConflict: DoUpdate(
        (old) => EventsCompanion.custom(
          id: old.id,
          title: Constant(event.title.value),
          description: Constant(event.description.value),
          date: Constant(event.date.value),
          isActive: Constant(event.isActive.value),
        ),
      ),
    );
  }

  Future<int> deleteEvent(int id) {
    return (delete(events)..where((e) => e.id.equals(id))).go();
  }

  Future<void> addEvents(List<EventsCompanion> eventsList) {
    return batch((batch) {
      batch.insertAll(events, eventsList);
    });
  }

  Future<int> addEvent(EventsCompanion event) {
    return into(events).insert(event);
  }

  Future<List<Event>> fetchEvents() {
    return (select(events)).get();
  }

  Stream<List<Event>> watchEvents(EventState eventState, EventSort eventSort, OrderingMode orderingMode) {
    List<OrderingTerm Function($EventsTable)> clauses = [];

    switch (eventSort) {
      case EventSort.title:
        clauses.add((u) => OrderingTerm(expression: u.title, mode: orderingMode));
        break;
      case EventSort.date:
        clauses.add((u) => OrderingTerm(expression: u.date, mode: orderingMode));
      case EventSort.createdDate:
        clauses.add((u) => OrderingTerm(expression: u.createdDate, mode: orderingMode));
    }

    switch (eventState) {
      case EventState.all:
        return (select(events)..orderBy(clauses)).watch();
      case EventState.active:
        return (select(events)
              ..where((e) => e.isActive.equals(true))
              ..orderBy(clauses))
            .watch();
      case EventState.inactive:
        return (select(events)
              ..where((e) => e.isActive.equals(false))
              ..orderBy(clauses))
            .watch();
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'past_event_tracker.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}

Future<void> deleteDatabase() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'past_event_tracker.sqlite'));
  if (file.existsSync()) {
    final res = await file.delete();

    print(res.existsSync());
  }
}
