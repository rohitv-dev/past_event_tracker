package com.example.past_event_tracker

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.TextStyle
import java.util.Locale

/**
 * Implementation of App Widget functionality.
 */
class EventTrackerWidget : AppWidgetProvider() {
  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray
  ) {
    // There may be multiple widgets active, so update all of them
    for (appWidgetId in appWidgetIds) {
      updateAppWidget(context, appWidgetManager, appWidgetId)
    }
  }

  override fun onEnabled(context: Context) {
    // Enter relevant functionality for when the first widget is created
  }

  override fun onDisabled(context: Context) {
    // Enter relevant functionality for when the last widget is disabled
  }
}

fun timeElapsed(dt: String): String {
  val date = LocalDateTime.parse(dt)
  val now = LocalDateTime.now()

  val diff = Duration.between(date, now)
  val seconds = diff.seconds

  val minutes = ((seconds % (60 * 60)) / 60).toInt()
  val hours = ((seconds % (24 * 3600)) / 3600).toInt()
  val days = (seconds / (24 * 3600)).toInt()

  val minsStr = if (minutes > 0) "$minutes mins" else ""
  val hoursStr = if (hours > 0) "$hours hrs" else ""
  val daysStr = if (days == 1) "$days day" else if (days > 1) "$days days" else ""

  return listOf(daysStr, hoursStr, minsStr).filter { it.isNotEmpty() }.joinToString(", ")
}

fun formatDateFromString(dt: String): String {
  val date = LocalDateTime.parse(dt)

  val dayOfMonth = date.dayOfMonth
  val month = date.month.getDisplayName(TextStyle.FULL, Locale.ENGLISH)
  val year = date.year

  val daySuffix = when {
    dayOfMonth in 11..13 -> "th"
    dayOfMonth % 10 == 1 -> "st"
    dayOfMonth % 10 == 2 -> "nd"
    dayOfMonth % 10 == 3 -> "rd"
    else -> "th"
  }

  return "$dayOfMonth$daySuffix $month $year"
}

internal fun updateAppWidget(
  context: Context,
  appWidgetManager: AppWidgetManager,
  appWidgetId: Int
) {
  val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("pastEventTracker://refresh"))
  val widgetData = HomeWidgetPlugin.getData(context);
  val title = widgetData.getString("event_title", "Add an event to view the title");
  val timeElapsedStr = widgetData.getString("event_time_elapsed", "----");
  // Construct the RemoteViews object
  val views = RemoteViews(context.packageName, R.layout.event_tracker_widget)
  views.setTextViewText(R.id.event_title, "This is a very long text that is supposed to do something")
  views.setTextViewText(R.id.event_time_elapsed, timeElapsed(timeElapsedStr?: LocalDateTime.now().toString()))
//  views.setTextViewText(R.id.event_date, formatDateFromString(timeElapsedStr?: LocalDateTime.now().toString()))
  views.setOnClickPendingIntent(R.id.event_refresh_btn, refreshIntent)
//  views.setInt(R.id.event_root, "setAlpha", 150)

  // Instruct the widget manager to update the widget
  appWidgetManager.updateAppWidget(appWidgetId, views)
}