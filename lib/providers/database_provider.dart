import "package:drift/drift.dart";
import "package:past_event_tracker/database/database.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part 'database_provider.g.dart';

@riverpod
class Database extends _$Database {
  @override
  AppDatabase build() {
    return AppDatabase();
  }
}

@riverpod
class EventsSort extends _$EventsSort {
  @override
  EventSort build() {
    return EventSort.createdDate;
  }
}

@riverpod
class EventsSortOrder extends _$EventsSortOrder {
  @override
  OrderingMode build() {
    return OrderingMode.asc;
  }
}

@riverpod
class EventsList extends _$EventsList {
  @override
  Stream<List<Event>> build() {
    final database = ref.watch(databaseProvider);
    final eventSelect = ref.watch(eventStateNotifierProvider);
    final eventSort = ref.watch(eventsSortProvider);
    final orderingMode = ref.watch(eventsSortOrderProvider);
    return database.watchEvents(eventSelect, eventSort, orderingMode);
  }
}

@riverpod
class EventStateNotifier extends _$EventStateNotifier {
  @override
  EventState build() {
    return EventState.all;
  }
}
