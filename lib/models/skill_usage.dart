import 'package:rpg/enum/difficulty.dart';

class SkillUsage {
  int id;
  int skillId;
  DateTime dateUsage;
  Difficulty difficulty;

  SkillUsage({
    required this.id,
    required this.skillId,
    required this.dateUsage,
    required this.difficulty
  });

  SkillUsage.fromJSON(Map<String, dynamic> json) :
    id = json['Id'] as int,
    skillId = json['SkillId'] as int,
    dateUsage = DateTime.parse(json['DateUsage'] as String),
    difficulty = Difficulty.values[(json['Difficulty'] as int)];
  
}