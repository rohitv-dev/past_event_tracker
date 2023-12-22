import 'dart:math';

import 'package:past_event_tracker/database/database.dart';
import 'package:past_event_tracker/utils/string_functions.dart';
import 'package:drift/drift.dart';

List<EventsCompanion> generateEvents(int count) {
  List<EventsCompanion> events = [];

  var rng = Random();
  for (int i = 0; i < count; i++) {
    var event = EventsCompanion.insert(
      title: generateRandomString(10),
      date: DateTime.now().subtract(
        Duration(
          days: rng.nextInt(10) + 1,
          hours: rng.nextInt(5) + 2,
          minutes: rng.nextInt(30),
        ),
      ),
      isActive: Value(true),
    );
    events.add(event);
  }

  return events;
}
