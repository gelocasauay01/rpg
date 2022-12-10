// External Dependencies
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

// Models
import 'package:rpg/enum/difficulty.dart';
import 'package:rpg/models/skill_reward.dart';
import 'package:rpg/models/skill_usage.dart';
import 'package:rpg/controllers/db_controller.dart';


class SkillUsageController with ChangeNotifier {
  List<SkillUsage> _skillUsageList = [];

  List<SkillUsage> get skillUsageList {
    return [..._skillUsageList];
  } 

  bool get isEmpty {
    return _skillUsageList.isEmpty;
  }

  double getAvgSkillUsagePerDay(int skillId) {
    double avgSkillUsagePerDay = 0.0;

    if(_skillUsageList.isNotEmpty) {
      skillUsageList.sort((current, next) => current.dateUsage.compareTo(next.dateUsage));
      List<SkillUsage> sortedSkillUsageList = skillUsageList;
      int index = sortedSkillUsageList.indexWhere((skillUsage) => skillUsage.skillId == skillId);
      if(index != -1) {
        int totalUsage = sortedSkillUsageList.fold(0, (previousCount, skillUsage) {
          int currentCount = previousCount;
          if(skillUsage.skillId == skillId) {
            currentCount += 1;
          } 
          return currentCount;
        });
        int daysPassedSinceFirstUsed = DateTime.now().difference(sortedSkillUsageList[index].dateUsage).inDays + 1;
        avgSkillUsagePerDay = totalUsage / daysPassedSinceFirstUsed;
      }
    }
    
    return avgSkillUsagePerDay;
  }

  int getSkillUsageByDifficultyCount(int skillId, Difficulty difficulty) {
    return _skillUsageList.fold(0, (previousCount, skillUsage) {
      int currentCount = previousCount;
      if(skillId == skillUsage.skillId && skillUsage.difficulty == difficulty) {
        currentCount += 1;
      }
      return currentCount;
    });
  }

  Future<void> initializeSkillUsage() async {
    Database database = await DBController.instance.database;
    List<Map<String, dynamic>> json = await database.query('SkillUsage');

    if(json.isNotEmpty) {
      _skillUsageList = json.map((data) => SkillUsage.fromJSON(data)).toList();
    }
  }

  void disposeSkillUsage() {
    _skillUsageList = [];
  }

  Future<void> processSkillRewards(List<SkillReward> skillRewards) async {
    if(skillRewards.isNotEmpty) {
      Database database = await DBController.instance.database;
      Batch batch = database.batch();
      for(SkillReward skillReward in skillRewards) {
         batch.insert('SkillUsage', {
          'SkillId': skillReward.skillId,
          'DateUsage': DateTime.now().toIso8601String(),
          'Difficulty': skillReward.difficulty.index
         });
      }
      await batch.commit();
    }
  }
  
}