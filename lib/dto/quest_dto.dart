import 'package:rpg/models/subtask.dart';
import 'package:rpg/models/skill_reward.dart';

class QuestDTO {

  String? title;
  DateTime? deadline;
  List<SkillReward>? skillRewards; 
  List<Subtask>? subtasks;

  QuestDTO({
    this.title,
    this.deadline,
    this.skillRewards,
    this.subtasks
  });

  Map<String, dynamic> toJSON(){
    return {
      'Title': title,
      'Deadline': deadline != null ? deadline!.toLocal().millisecondsSinceEpoch : null
    };
  }
}