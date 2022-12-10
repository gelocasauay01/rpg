import 'package:rpg/dto/bad_habit_dto.dart';

class BadHabit {
  
  final int id;
  String title;
  int damage;
  List<DateTime>? occurrences;

  BadHabit ({
    required this.id,
    required this.title,
    this.damage = 2,
    this.occurrences,
  });

  BadHabit.fromJSON(Map<String, dynamic> json, { this.occurrences }) :
    id = json['Id'],
    title = json['Title'],
    damage = json['Damage'];

  BadHabitDTO get dto {
    return BadHabitDTO(
      title: title,
      damage: damage,
      occurrences: occurrences
    );
  }

  void addOccurrence(DateTime dateTime) {
    if(occurrences != null) {
      occurrences!.add(dateTime);
    } 
    
    else {
      occurrences = [dateTime];
    }
  }

  
}