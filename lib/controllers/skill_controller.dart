// External Dependencies
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

// Models
import 'package:rpg/models/skill.dart';
import 'package:rpg/models/quest.dart';
import 'package:rpg/models/skill_reward.dart';
import 'package:rpg/dto/skill_dto.dart';
import 'package:rpg/controllers/db_controller.dart';


class SkillController with ChangeNotifier {
  List<Skill> _skills = [];

  List<Skill> get skills {
    return [..._skills];
  }

  Future<void> initializeSkills() async {
    Database database = await DBController.instance.database;
    List<Map<String, dynamic>> json = await database.query('Skill');
    _skills = json.map((skill) => Skill.fromJSON(skill)).toList();
    notifyListeners();
  }

  Future<void> processSkillRewards(List<SkillReward> skillRewards) async {
    if(skillRewards.isNotEmpty) {
      Database database = await DBController.instance.database;
      Batch batch = database.batch();
      for(SkillReward skillReward in skillRewards) {
        int expAmount = (skillReward.difficulty.index + 1) * Quest.baseExpReward;
        int index = _skills.indexWhere((skill) => skill.id == skillReward.skillId);

        // earn exp only when the skill is found
        if(index != -1) { 
          _skills[index].earnExp(expAmount * 100);
          batch.update('Skill', _skills[index].dto.toJSON(), where: 'Id = ?', whereArgs: [_skills[index].id]);
        }

      }
      await batch.commit();
      notifyListeners();
    }
  }

  Future<void> addSkill(SkillDTO newSkillDTO) async {

    if(newSkillDTO.title == null || newSkillDTO.title!.isEmpty || newSkillDTO.title!.length <= 3) {
      return;
    }

    Database database = await DBController.instance.database;
    int id = await database.insert('Skill', newSkillDTO.toJSON());
    Skill newSkill = Skill(
      id: id, 
      title: newSkillDTO.title!,
    );

    _skills.add(newSkill);
    notifyListeners();
  }

  Future<void> updateSkill(int skillId, SkillDTO updatedSkillDTO) async {
    int index = _skills.indexWhere((skill) => skill.id == skillId);

    if(index == -1 || updatedSkillDTO.title!.isEmpty || updatedSkillDTO.title!.length <= 3) {
      return;
    }

    Database database = await DBController.instance.database;
    await database.update('Skill', updatedSkillDTO.toJSON(), where: 'Id = ?', whereArgs: [skillId]);
    Skill updatedSkill = Skill(
      id: skillId,
      title: updatedSkillDTO.title!,
      level: updatedSkillDTO.level,
      currentExp: updatedSkillDTO.currentExp
    );

    _skills[index] = updatedSkill;
    notifyListeners();
  }

  Skill getSkillById(int skillId) {
    return skills.firstWhere((skill) => skill.id == skillId);
  }

  Future<void> deleteSkill(int skillId) async {
    Database database = await DBController.instance.database;
    await database.delete('Skill', where: 'Id = ?', whereArgs: [skillId]);
    _skills.removeWhere((skill) => skill.id == skillId);
    notifyListeners();
  }

}