// External Dependencies
import 'package:flutter/material.dart';

// Models
import 'package:rpg/models/skill.dart';

// Widgets
import 'package:rpg/widgets/skill_item.dart';
import 'package:rpg/widgets/skill_modal_form.dart';

class SkillsGrid extends StatelessWidget {
  
  final List<Skill> _skills;

  const SkillsGrid(
    this._skills,
    { super.key }
  );

  void _showSkillModal(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      builder: (context) => const SkillModalForm() 
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Stack(
          children: [
            _skills.isNotEmpty ?
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
              ), 
              itemCount: _skills.length,
              itemBuilder: ((context, index) => SkillItem(_skills[index]))
            )
            : const Center(child: Text('No skills yet!')),
              Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () => _showSkillModal(context),
                  child: const Icon(Icons.add),
                ),
              ),
            )
          ],
        ),
      );
  }
}