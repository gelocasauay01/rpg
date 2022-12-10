// External Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rpg/controllers/notification_controller.dart';
import 'package:permission_handler/permission_handler.dart';

// Models
import 'package:rpg/controllers/quest_controller.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/enum/difficulty.dart';
import 'package:rpg/models/subtask.dart';
import 'package:rpg/dto/quest_dto.dart';

// Widgets 
import 'package:rpg/widgets/skill_reward_dialog.dart';

class QuestFormScreen extends StatefulWidget {
  static const String routeName = '/quest-form';

  const QuestFormScreen({super.key});

  @override
  State<QuestFormScreen> createState() => _QuestFormScreenState();
}

class _QuestFormScreenState extends State<QuestFormScreen> {

  final List<Widget> _subtaskFields = [];
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  int? _questId;
  QuestDTO _questDTO = QuestDTO();
  bool _isInit = false;

  Future _saveQuest() async {

    if(!_formState.currentState!.validate()) {
      return;
    }

    QuestController questController = Provider.of<QuestController>(context, listen: false);
    NavigatorState navigator = Navigator.of(context);
    _formState.currentState!.save();
    
    if(_questId == null) {
      // if quest id is null that means you are adding a quest
       _questId = await questController.addQuest(_questDTO);
    }
    
    else {
      // Otherwise, update a quest from the list
      await questController.updateQuest(_questId!, _questDTO);
      await NotificationController.instance.cancelNotification(_questId!);
    }

    if(_questDTO.deadline != null && _questDTO.deadline!.difference(DateTime.now()).inMinutes > 30) {
      await NotificationController.instance.showScheduledNotification(
        id: _questId!, 
        title: 'Deadline is Near', 
        body: 'The quest "${_questDTO.title}" must be finished in 30 minutes', 
        dateTime: _questDTO.deadline!.subtract(const Duration(minutes: 30)),
        payload: 'quest-deadline'
      );
    }
    
    navigator.pop();
  }

  void _addSubtask(String subtaskTitle) {
    if(subtaskTitle.isEmpty) {
      return;
    }

    Subtask subtask = Subtask(title: subtaskTitle);

    if(_questDTO.subtasks == null){
      _questDTO.subtasks = [subtask];
    }

    else {
      _questDTO.subtasks!.add(subtask);
    }
    
  }

  String? _validateTitle(String? value) {
    String? result;

    if(value == null) {
      result = 'This field must not be null';
    }

    else if(value.isEmpty) {
      result = 'This field cannot be empty';
    }

    else if(value.length <= 3) {
      result = 'This field must have more than 3 characters';
    }

    return result;
  }

  String? _validateSubtask(String? value) {
    String? result;

    if(value != null && value.isNotEmpty && value.length <= 3) {
      result = 'This field must have more than 3 characters';
    }

    return result;
  }

  void _addSubtaskField({String initialValue = ''}) { 
    ValueKey widgetId = ValueKey(DateTime.now());
    setState(() {
      _subtaskFields.add(
        Row(
          key: widgetId,
          children: [
            Expanded(
              child: TextFormField(
                initialValue: initialValue,
                validator: _validateSubtask,
                onSaved: (subtask) {
                  _addSubtask(subtask as String);
                },
              )
            ),
            TextButton(
              onPressed: (){
                setState(() {
                  _subtaskFields.removeWhere((subtaskField) => subtaskField.key == widgetId);
                });
              }, 
              child: const Text('x')
            )
          ],
        ));
      }
    );
  }

  Color _getDifficultyColor (Difficulty difficulty) {
    Color difficultyColor = Colors.green;

    if(difficulty == Difficulty.normal) {
      difficultyColor = Colors.yellow;
    }

    else if(difficulty == Difficulty.hard) {
      difficultyColor = Colors.red;
    }

    return difficultyColor;
  }

  Future<void> _pickDeadline() async{
    DateTime now = DateTime.now();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    selectedDate = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: now, 
      lastDate: now.add(const Duration(days: 365))
    );

    if(selectedDate != null) {
      selectedTime = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.now()
      );
    }

    if(selectedDate != null && selectedTime != null) {

      DateTime deadline = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute
      );

      if(deadline.isAfter(now) ) {
        setState(() => _questDTO.deadline = deadline);
      }
      
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_isInit && ModalRoute.of(context) != null) {
      _questId = ModalRoute.of(context)!.settings.arguments as int?;
      if(_questId != null) {
        Provider.of<QuestController>(context, listen: false).getQuestById(_questId!).then((quest) {
          _questDTO = quest!.dto;
          //Initialize subtask fields when it exists in edit mode
          if(_questDTO.subtasks != null && _questDTO.subtasks!.isNotEmpty) {
            for(Subtask subtask in _questDTO.subtasks!) {
              _addSubtaskField(initialValue: subtask.title);
            }
          }
          setState(() {
            _titleController.text = _questDTO.title!;
          });
        });
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_questId != null ? 'Edit Quest' : 'Add Quest'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formState,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Title: '),
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        validator: _validateTitle,
                        onSaved: (title) {
                          _questDTO.title = title;
                        },
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Deadline: '),
                    if(_questDTO.deadline != null)
                      Text(DateFormat('MMMM d, yyyy').format(_questDTO.deadline!)),
                    ElevatedButton(
                      onPressed: () async {
                        PermissionStatus status = await Permission.notification.status;

                        if(status.isDenied){
                          status = await Permission.notification.request();
                        }

                        if(status.isGranted) {
                          _pickDeadline();
                        }

                      },
                      child: const Text('Choose Date')
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtask: '),
                    ElevatedButton(
                      onPressed: _addSubtaskField,
                      child: const Text('+ Add Subtask')
                    ),
                  ],
                ),

                if(_subtaskFields.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Column(children: _subtaskFields),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Skill Reward: '),
                    ElevatedButton(
                      onPressed: () async {
                        _questDTO.skillRewards = await showDialog(
                          context: context, 
                          builder: (context) => SkillRewardDialog(_questDTO.skillRewards)
                        );
                        setState(() {});
                      },
                      child: const Text('+ Add Skill Reward')
                    ),
                  ],
                ),
                
                if(_questDTO.skillRewards != null && _questDTO.skillRewards!.isNotEmpty) 
                  Wrap(
                    children: _questDTO.skillRewards!.map((skillReward) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(skillReward.difficulty),
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Text(Provider.of<SkillController>(context, listen: false).getSkillById(skillReward.skillId).title),
                      );
                    }).toList(),
                  ),
                
                ElevatedButton(
                  onPressed: () => _saveQuest(),
                  child: Text(_questId != null ? 'Update' : 'Save')
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}