// External Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

// Models
import 'package:rpg/enum/difficulty.dart';
import 'package:rpg/models/quest.dart';
import 'package:rpg/models/quest_history.dart';
import 'package:rpg/controllers/db_controller.dart';


class QuestHistoryController with ChangeNotifier{
  List<QuestHistory> _questHistoryList = [];

  QuestHistoryController();

  bool get isEmpty {
    return _questHistoryList.isEmpty;
  }

  List get recentWeekQuestFinished {
    const int numberOfDaysInAWeek = 7;
    return List.generate(numberOfDaysInAWeek, (day) {

      DateTime weekDay = DateTime.now().subtract(Duration(days: numberOfDaysInAWeek - day - 1));
      int questFinished = 0;

      for(QuestHistory questHistory in _questHistoryList) {
        if(questHistory.isFinished && DateUtils.isSameDay(questHistory.dateFinished, weekDay)) {
          questFinished += 1;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': questFinished
      };

    });
  } 

  List get thisMonthQuestFinished {
    DateTime now = DateTime.now();
    int numberOfDaysInAMonth = DateUtils.getDaysInMonth(now.year, now.month);
    return List.generate(numberOfDaysInAMonth, (day) {

      DateTime currentDayIntheMonth = DateTime(now.year, now.month, day + 1);
      int questFinished = 0;

      for(QuestHistory questHistory in _questHistoryList) {
        if(questHistory.isFinished && DateUtils.isSameDay(questHistory.dateFinished, currentDayIntheMonth)) {
          questFinished += 1;
        }
      }

      return {
        'day': currentDayIntheMonth.day,
        'amount': questFinished
      };

    });
  } 

  List get thisYearQuestFinished {
    const int numberOfMonthsInAYear = 12;
    DateTime now = DateTime.now();
    return List.generate(numberOfMonthsInAYear, (monthIndex) {

      DateTime currentMonth = DateTime(now.year, monthIndex + 1);
      int questFinished = 0;

      for(QuestHistory questHistory in _questHistoryList) {
        if(questHistory.isFinished && DateUtils.isSameMonth(questHistory.dateFinished, currentMonth)) {
          questFinished += 1;
        }
      }

      return {
        'month': currentMonth.month,
        'amount': questFinished
      };

    });
  } 

  double get questCompletionRate {
    int numberOfCompleteQuests = 0;
    double completionRate = 0.0;
    
    if(_questHistoryList.isNotEmpty) {
      for(QuestHistory questHistory in _questHistoryList) {
        if(questHistory.isFinished) {
          numberOfCompleteQuests += 1;
        }
      }
      completionRate = numberOfCompleteQuests / _questHistoryList.length * 100.0;
    }
    return completionRate;
  }

  String get mostProductiveWeekDay {
    String productiveDayName = 'None';
    
    if(_questHistoryList.isNotEmpty) {
      // initializes and sorts quest history by week day
      List<QuestHistory> questHistoryList = getQuestHistoryList(sortMode: (QuestHistory current, QuestHistory next) => current.dateFinished.weekday.compareTo(next.dateFinished.weekday));
      int highestCount = 0;
      int currentQuestCompletedCount = 0;
      int currentWeekDay = 1;
      DateTime previousDate = questHistoryList[0].dateFinished;
      
      for(QuestHistory questHistory in questHistoryList) {
        // If week day has changed, check if it finds a higher count, reset the current count to zero, and set the current week day
        if(questHistory.dateFinished.weekday != currentWeekDay) {
          if(currentQuestCompletedCount >= highestCount) {
            productiveDayName = DateFormat.EEEE().format(previousDate); // Get the week day name
            highestCount = currentQuestCompletedCount;
          }
          currentQuestCompletedCount = 0;
          currentWeekDay = questHistory.dateFinished.weekday;
        }

        if(questHistory.isFinished) {
          currentQuestCompletedCount += 1;
        }

        previousDate = questHistory.dateFinished;
      }
    }
    
    return productiveDayName; 
  }

  Future<void> initializeQuestHistory() async {
    Database database = await DBController.instance.database;
    List<Map<String, dynamic>> json = await database.query('QuestHistory');
    
    if(json.isNotEmpty) {
      _questHistoryList = json.map(
        (data) => QuestHistory.fromJSON(data)
      ).toList();
    }
    
  }

  void disposeQuestHistory() {
    _questHistoryList = [];
  }

  int getFilteredQuestsCount(bool isComplete) {
    int totalFinishedQuests = 0;

    for(QuestHistory questHistory in _questHistoryList) {
      if(questHistory.isFinished == isComplete) {
        totalFinishedQuests += 1;
      }
    }

    return totalFinishedQuests;
  }

  List<QuestHistory> getQuestHistoryList({Function? sortMode}) {
    List<QuestHistory> questHistoryList = [..._questHistoryList];

    if(sortMode != null) {
      questHistoryList.sort((current, next) => sortMode(current, next));
    } 
    
    return questHistoryList;
  }

  Future<void> addQuestHistories(bool isFinished, List<Quest> quests) async {
    Database database = await DBController.instance.database;
    Batch batch = database.batch();

    for(Quest quest in quests) {
      batch.insert(
        'QuestHistory', 
        createHistoryJson(
          isFinished: isFinished, 
          difficulty: quest.difficulty
        )
      );
    }

    await batch.commit();
  }

  Future<void> addQuestHistory({required bool isFinished, required Difficulty difficulty}) async {
    Database database = await DBController.instance.database;
    await database.insert(
      'QuestHistory', 
      createHistoryJson(isFinished: isFinished, difficulty: difficulty)
    );
  }

  Map<String, dynamic> createHistoryJson({required bool isFinished, required Difficulty difficulty}) {
    return {
      'DateFinished': DateTime.now().toIso8601String(),
      'IsFinished': isFinished ? 1 : 0,
      'Difficulty': difficulty.index
    };
  }


}