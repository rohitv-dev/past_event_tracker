import 'package:flutter/material.dart';
import 'package:past_event_tracker/database/database.dart';
import 'package:past_event_tracker/utils/date_functions.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onPressed;
  const EventCard({super.key, required this.event, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: event.isActive ? Colors.teal : Colors.red,
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    timeElapsed(event.date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Icon(
                event.isActive ? Icons.check_circle_outline : Icons.dangerous_outlined,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
