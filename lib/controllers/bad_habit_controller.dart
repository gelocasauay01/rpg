//External Dependencies
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

//Models
import 'package:rpg/dto/bad_habit_dto.dart';
import 'package:rpg/models/bad_habit.dart';
import 'package:rpg/controllers/db_controller.dart';

class BadHabitController with ChangeNotifier{
  List<BadHabit> _badHabits = [];

  List<BadHabit> get badHabits {
    return [..._badHabits];
  }

  Future<List<BadHabit>> initializeBadHabits() async {
    Database database = await DBController.instance.database;
    List<Map<String, dynamic>> json = await database.rawQuery(
      '''
        SELECT Id, Title, Damage, OccurrenceCount, LastOccurred
        FROM BadHabit
        LEFT JOIN (
          SELECT BadHabitId, COUNT(*) as OccurrenceCount, MAX(DateOccurred) as LastOccurred
          FROM BadHabitOccurrence
          GROUP BY BadHabitId
        )
        ON Id = BadHabitId
      ''');
    _badHabits = json.map((data) => BadHabit.fromJSON(data)).toList();
    return badHabits;
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
      lastOccurred: updatedBadHabitDTO.lastOccurred,
      occurrenceCount: updatedBadHabitDTO.occurrenceCount
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

  Future<void> updateOccurrence(int badHabitId, DateTime dateTime) async {
    final int index = _badHabits.indexWhere((badHabit) => badHabit.id == badHabitId);
    Database database = await DBController.instance.database;
    Map<String, dynamic> json = {
      'BadHabitId': badHabitId,
      'DateOccurred': dateTime.toLocal().millisecondsSinceEpoch
    };
    await database.insert('BadHabitOccurrence', json);
    _badHabits[index].updateLatestOccurrence(dateTime);
    notifyListeners();
  } 

}