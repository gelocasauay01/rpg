class Subtask {
  int? id;
  int? questId;
  String title;
  bool isDone;

  Subtask({
    this.id,
    this.questId,
    this.title = '',
    this.isDone = false
  });

  Subtask.fromJSON(Map<String, dynamic> json) :
    id = json['Id'] as int,
    questId = json['QuestId'] as int,
    title = json['Title'] as String,
    isDone = json['IsDone'] == 1 ? true : false;

  Map<String, dynamic> toJSON(){
    return {
      'Id': id,
      'QuestId': questId,
      'Title': title,
      'IsDone': isDone ? 1 : 0
    };
  }

}