// External Dependencies
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

// Models
import 'package:rpg/controllers/db_controller.dart';
import 'package:rpg/models/quest.dart';
import 'package:rpg/models/subtask.dart';
import 'package:rpg/models/skill_reward.dart';
import 'package:rpg/dto/quest_dto.dart';

class QuestController with ChangeNotifier{

  List<Quest> _quests = [];

  List<Quest> get quests {
    return [..._quests];
  }

  List<Quest> get expiredQuests  {
    List<Quest> expiredQuests = [];
    DateTime now = DateTime.now();
    for(Quest quest in _quests) {
      if(quest.deadline != null && quest.deadline != null && now.isAfter(quest.deadline!)) {
        expiredQuests.add(quest);
      }
    }
    return expiredQuests;
  }

  Future<void> initializeQuests() async {
    Database database = await DBController.instance.database;
    List<Quest> quests = [];
    List<Map<String, dynamic>> json = await database.query("Quest");
    for(Map<String, dynamic> data in json){
      int id = data['Id'] as int;
      List<Subtask>? subtasks = await _getSubtasks(id);
      List<SkillReward>? skillRewards = await _getSkillRewards(id);

      quests.add(Quest.fromJSON(
        data, 
        subtasks: subtasks,
        skillRewards: skillRewards
      ));

    }
    _quests = quests;
  }

  Future<int> addQuest(QuestDTO newQuestDTO) async {
    Database database = await DBController.instance.database;
    int questId = await database.insert("Quest", newQuestDTO.toJSON());
    newQuestDTO.subtasks = await _addSubtasks(questId, newQuestDTO.subtasks);
    newQuestDTO.skillRewards = await _addSkillRewards(questId, newQuestDTO.skillRewards);
    notifyListeners();
    return questId;
  }

  Future<Quest?> getQuestById(int questId) async {
    Database database = await DBController.instance.database;
    List<Map<String, dynamic>> json = await database.query('Quest', where: 'Id = ?', whereArgs: [questId]);
    Quest? quest;

    if(json.isNotEmpty)
    {
      List<Subtask>? subtasks = await _getSubtasks(questId);
      List<SkillReward>? skillRewards = await _getSkillRewards(questId);
      quest = Quest.fromJSON(json.first, skillRewards: skillRewards, subtasks: subtasks);
    }

    return quest;
  }

  Future<void> updateQuest(int questId, QuestDTO updatedQuestDTO) async {
    Database database = await DBController.instance.database;
    await _deleteSubFields(questId, 'Subtask'); // Delete all subtasks that refer to this quest
    await _deleteSubFields(questId, 'SkillReward'); // Delete all skill reward that refer to this quest
    await database.update('Quest', updatedQuestDTO.toJSON(), where: 'Id = ?', whereArgs: [questId]);
    updatedQuestDTO.subtasks = await _addSubtasks(questId, updatedQuestDTO.subtasks); // re-add subtasks if they still exist
    updatedQuestDTO.skillRewards = await _addSkillRewards(questId, updatedQuestDTO.skillRewards); // re-add skill rewards if they still exist
    notifyListeners();
  }

  Future<void> deleteQuest(int questId) async {
    Database database = await DBController.instance.database;
    await database.delete('Quest', where: 'Id = ?', whereArgs: [questId]);
    notifyListeners();
  }

  Future<void> deleteExpiredQuests() async {
    Database database = await DBController.instance.database;
    int now = DateTime.now().toLocal().millisecondsSinceEpoch;
    await database.delete('Quest',where: 'Deadline < ?', whereArgs: [now]);
  }

  Future<void> deleteSkillRewards(int skillId) async {
    Database database = await DBController.instance.database;
    await database.delete('SkillReward', where: 'SkillId = ?', whereArgs: [skillId]);
    notifyListeners();
  }

  Future<List<Subtask>?> _getSubtasks(int questId) async {
    Database database = await DBController.instance.database;
    List<Map<String, dynamic>> json = await database.query('Subtask', where: 'QuestId = ?', whereArgs: [questId]);
    return json.isNotEmpty ? json.map((data) => Subtask.fromJSON(data)).toList() : null;
  }

  Future<List<SkillReward>?> _getSkillRewards(int id) async {
    Database database = await DBController.instance.database;
    List<Map<String, dynamic>> json = await database.query('SkillReward', where: 'QuestId = ?', whereArgs: [id]);
    return json.isNotEmpty ? json.map((data) => SkillReward.fromJSON(data)).toList() : null;
  }

  Future<List<Subtask>?> _addSubtasks(int questId, List<Subtask>? subtasks) async {
    if(subtasks == null || subtasks.isEmpty) return null;

    Database database = await DBController.instance.database;
    Batch batch = database.batch();

    // Insert to subtask to database with references to quest id
    for(Subtask subtask in subtasks){
      subtask.questId = questId;
      batch.insert('Subtask', subtask.toJSON());
    }

    // Populate new ids in subtask objects
    List<dynamic> ids = await batch.commit();
    for(int index = 0; index < ids.length; index++){
      subtasks[index].id = ids[index];
    }

    return subtasks;
  }

  Future<List<SkillReward>?> _addSkillRewards(int questId, List<SkillReward>? skillRewards) async {
    if(skillRewards == null || skillRewards.isEmpty) return null;

    Database database = await DBController.instance.database;

    for(SkillReward skillReward in skillRewards){
      skillReward.questId = questId;
      int id = await database.insert('SkillReward', skillReward.toJSON());
      skillReward.id = id;
    }

    return skillRewards;
  }

   Future<void> _deleteSubFields(int questId, String subField) async {
    Database database = await DBController.instance.database;
    await database.delete(subField, where: 'QuestId = ?', whereArgs: [questId]);
  }

  

}