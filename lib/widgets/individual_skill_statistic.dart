import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/controllers/skill_usage_controller.dart';
import 'package:rpg/enum/difficulty.dart';
import 'package:rpg/widgets/navigation_header.dart';
import 'package:rpg/widgets/statistics_item.dart';

class IndividualSkillStatistic extends StatefulWidget{
  const IndividualSkillStatistic({ super.key });

  @override
  State<IndividualSkillStatistic> createState() => _IndividualStatisticState();
}

class _IndividualStatisticState extends State<IndividualSkillStatistic> {
  int currentSkillIndex = -1;
  SkillUsageController? _skillUsageController;
  SkillController? _skillController;

  void _incrementCurrentSkillIndex(int value) {
    int nextIndex = currentSkillIndex + value;
    int skillsLength = _skillController!.skills.length;

    if(nextIndex >= skillsLength) {
      nextIndex = 0;
    }

    else if(nextIndex < 0) {
      nextIndex = skillsLength - 1;
    }

    setState(() {
      currentSkillIndex = nextIndex;
    });
  }

  Widget getMainWidget() {
    return Column(
      children: [
        NavigationHeader(
          title: _skillController!.skills[currentSkillIndex].title, 
          onNext: () => _incrementCurrentSkillIndex(1), 
          onPrev: () => _incrementCurrentSkillIndex(-1)
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatisticsItem(
              title: 'Skill usage per day', 
              content: _skillUsageController!.getAvgSkillUsagePerDay(_skillController!.skills[currentSkillIndex].id).toStringAsFixed(1)
            ),
            StatisticsItem(
              title: 'Easy Usage Count', 
              content: _skillUsageController!.getSkillUsageByDifficultyCount(_skillController!.skills[currentSkillIndex].id, Difficulty.easy).toString()
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatisticsItem(
              title: 'Normal Usage Count', 
              content: _skillUsageController!.getSkillUsageByDifficultyCount(_skillController!.skills[currentSkillIndex].id, Difficulty.normal).toString()
            ),
            StatisticsItem(
              title: 'Hard Usage Count', 
              content: _skillUsageController!.getSkillUsageByDifficultyCount(_skillController!.skills[currentSkillIndex].id, Difficulty.hard).toString()
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _skillController = Provider.of<SkillController>(context, listen: false);
    _skillUsageController = Provider.of<SkillUsageController>(context, listen: false);
    if(_skillController!.skills.isNotEmpty) {
      currentSkillIndex = 0;
    }
  }

  @override
  void dispose(){
    _skillUsageController!.disposeSkillUsage();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) => FutureBuilder(
    future: _skillUsageController!.initializeSkillUsage(),
    builder: (context, snapshot) {
      Widget widget = const Center(child: CircularProgressIndicator());

      if(snapshot.connectionState == ConnectionState.done && !_skillUsageController!.isEmpty) {
        widget = getMainWidget();
      }

      else if(snapshot.connectionState == ConnectionState.done && _skillUsageController!.isEmpty) {
        widget = Expanded(child: Center(child: Text('No skill usage data yet!', style: Theme.of(context).textTheme.caption)));
      }

      return widget;
    }
  );
  
}