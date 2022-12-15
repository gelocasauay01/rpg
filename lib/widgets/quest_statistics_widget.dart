// External Dependencies
import 'package:flutter/material.dart';
import 'package:rpg/widgets/chart_modes_widget.dart';

// Models
import 'package:rpg/enum/chart_mode.dart';
import 'package:rpg/controllers/quest_history_controller.dart';
import 'package:rpg/widgets/empty_list_display.dart';
import 'package:rpg/widgets/navigation_header.dart';

// Widgets
import 'package:rpg/widgets/statistics_item.dart';

class QuestStatisticsWidget extends StatefulWidget {
  final QuestHistoryController _questHistoryController;

  const QuestStatisticsWidget(
    this._questHistoryController,
    { super.key }
  );

  @override
  State<QuestStatisticsWidget> createState() => _QuestStatisticsWidgetState();
}

class _QuestStatisticsWidgetState extends State<QuestStatisticsWidget> {

  ChartMode _currentMode = ChartMode.thisWeek;

  Widget _showChart() {
    List dataSource;
    String xKey;
    String yKey;

    switch(_currentMode) {
      case ChartMode.thisWeek: {
        dataSource = widget._questHistoryController.recentWeekQuestFinished;
        xKey = 'day';
        yKey = 'amount';
        break;
      }
      case ChartMode.thisMonth: {
        dataSource = widget._questHistoryController.thisMonthQuestFinished;
        xKey = 'day';
        yKey = 'amount';
        break;
      }
      case ChartMode.thisYear: {
        dataSource = widget._questHistoryController.thisYearQuestFinished;
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

  Widget getMainWidget() => Column(
    children: [
      NavigationHeader(
        title: _getModeHeaderText(), 
        onNext: () => _incrementMode(1), 
        onPrev: () => _incrementMode(1)
      ),

      _showChart(),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatisticsItem(
            title: 'Total Finished Quests', 
            content: widget._questHistoryController.getFilteredQuestsCount(true).toString()
          ),
          StatisticsItem(
            title: 'Total Failed Quests', 
            content: widget._questHistoryController.getFilteredQuestsCount(false).toString()
          )
        ],
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        StatisticsItem(
            title: 'Completion Rate', 
            content: '${widget._questHistoryController.questCompletionRate.round().toString()}%'
          ),
          StatisticsItem(
            title: 'Productive Week Day', 
            content: widget._questHistoryController.mostProductiveWeekDay
          )
        ],
      ),

    ],
  );
  
  
  @override
  void dispose() {
    widget._questHistoryController.disposeQuestHistory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: widget._questHistoryController.initializeQuestHistory(),
    builder: (context, snapshot) {
      Widget returnedWidget = const Center(child: CircularProgressIndicator());

      if(snapshot.connectionState == ConnectionState.done && !widget._questHistoryController.isEmpty) {
        returnedWidget = getMainWidget();
      }

      else if (snapshot.connectionState == ConnectionState.done && widget._questHistoryController.isEmpty) {
        returnedWidget = const Center(
          child: EmptyListDisplay(
            assetFilePath: 'assets/images/empty-lists/quest-stats.png', 
            text: 'No quest data yet!'
          )
        );
      }

      return returnedWidget;
    }
  );

}