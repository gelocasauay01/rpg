// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Model
import 'package:rpg/models/skill.dart';
import 'package:rpg/models/skill_reward.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/enum/difficulty.dart';

class SkillRewardDialog extends StatefulWidget {
  final List<SkillReward>? _skillRewards;

  const SkillRewardDialog(
    this._skillRewards,
    { super.key }
  );

  @override
  State<SkillRewardDialog> createState() => _SkillRewardDialogState();
}

class _SkillRewardDialogState extends State<SkillRewardDialog> {

  List<SkillReward>? skillRewards;

  Difficulty? _getSkillDifficulty(int skillId) {

    if(skillRewards == null) {
      return null;
    }

    int index = skillRewards!.indexWhere((skillReward) => skillReward.skillId == skillId);
    Difficulty? difficulty;

    if(index != -1) {
      difficulty = skillRewards![index].difficulty; 
    }
    
    return difficulty;
  }

  Color _getDifficultyColor (int skillId, {Color defaultColor = Colors.white}) {
    Difficulty? difficulty = _getSkillDifficulty(skillId);
    Color difficultyColor = defaultColor;
    if(difficulty == Difficulty.easy) {
      difficultyColor = Colors.green;
    }

    else if(difficulty == Difficulty.normal) {
      difficultyColor = Colors.yellow;
    }

    else if(difficulty == Difficulty.hard) {
      difficultyColor = Colors.red;
    }
    return difficultyColor;
  }

  void _insertSkillReward(Skill skill) {
    // Immediately put the skill reward when list is null
    if(skillRewards == null ) {
      setState(() {
        skillRewards = [SkillReward(skillId: skill.id, difficulty: Difficulty.easy)];
      });
      return;
    }

    int index = skillRewards!.indexWhere((skillReward) => skillReward.skillId == skill.id);
    if(index != -1) {
      Difficulty currentDifficulty = skillRewards![index].difficulty; 
      int nextDifficulty = currentDifficulty.index + 1;

      // Removes skill reward when it goes past hard
      if(nextDifficulty >= Difficulty.values.length) {
        setState(() {
          skillRewards!.removeAt(index);

          // Set skill rewards to null when the list is empty
          if(skillRewards!.isEmpty) {
            skillRewards = null;
          }
        });
      } 
      
      else {
        // Increase difficulty if next difficulty index does not exceed number of difficulty values
        setState(() {
          skillRewards![index].difficulty = Difficulty.values[nextDifficulty];
       });
      }
      
    } 
    else {
      // When skill is not found from the list, add it to list with a default value of easy
      setState(() {
        skillRewards!.add(SkillReward(skillId: skill.id));
      });
    }
  }

  Widget _createSkillList(List<Skill> skills) {
    return Expanded(
      child: skills.isNotEmpty
      ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
            skills.map((skill) {
            return GestureDetector(
              onTap: () {
                _insertSkillReward(skill);
              },
              child: Container(
                color: _getDifficultyColor(skill.id),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  skill.title
                ),
              ),
            );
          }).toList() 
        ),
      )
      :  const Center(child: Text('No skills yet')),
    );
  }

  @override 
  void initState(){
    super.initState();
    skillRewards = widget._skillRewards;
  }

  @override
  Widget build(BuildContext context) {
    List<Skill> skills = Provider.of<SkillController>(context, listen: false).skills;
    double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      child: Container(
        height: screenHeight * 0.5,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose Skill'),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('x')
                ), 
              ],
            ),

            const Divider(),

            _createSkillList(skills),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(skillRewards);
              }, 
              child: const Text('Save')
            )
          ]
        ),
      ),
    );
  }

  
}