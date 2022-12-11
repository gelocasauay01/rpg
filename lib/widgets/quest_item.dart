// External Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rpg/controllers/notification_controller.dart';
import 'package:rpg/controllers/quest_history_controller.dart';
import 'package:rpg/controllers/skill_usage_controller.dart';

// Models
import 'package:rpg/enum/difficulty.dart';
import 'package:rpg/models/quest.dart';
import 'package:rpg/controllers/quest_controller.dart';
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/models/subtask.dart';

// Widgets
import 'package:rpg/screens/quest_form_screen.dart';

class QuestItem extends StatefulWidget {

  final Quest _quest;

  const QuestItem (
    this._quest,
    { super.key }
  );

  @override
  State<QuestItem> createState() => _QuestItemState();
}

class _QuestItemState extends State<QuestItem> {

  bool _isExtend = false;

  String _getDifficultyImagePath() {
    String imagePath = 'assets/images/difficulty/easy.png';
    if(widget._quest.difficulty == Difficulty.hard) {
      imagePath = 'assets/images/difficulty/hard.png';
    }

    else if(widget._quest.difficulty == Difficulty.normal) {
      imagePath = 'assets/images/difficulty/normal.png';
    }

    return imagePath;
  }

  Future _finishQuest() async {
    ProfileController profileController = Provider.of<ProfileController>(context, listen: false);
    
    if(profileController.isAlive) {
      SkillController skillController = Provider.of<SkillController>(context, listen: false);
      SkillUsageController skillUsageController = Provider.of<SkillUsageController>(context, listen: false);

      await profileController.receiveGoldReward((widget._quest.difficulty.index + 1 ) * Quest.baseGoldReward);

      if(widget._quest.skillRewards != null && widget._quest.skillRewards!.isNotEmpty) {
        await skillController.processSkillRewards(widget._quest.skillRewards!);
        await skillUsageController.processSkillRewards(widget._quest.skillRewards!);
      }
    }

    await _resolveQuest();
  }

  Future<void> _resolveQuest({bool isFinished = true}) async {
    QuestController questController = Provider.of<QuestController>(context, listen: false);
    QuestHistoryController questHistoryController = Provider.of<QuestHistoryController>(context, listen: false);

    if(widget._quest.deadline != null) {
      await NotificationController.instance.cancelNotification(widget._quest.id);
    }

    await questHistoryController.addQuestHistory(isFinished: isFinished, difficulty: widget._quest.difficulty);
    await questController.deleteQuest(widget._quest.id);
  }

  Future<bool?> _showConfirmDialog() async => await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.warning),
      title: const Text('Confirm Finish'),
      content: const Text('Are you sure you finished this quest?'),
      actions: [
        ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Ok')),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel'))
      ],
    )
  );
  
  Future<void> _promptFinishQuest() async {
    bool? isFinished = await _showConfirmDialog();
    if(isFinished != null && isFinished) {
      _finishQuest();
    }
  }

  void toggleSubtask(bool value, Subtask subtask) {
    subtask.isDone = value;

    if(widget._quest.isSubtaskFinished) {
      _finishQuest();
    } 

    else {
      setState((){});
    }
  }

  Widget _displaySubtasks() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: widget._quest.subtasks!.map((subtask) => GestureDetector(
        onTap: () {
          toggleSubtask(!subtask.isDone, subtask);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(subtask.title),
            Checkbox(
              value: subtask.isDone, 
              onChanged: (value) {
                if(value != null) {
                  toggleSubtask(value, subtask);
                }
              }
            )
        ],),
      )).toList(),
    ),
  );

  Widget _createTrailingButton() => widget._quest.subtasks != null 
    ? _isExtend 
      ? IconButton(onPressed: () => setState(() => _isExtend = false), icon: const Icon(Icons.arrow_upward)) 
      : IconButton(onPressed: () => setState(() => _isExtend = true), icon: const Icon(Icons.arrow_downward))
    : IconButton(onPressed: _promptFinishQuest, icon: const Icon(Icons.check));

  @override
  Widget build(BuildContext context) => Dismissible(
    key: Key(widget._quest.id.toString()),
    onDismissed: (direction) async => await _resolveQuest(isFinished: false),
    direction: DismissDirection.startToEnd,
    background: Container(
      padding: const EdgeInsets.only(left: 10.0),
      color: Theme.of(context).errorColor,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Icon(Icons.delete)
      )
    ),
    child: Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black)
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => Navigator.of(context).pushNamed(QuestFormScreen.routeName, arguments: widget._quest.id),
            leading: Image.asset(_getDifficultyImagePath()),
            title: Text(widget._quest.title),
            subtitle: widget._quest.deadline != null ? Text(DateFormat('MMMM d, yyyy').format(widget._quest.deadline!)) : null,
            trailing: _createTrailingButton()
          ),

          if(widget._quest.subtasks != null && _isExtend) 
            _displaySubtasks()

        ],
      ),
    ),
  );
  
}