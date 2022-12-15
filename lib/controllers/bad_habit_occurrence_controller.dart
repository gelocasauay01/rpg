// External Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

// Utils
import 'package:rpg/utils/map_utils.dart';

// Models
import 'package:rpg/controllers/db_controller.dart';
import 'package:rpg/models/bad_habit_occurrence.dart';



class BadHabitOccurrenceController with ChangeNotifier {

  List<BadHabitOccurrence> _occurrences = [];
  Map<int, String> _badHabitNames = {};

  List<Map<String, dynamic>> get recentWeekBadHabitsOccurred {
    const int numberOfDaysInAWeek = 7;
    return List.generate(numberOfDaysInAWeek, (day) {

      DateTime weekDay = DateTime.now().subtract(Duration(days: numberOfDaysInAWeek - day - 1));
      int badHabitsOccurred = 0;

      for(BadHabitOccurrence occurrence in _occurrences) {
        if(DateUtils.isSameDay(occurrence.dateOccurred, weekDay)) {
          badHabitsOccurred += 1;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': badHabitsOccurred
      };

    });
  } 

  List get thisMonthBadHabitsOccurred {
    DateTime now = DateTime.now();
    int numberOfDaysInAMonth = DateUtils.getDaysInMonth(now.year, now.month);
    return List.generate(numberOfDaysInAMonth, (day) {
      DateTime currentDayIntheMonth = DateTime(now.year, now.month, day + 1);
      int badHabitsOccurred = 0;
      for(BadHabitOccurrence occurrence in _occurrences) {
        if(DateUtils.isSameDay(occurrence.dateOccurred, currentDayIntheMonth)) {
          badHabitsOccurred += 1;
        }
      }
      return {
        'day': currentDayIntheMonth.day,
        'amount': badHabitsOccurred
      };
    });
  }

  List get thisYearBadHabitsOccurred {
    const int numberOfMonthsInAYear = 12;
    DateTime now = DateTime.now();
    return List.generate(numberOfMonthsInAYear, (monthIndex) {
      DateTime currentMonth = DateTime(now.year, monthIndex + 1);
      int badHabitsOccurred = 0;
      for(BadHabitOccurrence occurrence in _occurrences) {
        if(DateUtils.isSameMonth(occurrence.dateOccurred, currentMonth)) {
          badHabitsOccurred += 1;
        }
      }
      return {
        'month': currentMonth.month,
        'amount': badHabitsOccurred
      };
    });
  }

  String get mostActiveBadHabitTime {
    Map<String, int> partsOfTheDay = {
      'Morning': 0,
      'Afternoon': 0,
      'Evening': 0,
      'Night': 0
    };
    for(BadHabitOccurrence occurrence in _occurrences) {
      if(occurrence.dateOccurred.hour == 24 || occurrence.dateOccurred.hour <= 4) {
        partsOfTheDay['Night'] = partsOfTheDay['Night']! + 1;
      }

      else if(occurrence.dateOccurred.hour >= 4 && occurrence.dateOccurred.hour <= 11) {
        partsOfTheDay['Morning'] = partsOfTheDay['Morning']! + 1;
      }

      else if(occurrence.dateOccurred.hour >= 12 && occurrence.dateOccurred.hour <= 17) {
        partsOfTheDay['Afternoon'] = partsOfTheDay['Afternoon']! + 1;
      }

      else if(occurrence.dateOccurred.hour >= 18 && occurrence.dateOccurred.hour <= 23){
        partsOfTheDay['Evening'] = partsOfTheDay['Evening']! + 1;
      }
    }
    return MapUtils.getKeyOfMaxValue(partsOfTheDay);  
  } 
  
  String get mostOccurringBadHabit {
    String mostOccurringBadHabit = 'None';
    List<BadHabitOccurrence> occurrences = [..._occurrences];
    int currentId = -1;
    int currentCount = 0;
    int highestHabitId = -1;
    int highestCount = 0;
    occurrences.sort((current, next) => current.badHabitId.compareTo(next.badHabitId));
    for(BadHabitOccurrence occurrence in occurrences) {
      if(currentId != occurrence.badHabitId) {
        currentId = occurrence.badHabitId;
        if(currentCount >= highestCount) {
          highestCount = currentCount;
          highestHabitId = currentId;
        }
        currentCount = 0;
      }
      currentCount += 1;
    }
    if(highestHabitId != -1 && _badHabitNames.containsKey(highestHabitId)) {
      mostOccurringBadHabit = _badHabitNames[highestHabitId]!;
    }
    return mostOccurringBadHabit;
  }

  double get avgBadHabitPerDay {
    List<DateTime> occurrences = _occurrences.map((occurrence) => occurrence.dateOccurred).toList();
    double average = 0.0;

    occurrences.sort(); // Sort to easily access the earliest date

    if(occurrences.isNotEmpty) {
      int totalBadHabitsOccurred = occurrences.length;
      int dayCount = DateTime.now().difference(occurrences.first).inDays + 1; // Get the earliest date and subtract it from the present date
      if(dayCount > 0) {
        average = totalBadHabitsOccurred / dayCount;
      }
    }
    
    return average;
  }

  Future<List<BadHabitOccurrence>> initializeOccurrences() async {
    Database database = await DBController.instance.database;
    List<Map<String, dynamic>> occurenceJson = await database.query('BadHabitOccurrence');
    List<Map<String, dynamic>> badHabitJson = await database.query('BadHabit');
    Map<int, String> badHabitNames = {};

    _occurrences = occurenceJson.map((data) => BadHabitOccurrence.fromJSON(data)).toList();
    for(Map<String, dynamic> data in badHabitJson) {
      badHabitNames[data['Id'] as int] = data['Title'] as String;
    }
    _badHabitNames = badHabitNames;
    return [..._occurrences];
  }
}