//External Dependencies
import 'package:flutter/material.dart';

// Models
import 'package:rpg/models/skill.dart';

//Widgets
import 'package:rpg/widgets/skill_modal_form.dart';

class SkillItem extends StatelessWidget {

  final Skill _skill;
  
  const SkillItem(
    this._skill, 
    { super.key }
  );

  Widget _createSkillBadge(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      SizedBox(
        height: 90,
        width: 90,
        child: CircularProgressIndicator(
          value: _skill.currentExp / _skill.maxExp,
          color: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).disabledColor,
          strokeWidth: 5,
        ),
      ),
        
      SizedBox(
        height: 60,
        width: 60,
        child: Image.asset(
          _skill.rank.iconPath,
          fit: BoxFit.contain,
        ),
      ),
    ]
  );

  Widget _displaySkillTitle(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Lvl. ${_skill.level}',
        style: Theme.of(context).textTheme.caption,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            _skill.title, 
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => showModalBottomSheet(
      context: context, 
      builder: (context) => SkillModalForm(skillId: _skill.id)
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: Theme.of(context).dividerColor
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          _createSkillBadge(context),
          const SizedBox(height: 5),
          _displaySkillTitle(context)
        ]
      ),
    ),
  );
  
}