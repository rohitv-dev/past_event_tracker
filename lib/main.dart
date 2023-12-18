import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:past_event_tracker/pages/home.dart';
import 'package:workmanager/workmanager.dart';
import 'package:logger/logger.dart';

const oneMinuteUnique = "past_event_tracker.update_widget_task";
const oneMinuteTask = "past_event_tracker.update_widget_task_one_minute";
const oneOffTask = "past_event_tracker.update_widget_task_one_off";

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      switch (taskName) {
        case oneMinuteTask:
          await HomeWidget.updateWidget(androidName: "EventTrackerWidget");
          break;
        case oneOffTask:
          Logger().d("The hell mate");
      }
    } catch (err) {
      Logger().e(err.toString());
      throw Exception(err);
    }

    return Future.value(true);
  });
}

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == "refresh") {
    Logger().d("Refresh triggered");
    await HomeWidget.updateWidget(androidName: "EventTrackerWidget");
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerPeriodicTask(
    oneMinuteUnique,
    oneMinuteTask,
    frequency: const Duration(minutes: 30),
  );
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
