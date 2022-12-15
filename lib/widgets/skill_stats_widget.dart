// External Dependencies
// External Dependencies
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

// Models
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/widgets/empty_list_display.dart';
import 'package:rpg/widgets/individual_skill_statistic.dart';

class SkillStatsWidget extends StatelessWidget {
  final SkillController _skillController;

  const SkillStatsWidget(
    this._skillController,
    { super.key }
  );
  
  @override 
  Widget build(BuildContext context) {
    double thirdOfScreenHeight = MediaQuery.of(context).size.height * 0.35;
    return _skillController.skills.isNotEmpty
    ? Column(
      children: [
        SizedBox(
          height: thirdOfScreenHeight,
          width: thirdOfScreenHeight,
          child: RadarChart(
            ticks: List.generate(10, (index) => (index + 1) * 10), 
            features: _skillController.skills.map((skill) => skill.title).toList(), 
            data: [_skillController.skills.map((skill) => skill.level).toList()]
          ),
        ),
        const Divider(),
        const IndividualSkillStatistic()
      ],
    )
    : const Center(
        child: EmptyListDisplay(
          assetFilePath: 'assets/images/empty-lists/skill-stats.png', 
          text: 'No skills data yet!'
        )
      );
  }
}