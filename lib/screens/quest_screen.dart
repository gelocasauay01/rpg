// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/enum/quest_mode.dart';
import 'package:rpg/models/bad_habit.dart';
import 'package:rpg/models/quest.dart';
import 'package:rpg/models/nav_item.dart';
import 'package:rpg/controllers/bad_habit_controller.dart';
import 'package:rpg/controllers/quest_controller.dart';
import 'package:rpg/controllers/quest_history_controller.dart';

// Widgets
import 'package:rpg/widgets/bad_habit_modal_form.dart';
import 'package:rpg/widgets/bad_habit_item.dart';
import 'package:rpg/widgets/empty_list_display.dart';
import 'package:rpg/widgets/quest_item.dart';
import 'package:rpg/widgets/circular_nav.dart';
import 'package:rpg/screens/quest_form_screen.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {

  QuestMode _currentMode = QuestMode.quest;

  Future<List<Quest>> _initializeQuests(QuestController questController) async {
    QuestHistoryController questHistoryController = Provider.of<QuestHistoryController>(context, listen: false);

    await questController.initializeQuests();
    await questHistoryController.addQuestHistories(false, questController.expiredQuests);
    await questController.deleteExpiredQuests();

    return questController.quests;
  }

  void _switchMode(QuestMode questMode) {
    setState(() {
      _currentMode = questMode;
    });
  }

  void _showQuestOrBadHabitForm() {
    if(_currentMode == QuestMode.quest) {
      Navigator.of(context).pushNamed(QuestFormScreen.routeName);
    }

    else if(_currentMode == QuestMode.badHabit) {
      showModalBottomSheet(
        context: context, 
        isScrollControlled: true,
        builder: (context) => const BadHabitModalForm()
      );
    }
  }

  Widget _showQuestList() =>  Consumer<QuestController>(
    child: const Center(
      child: EmptyListDisplay(
        assetFilePath: 'assets/images/empty-lists/quest.png',
        text: 'No quests yet',
      )
    ),
    builder: (context, value, child) => FutureBuilder(
      future: _initializeQuests(value),
      builder: (context, snapshot) {
        Widget widget = const Center(child: CircularProgressIndicator());
        if(snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          List<Quest> quests = snapshot.data!; 
          widget = ListView.builder(
            itemCount: quests.length,
            itemBuilder: (context, index) => QuestItem(quests[index])
          );
        }

        else if(snapshot.connectionState == ConnectionState.done && snapshot.data!.isEmpty) {
          widget = child!;
        }

        return widget;
      }
    )
  );

  Widget _showBadHabitsList() => Consumer<BadHabitController>(
    child: const Center(
      child: EmptyListDisplay(
        assetFilePath:'assets/images/empty-lists/bad-habits.png', 
        text: 'No bad habits yet!'
      )
    ),
    builder: (context, value, child) => FutureBuilder(
      future: value.initializeBadHabits(),
      builder: (context, snapshot) {
        Widget widget = const Center(child: CircularProgressIndicator());

        if(snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          List<BadHabit> badHabits = snapshot.data!;
          widget = ListView.builder(
            itemCount: badHabits.length,
            itemBuilder: (context, index) => BadHabitItem(badHabits[index])
          );
        }

        else if(snapshot.connectionState == ConnectionState.done && value.badHabits.isEmpty) {
          widget = child!;
        }

        return widget;
      }
    )
  );
  
  @override
  Widget build(BuildContext context) => Expanded(
    child: ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: Container(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularNav(
                navItems: [
                  NavItem(
                    value: QuestMode.quest, 
                    title: 'Quest', 
                    onClick: () => _switchMode(QuestMode.quest)
                  ),
                  NavItem(
                    value: QuestMode.badHabit, 
                    title: 'Bad Habit', 
                    onClick: () => _switchMode(QuestMode.badHabit)
                  ),
                ],
                currentValue: _currentMode,
              ),
              Expanded(
                child: Stack(
                  children: [
                    
                    _currentMode == QuestMode.quest 
                      ? _showQuestList()
                      : _showBadHabitsList(),
  
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: () => _showQuestOrBadHabitForm(),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        )
      ),
    ),
  );
  
}