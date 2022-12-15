import 'package:rpg/dto/bad_habit_dto.dart';

class BadHabit {
  
  final int id;
  String title;
  int damage;
  DateTime? lastOccurred;
  int occurrenceCount;

  BadHabit ({
    required this.id,
    required this.title,
    this.damage = 2,
    this.lastOccurred,
    this.occurrenceCount = 0,
  });

  BadHabit.fromJSON(Map<String, dynamic> json) :
    id = json['Id'] as int,
    title = json['Title'] as String,
    damage = json['Damage'] as int,
    lastOccurred = json['LastOccurred'] != null ? DateTime.fromMillisecondsSinceEpoch(json['LastOccurred'] as int) : null,
    occurrenceCount = json['OccurrenceCount'] != null ? json['OccurrenceCount'] as int : 0;

  BadHabitDTO get dto {
    return BadHabitDTO(
      title: title,
      damage: damage,
      lastOccurred: lastOccurred,
      occurrenceCount: occurrenceCount
    );
  }

  void updateLatestOccurrence(DateTime dateTime) {
    lastOccurred = dateTime;
    occurrenceCount += 1;
  }

  
}