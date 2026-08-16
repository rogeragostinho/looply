package com.velami.looply

// ATENÇÃO: ajuste o "package" acima para o applicationId real do seu
// android/app/build.gradle (ex.: com.suaempresa.looply), e mova este
// ficheiro para a pasta kotlin correspondente a esse package.

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Widget "Revisões de Hoje e Pendentes" do Looply.
 *
 * Apenas lê os valores já calculados e gravados pelo lado Dart
 * (LooplyWidgetService) através do HomeWidgetPlugin — não faz nenhuma
 * lógica de negócio aqui, mantendo o widget leve e simples.
 */
class LooplyWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            updateWidget(context, appWidgetManager, widgetId)
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val todayCount = widgetData.getInt("today_count", 0)
        val pendingCount = widgetData.getInt("pending_count", 0)
        val allDone = todayCount == 0 && pendingCount == 0

        val views = RemoteViews(context.packageName, R.layout.looply_widget).apply {
            setTextViewText(R.id.widget_today_value, todayCount.toString())
            setTextViewText(R.id.widget_pending_value, pendingCount.toString())
            setViewVisibility(
                R.id.widget_all_done,
                if (allDone) View.VISIBLE else View.GONE
            )
        }

        appWidgetManager.updateAppWidget(widgetId, views)
    }
}
