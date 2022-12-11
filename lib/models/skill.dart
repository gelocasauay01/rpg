// External Dependencies
import 'dart:math';

// Models
import 'package:rpg/dto/skill_dto.dart';
import 'package:rpg/models/rank.dart';

class Skill {

  final int id;
  String title;
  int level; 
  int currentExp;

  Skill({
    required this.id,
    required this.title,
    this.level = 1,
    this.currentExp = 0,
  });

  Skill.fromJSON(Map<String, dynamic> json) :
    id = json['Id'] as int,
    title = json['Title'] as String,
    level = json['Level'] as int,
    currentExp = json['CurrentExp'] as int;

  Rank get rank {
    return RankSystem.getRankFromLevel(level);
  }

  int get maxExp {
    return (log(level) / log(1.1) + 1).ceil();
  }

  SkillDTO get dto {
    return SkillDTO(
      title: title,
      level: level,
      currentExp: currentExp
    );
  }

  void earnExp(int expAmount) {
    if(level >= 100) return;
    
    currentExp += expAmount;

    // Keep running until current experience is lower than max experience
    while(currentExp >= maxExp) {
      currentExp -= maxExp;
      level += 1;
    }
  }
}