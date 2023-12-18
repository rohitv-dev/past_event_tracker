import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logger/logger.dart';
import 'package:past_event_tracker/components/dialogs/upsert_event_dialog.dart';
import 'package:past_event_tracker/database/database.dart';
import 'package:past_event_tracker/providers/database_provider.dart';
import 'package:past_event_tracker/utils/date_functions.dart';

class ViewEventDialog extends ConsumerWidget {
  final Event event;

  const ViewEventDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: event.isActive ? Colors.teal : Colors.red.shade700,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => UpsertEventDialog(mode: EventMode.edit, event: event),
                          );
                        },
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Delete Event",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                content: const Text("Are you sure you want to delete this event?"),
                                actions: [
                                  FilledButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.red),
                                    ),
                                    onPressed: () {
                                      if (context.mounted) Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  FilledButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.green),
                                    ),
                                    onPressed: () async {
                                      final res = await ref.read(databaseProvider).deleteEvent(event.id);
                                      Logger().d(res);
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                formatDate(event.date),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              if (event.description != null && event.description != "") ...[
                const Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  event.description ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
              const SizedBox(height: 15),
              Center(
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await HomeWidget.saveWidgetData<String>("event_title", event.title);
                    await HomeWidget.saveWidgetData<String>("event_time_elapsed", event.date.toIso8601String());
                    await HomeWidget.updateWidget(androidName: "EventTrackerWidget");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Widget updated")));
                    }
                  },
                  child: const Text("Add Event to Widget", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
