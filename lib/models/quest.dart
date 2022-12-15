import 'package:rpg/enum/difficulty.dart';
import 'package:rpg/models/skill_reward.dart';
import 'package:rpg/models/subtask.dart';
import 'package:rpg/dto/quest_dto.dart';

class Quest {

  static const int baseGoldReward = 10;
  static const int baseExpReward = 7;

  final int id;
  String title;
  DateTime? deadline;
  List<SkillReward>? skillRewards; 
  List<Subtask>? subtasks;

  Quest({
    required this.id,
    required this.title,
    this.deadline,
    this. skillRewards,
    this.subtasks
  });

  Quest.fromJSON(Map<String, dynamic> json, { this.skillRewards, this.subtasks }) : 
    id = json["Id"] as int,
    title = json["Title"] as String,
    deadline = json['Deadline'] != null ? DateTime.fromMillisecondsSinceEpoch(json['Deadline'] as int) : null;

  Difficulty get difficulty {
    Difficulty highestDifficulty = Difficulty.easy;

    // Iterates through all the skill rewards and finds the highest difficulty
    if(skillRewards != null && skillRewards!.isNotEmpty) {
      for(SkillReward skillReward in skillRewards!) {
        if(skillReward.difficulty.index > highestDifficulty.index) {
          highestDifficulty = skillReward.difficulty;
        }
      }
    }

    return highestDifficulty;
  }

  bool get isSubtaskFinished {
    bool isSubtaskFinished = true;
    if (subtasks != null){
      for(Subtask subtask in subtasks!) {
        if(!subtask.isDone) {
          isSubtaskFinished = false;
          break;
        } 
      }
    }
    return isSubtaskFinished;
  }

  QuestDTO get dto {
    return QuestDTO(
      title: title,
      deadline: deadline,
      skillRewards: skillRewards,
      subtasks: subtasks
    );
  }

  void deleteSkillReward(int skillId) {
    if(skillRewards != null) {
      skillRewards!.removeWhere((skillReward) => skillReward.skillId == skillId);
    }
  }

}