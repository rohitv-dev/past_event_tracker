// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseHash() => r'0d6ebba8c0a72674b6d88e9b6df5b443111067fb';

/// See also [Database].
@ProviderFor(Database)
final databaseProvider =
    AutoDisposeNotifierProvider<Database, AppDatabase>.internal(
  Database.new,
  name: r'databaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$databaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Database = AutoDisposeNotifier<AppDatabase>;
String _$eventsSortHash() => r'ce9a9575ff64342d767dd8f545001e2ee6e5cb38';

/// See also [EventsSort].
@ProviderFor(EventsSort)
final eventsSortProvider =
    AutoDisposeNotifierProvider<EventsSort, EventSort>.internal(
  EventsSort.new,
  name: r'eventsSortProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsSortHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventsSort = AutoDisposeNotifier<EventSort>;
String _$eventsSortOrderHash() => r'fe64d6caa68525e3386595d214858485bb55c576';

/// See also [EventsSortOrder].
@ProviderFor(EventsSortOrder)
final eventsSortOrderProvider =
    AutoDisposeNotifierProvider<EventsSortOrder, OrderingMode>.internal(
  EventsSortOrder.new,
  name: r'eventsSortOrderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventsSortOrderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventsSortOrder = AutoDisposeNotifier<OrderingMode>;
String _$eventsListHash() => r'ae514e1583d7f70ce1f7dc9d9e37d3f731e8689d';

/// See also [EventsList].
@ProviderFor(EventsList)
final eventsListProvider =
    AutoDisposeStreamNotifierProvider<EventsList, List<Event>>.internal(
  EventsList.new,
  name: r'eventsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventsList = AutoDisposeStreamNotifier<List<Event>>;
String _$eventStateNotifierHash() =>
    r'4b35ebc3af6e86c5f2c99b93a33e3e3f0363c857';

/// See also [EventStateNotifier].
@ProviderFor(EventStateNotifier)
final eventStateNotifierProvider =
    AutoDisposeNotifierProvider<EventStateNotifier, EventState>.internal(
  EventStateNotifier.new,
  name: r'eventStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventStateNotifier = AutoDisposeNotifier<EventState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
