import 'package:rpg/enum/difficulty.dart';

class QuestHistory {
  final int id;
  final DateTime dateFinished;
  final Difficulty difficulty;
  final bool isFinished;

  QuestHistory({
    required this.id,
    required this.dateFinished,
    required this.difficulty,
    required this.isFinished,
  });

  QuestHistory.fromJSON(Map<String, dynamic> json) :
    id = json['Id'] as int, 
    dateFinished = DateTime.parse(json['DateFinished'] as String), 
    difficulty = Difficulty.values[json['Difficulty'] as int], 
    isFinished = (json['IsFinished'] as int) == 1 ? true : false;

}