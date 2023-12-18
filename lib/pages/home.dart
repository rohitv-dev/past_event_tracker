import 'dart:math';

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:past_event_tracker/components/dialogs/filter_sort_dialog.dart';
import 'package:past_event_tracker/components/dialogs/view_event_dialog.dart';
import 'package:past_event_tracker/components/event_card.dart';
import 'package:past_event_tracker/database/database.dart';
import 'package:past_event_tracker/components/dialogs/upsert_event_dialog.dart';
import 'package:past_event_tracker/providers/database_provider.dart';

String generateRandomString(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final eventsList = ref.watch(eventsListProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        title: const Text(
          "Time Since",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              // await deleteDatabase();
              var rng = Random();
              for (int i = 0; i < 50; i++) {
                var event = EventsCompanion.insert(
                  title: generateRandomString(10),
                  date: DateTime.now().subtract(
                    Duration(
                      days: rng.nextInt(10) + 1,
                      hours: rng.nextInt(5) + 2,
                      minutes: rng.nextInt(30),
                    ),
                  ),
                  isActive: d.Value(true),
                );
                await ref.read(databaseProvider).addEvent(event);
              }
              // await HomeWidget.saveWidgetData<String>("event_title", "Obama");

              // await HomeWidget.saveWidgetData<String>(
              //   "event_time_elapsed",
              //   DateTime.now()
              //       .subtract(
              //         Duration(
              //           days: rng.nextInt(10) + 1,
              //           hours: rng.nextInt(5) + 2,
              //           minutes: rng.nextInt(30),
              //         ),
              //       )
              //       .toIso8601String(),
              // );
              // await HomeWidget.updateWidget(androidName: "EventTrackerWidget");
            },
            child: const Icon(Icons.dangerous, color: Colors.red),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const FilterSortDialog();
                },
              );
            },
            child: const Icon(Icons.more_vert),
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const UpsertEventDialog(mode: EventMode.add),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: eventsList.when(
        error: (e, s) {
          return Center(
            child: Column(
              children: [
                const Text("An error has occurred"),
                const SizedBox(height: 10),
                Text(e.toString()),
              ],
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        data: (events) {
          return Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 20,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return EventCard(
                  event: event,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ViewEventDialog(event: event),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
