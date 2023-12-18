import 'package:intl/intl.dart';

String formatDate(DateTime dt) {
  return DateFormat("d MMM y, h:m a").format(dt);
}

String timeElapsed(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  final s = diff.inSeconds;

  // final seconds = s % 60;
  final minutes = (s % (60 * 60)) ~/ 60;
  final hours = (s % (24 * 3600)) ~/ 3600;
  final days = s ~/ (24 * 3600);

  final minsStr = (minutes > 0) ? "$minutes mins" : "";
  final hoursStr = (hours > 0) ? "$hours hrs" : "";
  final daysStr = (days > 0) ? "$days days" : "";

  return [daysStr, hoursStr, minsStr].where((v) => v.isNotEmpty).join(", ");
}
