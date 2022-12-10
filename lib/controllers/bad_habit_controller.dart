//External Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

//Models
import 'package:rpg/utils/map_utils.dart';
import 'package:rpg/dto/bad_habit_dto.dart';
import 'package:rpg/models/bad_habit.dart';
import 'package:rpg/controllers/db_controller.dart';

class BadHabitController with ChangeNotifier{
  List<BadHabit> _badHabits = [];

  List<BadHabit> get badHabits {
    return [..._badHabits];
  }

  List get recentWeekBadHabitsOccurred {
    const int numberOfDaysInAWeek = 7;
    return List.generate(numberOfDaysInAWeek, (day) {

      DateTime weekDay = DateTime.now().subtract(Duration(days: numberOfDaysInAWeek - day - 1));
      int badHabitsOccurred = 0;

      for(BadHabit badHabit in _badHabits) {
        if(badHabit.occurrences != null) {
          for(DateTime occurrence in badHabit.occurrences!) {
            if(DateUtils.isSameDay(occurrence, weekDay)) {
              badHabitsOccurred += 1;
            }
          }
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

      for(BadHabit badHabit in _badHabits) {
        if(badHabit.occurrences != null) {
          for(DateTime occurrence in badHabit.occurrences!) {
            if(DateUtils.isSameDay(occurrence, currentDayIntheMonth)) {
              badHabitsOccurred += 1;
            }
          }
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

      for(BadHabit badHabit in _badHabits) {
        if(badHabit.occurrences != null) {
          for(DateTime occurrence in badHabit.occurrences!) {
            if(DateUtils.isSameMonth(occurrence, currentMonth)) {
              badHabitsOccurred += 1;
            }
          }
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

    for(BadHabit badHabit in _badHabits) {
      if(badHabit.occurrences != null) {
        for(DateTime occurrence in badHabit.occurrences!) {
          if(occurrence.hour == 24 || occurrence.hour <= 4) {
            partsOfTheDay['Night'] = partsOfTheDay['Night']! + 1;
          }

          else if(occurrence.hour >= 4 && occurrence.hour <= 11) {
            partsOfTheDay['Morning'] = partsOfTheDay['Morning']! + 1;
          }

          else if(occurrence.hour >= 12 && occurrence.hour <= 17) {
            partsOfTheDay['Afternoon'] = partsOfTheDay['Afternoon']! + 1;
          }

          else if(occurrence.hour >= 18 && occurrence.hour <= 23){
            partsOfTheDay['Evening'] = partsOfTheDay['Evening']! + 1;
          }
        }
      }
    }

    return MapUtils.getKeyOfMaxValue(partsOfTheDay);  
  } 
  
  String get mostOccurringBadHabit {
    String mostOccurringBadHabit = 'None';
    int highestCount = 0;
    for(BadHabit badHabit in _badHabits) {
      if(badHabit.occurrences != null && badHabit.occurrences!.length > highestCount) {
        mostOccurringBadHabit = badHabit.title;
      }
    }
    return mostOccurringBadHabit;
  }

  double get avgBadHabitPerDay {
    List occurrences = [];
    double average = 0.0;

    for(BadHabit badHabit in _badHabits) {
      if(badHabit.occurrences != null) {
        for(DateTime occurrence in badHabit.occurrences!) {
          occurrences.add(occurrence);
        }
      }
    }

    occurrences.sort(); // Sort to easily access the earliest date

    if(occurrences.isNotEmpty) {
      const int firstElement = 0;
      int totalBadHabitsOccurred = occurrences.length;
      int dayCount = DateTime.now().difference(occurrences[firstElement]).inDays + 1; // Get the earliest date and subtract it from the present date
      if(dayCount > 0) {
        average = totalBadHabitsOccurred / dayCount;
      }
      
    }
    
    return average;
  }

  Future<void> initializeBadHabits() async {
    Database database = await DBController.instance.database;
    List<BadHabit> badHabits = [];
    List<Map<String, dynamic>> json = await database.query('BadHabit');

    for(Map<String, dynamic> data in json) {
      List<Map<String, dynamic>> occurrencesJSON = await database.query('BadHabitOccurrence', where: 'BadHabitId = ?', whereArgs: [data['Id']]);
      List<DateTime> occurrences = occurrencesJSON.map((occurrence) => DateTime.parse(occurrence['DateOccurred'])).toList();
      badHabits.add(BadHabit.fromJSON(data, occurrences: occurrences));
    }

    _badHabits = badHabits;
    notifyListeners();
  }

  BadHabit getBadHabitById(int id) {
    return badHabits.firstWhere((badHabit) => badHabit.id == id);
  }

  Future<void> addBadHabit(BadHabitDTO newBadHabitDTO) async {

    if(newBadHabitDTO.title == null || newBadHabitDTO.title!.isEmpty || newBadHabitDTO.title!.length <= 3) {
      return;
    }

    Database database = await DBController.instance.database;
    int badHabitId = await database.insert('BadHabit', newBadHabitDTO.toJSON());
    BadHabit newBadHabit = BadHabit(
      id: badHabitId, 
      title: newBadHabitDTO.title!,
      damage: newBadHabitDTO.damage,
    );
  
    _badHabits.add(newBadHabit);
    notifyListeners();
  }

  Future<void> updateBadHabit(int badHabitId, BadHabitDTO updatedBadHabitDTO) async {
    int index = _badHabits.indexWhere((badHabit) => badHabit.id == badHabitId);

    if(index == -1 || updatedBadHabitDTO.title!.isEmpty || updatedBadHabitDTO.title!.length <= 3) {
      return;
    }

    Database database = await DBController.instance.database;
    await database.update('BadHabit', updatedBadHabitDTO.toJSON(), where: 'Id = ?', whereArgs: [badHabitId]);
    BadHabit updatedBadHabit = BadHabit(
      id: badHabitId,
      title: updatedBadHabitDTO.title!,
      damage: updatedBadHabitDTO.damage,
      occurrences: updatedBadHabitDTO.occurrences
    );

    _badHabits[index] = updatedBadHabit;
    notifyListeners();
  }

  Future<void> deleteBadHabit(int badHabitId) async {
    Database database = await DBController.instance.database;
    await database.delete('BadHabit', where: 'Id = ?', whereArgs: [badHabitId]);
    _badHabits.removeWhere((badHabit) => badHabit.id == badHabitId);
    notifyListeners();
  }

  Future<void> addOccurrence(int badHabitId, DateTime dateTime) async {
    final int index = _badHabits.indexWhere((badHabit) => badHabit.id == badHabitId);
    Database database = await DBController.instance.database;
    Map<String, dynamic> json = {
      'BadHabitId': badHabitId,
      'DateOccurred': dateTime.toIso8601String()
    };

    await database.insert('BadHabitOccurrence', json);
    _badHabits[index].addOccurrence(dateTime);
    notifyListeners();
  } 

}