// External Dependencies
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Models
import 'package:rpg/enum/chart_mode.dart';


class ChartModesWidget extends StatelessWidget {
  final ChartMode currentMode;
  final List dataSource;
  final String xKey;
  final String yKey;

  const ChartModesWidget({ 
    required this.currentMode,
    required this.dataSource,
    required this.xKey,
    required this.yKey,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Widget chart;

    switch(currentMode) {
      case ChartMode.thisWeek: {
        chart = SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            ColumnSeries(
              dataSource: dataSource,
              xValueMapper: (weekTransaction, _) => weekTransaction[xKey],
              yValueMapper: (weekTransaction, _) => weekTransaction[yKey],
            )
          ],
        );
        break;
      }

      default: {
        chart = SfCartesianChart(
          series: <ChartSeries>[
            LineSeries(
              dataSource: dataSource,
              xValueMapper: (monthTransaction, _) => monthTransaction[xKey],
              yValueMapper: (monthTransaction, _) => monthTransaction[yKey],
            )
          ],
        );
        break;
      }
    }

    return chart;
  }
}