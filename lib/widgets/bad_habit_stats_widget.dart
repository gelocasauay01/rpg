// External Dependencies 
import 'package:flutter/material.dart';

// Models
import 'package:rpg/controllers/bad_habit_controller.dart';
import 'package:rpg/enum/chart_mode.dart';

// Widgets
import 'package:rpg/widgets/chart_modes_widget.dart';
import 'package:rpg/widgets/navigation_header.dart';
import 'package:rpg/widgets/statistics_item.dart';


class BadHabitStatsWidget extends StatefulWidget {
  final BadHabitController _badHabitController;

  const BadHabitStatsWidget(
    this._badHabitController,
    { super.key }
  );

  @override
  State<BadHabitStatsWidget> createState() => _BadHabitStatsWidgetState();
}

class _BadHabitStatsWidgetState extends State<BadHabitStatsWidget> {
  ChartMode _currentMode = ChartMode.thisWeek;

   Widget _showChart() {
    List dataSource;
    String xKey;
    String yKey;

    switch(_currentMode) {
      case ChartMode.thisWeek: {
        dataSource = widget._badHabitController.recentWeekBadHabitsOccurred;
        xKey = 'day';
        yKey = 'amount';
        break;
      }
      case ChartMode.thisMonth: {
        dataSource = widget._badHabitController.thisMonthBadHabitsOccurred;
        xKey = 'day';
        yKey = 'amount';
        break;
      }
      case ChartMode.thisYear: {
        dataSource = widget._badHabitController.thisYearBadHabitsOccurred;
        xKey = 'month';
        yKey = 'amount';
      }
    }
    

    return ChartModesWidget(
      currentMode: _currentMode, 
      dataSource: dataSource, 
      xKey: xKey, 
      yKey: yKey
    );
  }

  void _incrementMode(int value) {
    int nextIndex = _currentMode.index + value;
    int enumLength = ChartMode.values.length;

    if (nextIndex >= enumLength) {
      nextIndex = 0;
    }

    else if (nextIndex < 0) {
      nextIndex = enumLength - 1;
    }

    setState(() {
      _currentMode = ChartMode.values[nextIndex];
    });
  }

  String _getModeHeaderText() {
    String header;
    switch(_currentMode) {
      case ChartMode.thisWeek: {
        header = 'This Week';
        break;
      }

      case ChartMode.thisMonth: {
        header = 'This Month';
        break;
      }

      case ChartMode.thisYear: {
        header = 'This Year';
        break;
      }
    }
    return '$header Report';
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      children: [
        NavigationHeader(
          title: _getModeHeaderText(), 
          onNext: () => _incrementMode(1), 
          onPrev: () => _incrementMode(-1)
        ),
        _showChart(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatisticsItem(
              title: 'Most Time Occurrence', 
              content: widget._badHabitController.mostActiveBadHabitTime
            ),

            StatisticsItem(
              title: 'Most Occurring Habit', 
              content: widget._badHabitController.mostOccurringBadHabit
            )
          ]
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatisticsItem(
              title: 'Avg. Bad Habit per Day', 
              content: widget._badHabitController.avgBadHabitPerDay.toStringAsFixed(1)
            ),
          ]
        ),
      ]
    ),
  );
  
}