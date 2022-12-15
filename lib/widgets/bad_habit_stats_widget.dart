// External Dependencies 
import 'package:flutter/material.dart';

// Models
import 'package:rpg/controllers/bad_habit_occurrence_controller.dart';
import 'package:rpg/enum/chart_mode.dart';

// Widgets
import 'package:rpg/widgets/chart_modes_widget.dart';
import 'package:rpg/widgets/navigation_header.dart';
import 'package:rpg/widgets/statistics_item.dart';


class BadHabitStatsWidget extends StatefulWidget {
  final BadHabitOccurrenceController _badHabitOccurrenceController;

  const BadHabitStatsWidget(
    this._badHabitOccurrenceController,
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
        dataSource = widget._badHabitOccurrenceController.recentWeekBadHabitsOccurred;
        xKey = 'day';
        yKey = 'amount';
        break;
      }
      case ChartMode.thisMonth: {
        dataSource = widget._badHabitOccurrenceController.thisMonthBadHabitsOccurred;
        xKey = 'day';
        yKey = 'amount';
        break;
      }
      case ChartMode.thisYear: {
        dataSource = widget._badHabitOccurrenceController.thisYearBadHabitsOccurred;
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

  Widget _getMainWidget() => SingleChildScrollView(
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
              content: widget._badHabitOccurrenceController.mostActiveBadHabitTime
            ),

            StatisticsItem(
              title: 'Most Occurring Habit', 
              content: widget._badHabitOccurrenceController.mostOccurringBadHabit
            )
          ]
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatisticsItem(
              title: 'Avg. Bad Habit per Day', 
              content: widget._badHabitOccurrenceController.avgBadHabitPerDay.toStringAsFixed(1)
            ),
          ]
        ),
      ]
    ),
  );

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: widget._badHabitOccurrenceController.initializeOccurrences(),
    builder: (context, snapshot) {
      Widget widget = const Center(child: CircularProgressIndicator());
      if(snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data!.isNotEmpty) {
        widget = _getMainWidget();
      }
      else if(snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data!.isEmpty) {
        widget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: Image.asset('assets/images/empty-lists/bad-habits.png')
              ),
              const SizedBox(height: 20),
              Text(
                'No bad habits data yet!',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          )
        );
      }
      return widget;
    }
  );
  
}