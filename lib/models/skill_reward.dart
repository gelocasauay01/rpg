import 'package:rpg/enum/difficulty.dart';

class SkillReward {
  
  int? id;
  int? questId;
  int skillId;
  Difficulty difficulty;

  SkillReward({
    this.id,
    this.questId,
    required this.skillId,
    this.difficulty = Difficulty.easy
  });

  SkillReward.fromJSON(Map<String, dynamic> json) : 
    id = json['Id'] as int,
    questId = json['QuestId'] as int,
    skillId = json['SkillId'] as int,
    difficulty = Difficulty.values[(json['Difficulty'] as int)];

  Map<String, dynamic> toJSON(){
    return {
      'Id': id,
      'QuestId': questId,
      'SkillId': skillId,
      'Difficulty': difficulty.index
    };
  }
}