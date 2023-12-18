import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:past_event_tracker/database/database.dart';
import 'package:past_event_tracker/providers/database_provider.dart';
import 'package:past_event_tracker/utils/date_functions.dart';

class UpsertEventDialog extends ConsumerStatefulWidget {
  const UpsertEventDialog({super.key, required this.mode, this.event});

  final EventMode mode;
  final Event? event;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<UpsertEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  bool isActive = true;
  DateTime? dateTime;

  @override
  void initState() {
    if (widget.mode == EventMode.edit && widget.event != null) {
      titleController.text = widget.event!.title;
      descController.text = widget.event!.description ?? "";
      isActive = widget.event!.isActive;
      dateTime = widget.event!.date;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.mode == EventMode.add ? "Add Event" : "Edit Event",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, color: Colors.grey.shade700),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 10,
                      ),
                    ),
                    hintText: "Enter the title",
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                  validator: (String? value) {
                    if (value == "" || value == null) return "Title cannot be empty";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDateTime = await showOmniDateTimePicker(
                      context: context,
                      barrierDismissible: true,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    );

                    if (selectedDateTime != null) {
                      setState(() {
                        dateTime = selectedDateTime;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 10),
                        if (dateTime == null) ...[
                          Text(
                            "Select Date & Time",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                            ),
                          )
                        ],
                        if (dateTime != null) ...[Text(formatDate(dateTime!))]
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 10,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Enter the description",
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text("Active"),
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) isActive = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                FilledButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && dateTime != null) {
                      try {
                        if (widget.mode == EventMode.edit) {
                          final event = EventsCompanion(
                            id: d.Value(widget.event!.id),
                            title: d.Value(titleController.text),
                            date: d.Value(dateTime!),
                            isActive: d.Value(isActive),
                            description: d.Value(descController.text),
                          );

                          await database.updateEvent(event);
                        } else if (widget.mode == EventMode.add) {
                          final event = EventsCompanion.insert(
                            title: titleController.text,
                            date: dateTime!,
                            isActive: d.Value(isActive),
                          );

                          await database.addEvent(event);
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${widget.mode == EventMode.add ? "Added" : "Updated"} event successfully"),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      } catch (err) {
                        Logger().e(err.toString());
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong"),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
