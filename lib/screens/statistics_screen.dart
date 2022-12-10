// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/enum/statistics_mode.dart';
import 'package:rpg/models/nav_item.dart';
import 'package:rpg/controllers/quest_history_controller.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/controllers/bad_habit_controller.dart';

// Widgets
import 'package:rpg/widgets/circular_nav.dart';
import 'package:rpg/widgets/bad_habit_stats_widget.dart';
import 'package:rpg/widgets/quest_statistics_widget.dart';
import 'package:rpg/widgets/skill_stats_widget.dart';


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

  StatisticsMode _currentMode = StatisticsMode.quests;

  void _switchMode(StatisticsMode statisticsMode) {
    setState(() {
      _currentMode = statisticsMode;
    });
  }

  Widget _showCurrentWidget() {
    Widget currentWidget;

    switch(_currentMode) {
      case StatisticsMode.quests: {
        currentWidget = QuestStatisticsWidget(Provider.of<QuestHistoryController>(context));
        break;
      }

      case StatisticsMode.badHabits: {
        currentWidget = BadHabitStatsWidget(Provider.of<BadHabitController>(context));
        break;
      }

      case StatisticsMode.skills: {
        currentWidget = SkillStatsWidget(Provider.of<SkillController>(context));
        break;
      }
    }

    return currentWidget;
  }

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
                    value: StatisticsMode.quests, 
                    title: 'Quest', 
                    onClick: () => _switchMode(StatisticsMode.quests)
                  ),
                  NavItem(
                    value: StatisticsMode.badHabits, 
                    title: 'Bad Habit', 
                    onClick: () => _switchMode(StatisticsMode.badHabits)
                  ),
                  NavItem(
                    value: StatisticsMode.skills, 
                    title: 'Skill', 
                    onClick: () => _switchMode(StatisticsMode.skills)
                  )
                ],
                currentValue: _currentMode,
              ),
              Expanded(child: _showCurrentWidget()),
            ],
          ),
        )
      ),
    ),
  );
  
}