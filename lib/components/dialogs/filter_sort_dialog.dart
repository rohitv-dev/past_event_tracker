import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:past_event_tracker/database/database.dart';
import 'package:past_event_tracker/providers/database_provider.dart';

class FilterSortDialog extends ConsumerStatefulWidget {
  const FilterSortDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterSortDialogState();
}

class _FilterSortDialogState extends ConsumerState<FilterSortDialog> {
  @override
  Widget build(BuildContext context) {
    var eventState = ref.watch(eventStateNotifierProvider);
    var eventSort = ref.watch(eventsSortProvider);
    var eventOrder = ref.watch(eventsSortOrderProvider);

    return Container(
      child: Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, color: Colors.grey.shade700),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Event State",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    runSpacing: -5,
                    children: [
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<EventState>(
                            visualDensity: VisualDensity.compact,
                            value: EventState.all,
                            groupValue: eventState,
                            onChanged: (value) {
                              if (value == null) return;
                              ref.read(eventStateNotifierProvider.notifier).state = value;
                            },
                          ),
                          const Text("All"),
                          const SizedBox(width: 10),
                        ],
                      ),
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<EventState>(
                            visualDensity: VisualDensity.compact,
                            value: EventState.active,
                            groupValue: eventState,
                            onChanged: (value) {
                              if (value == null) return;
                              ref.read(eventStateNotifierProvider.notifier).state = value;
                            },
                          ),
                          const Text("Active"),
                          const SizedBox(width: 10),
                        ],
                      ),
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<EventState>(
                            visualDensity: VisualDensity.compact,
                            value: EventState.inactive,
                            groupValue: eventState,
                            onChanged: (value) {
                              if (value == null) return;
                              ref.read(eventStateNotifierProvider.notifier).state = value;
                            },
                          ),
                          const Text("Inactive"),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Sort by",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runSpacing: -5,
                children: [
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<EventSort>(
                        visualDensity: VisualDensity.compact,
                        value: EventSort.title,
                        groupValue: eventSort,
                        onChanged: (value) {
                          if (value == null) return;
                          ref.read(eventsSortProvider.notifier).state = value;
                        },
                      ),
                      const Text("Title"),
                    ],
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<EventSort>(
                        visualDensity: VisualDensity.compact,
                        value: EventSort.date,
                        groupValue: eventSort,
                        onChanged: (value) {
                          if (value == null) return;
                          ref.read(eventsSortProvider.notifier).state = value;
                        },
                      ),
                      const Text("Date"),
                    ],
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<EventSort>(
                        visualDensity: VisualDensity.compact,
                        value: EventSort.createdDate,
                        groupValue: eventSort,
                        onChanged: (value) {
                          if (value == null) return;
                          ref.read(eventsSortProvider.notifier).state = value;
                        },
                      ),
                      const Text("Created Date"),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    "Order",
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Radio<drift.OrderingMode>(
                            visualDensity: VisualDensity.compact,
                            value: drift.OrderingMode.asc,
                            groupValue: eventOrder,
                            onChanged: (value) {
                              if (value == null) return;
                              ref.read(eventsSortOrderProvider.notifier).state = value;
                            },
                          ),
                          const Text("Ascending"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<drift.OrderingMode>(
                            visualDensity: VisualDensity.compact,
                            value: drift.OrderingMode.desc,
                            groupValue: eventOrder,
                            onChanged: (value) {
                              if (value == null) return;
                              ref.read(eventsSortOrderProvider.notifier).state = value;
                            },
                          ),
                          const Text("Descending"),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
