class Event {
  const Event(
      {required this.id, required this.title, required this.description, required this.date, required this.isActive});

  final int id;
  final String title;
  final String? description;
  final DateTime date;
  final bool isActive;
}

extension EventsExtension on List<Event> {
  List<Event> filterByActive() {
    return where((event) => event.isActive).toList();
  }

  List<Event> filterByInactive() {
    return where((event) => !event.isActive).toList();
  }
}
