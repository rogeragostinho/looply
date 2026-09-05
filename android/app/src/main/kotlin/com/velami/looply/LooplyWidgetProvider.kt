package com.velami.looply

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.util.Calendar
import android.content.res.Configuration
import androidx.core.content.ContextCompat

class LooplyWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val ACTION_MIDNIGHT_REFRESH =
            "com.velami.looply.ACTION_MIDNIGHT_REFRESH"

        /** Agenda um alarme para pouco depois da meia-noite seguinte.
         *  Usa setAndAllowWhileIdle (não exato) para não precisar de
         *  nenhuma permissão especial, mas ainda assim acordar o
         *  dispositivo mesmo em Doze — ao contrário do DATE_CHANGED
         *  passivo, que pode atrasar com o ecrã apagado. */
        fun scheduleNextMidnightAlarm(context: Context) {
            val alarmManager =
                context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

            val intent = Intent(context, LooplyWidgetProvider::class.java).apply {
                action = ACTION_MIDNIGHT_REFRESH
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val next = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 1) // 00:01 dá uma folga de segurança
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }

            alarmManager.setAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                next.timeInMillis,
                pendingIntent
            )
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        when (intent.action) {
            Intent.ACTION_DATE_CHANGED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            Intent.ACTION_BOOT_COMPLETED,
            ACTION_MIDNIGHT_REFRESH -> {
                val manager = AppWidgetManager.getInstance(context)
                val ids = manager.getAppWidgetIds(
                    ComponentName(context, LooplyWidgetProvider::class.java)
                )
                onUpdate(context, manager, ids)
                // reagenda sempre — cobre o dia seguinte, incluindo após reboot
                scheduleNextMidnightAlarm(context)
            }
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        scheduleNextMidnightAlarm(context) // primeira vez que o widget é adicionado
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val data = HomeWidgetPlugin.getData(context)
        val raw = data.getString("pending_dates", "") ?: ""
        val dates = raw.split(",").mapNotNull { it.toLongOrNull() }

        val startOfToday = todayStartMillis()
        val startOfTomorrow = startOfToday + 24 * 60 * 60 * 1000

        val todayCount = dates.count { it in startOfToday until startOfTomorrow }
        val pendingCount = dates.count { it < startOfToday }

        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.looply_widget)
            views.setTextViewText(R.id.widget_today_value, todayCount.toString())
            views.setTextViewText(R.id.widget_pending_value, pendingCount.toString())

            val launchIntent = context.packageManager
                .getLaunchIntentForPackage(context.packageName)?.apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }

            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(id, views)
        }

        // Garante que há sempre um alarme agendado, independentemente de
        // onEnabled ter corrido ou não (ex.: widget já existia antes desta
        // versão do código, ou o alarme falhou por algum motivo).
        scheduleNextMidnightAlarm(context)
    }

    private fun todayStartMillis(): Long {
        val cal = Calendar.getInstance()
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        cal.set(Calendar.MILLISECOND, 0)
        return cal.timeInMillis
    }
}