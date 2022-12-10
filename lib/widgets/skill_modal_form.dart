// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/controllers/quest_controller.dart';
import 'package:rpg/dto/skill_dto.dart';

class SkillModalForm extends StatefulWidget {
  final int? skillId;

  const SkillModalForm({
    this.skillId,
    super.key
  });

  @override
  State<SkillModalForm> createState() => _SkillModalFormState();
}

class _SkillModalFormState extends State<SkillModalForm> {

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  SkillDTO _skillDTO = SkillDTO();
  bool _isInit = false;

  String? _validateSkillTitle(String? value) {
    String? result;

    if (value == null) {
      result = 'Title cannot be null';
    }

    else if (value.isEmpty) {
      result = 'This field cannot be empty';
    }

    else if (value.length <= 3) {
      result = 'This field must have more than 3 characters';
    }

    return result;
  } 

  Future _saveSkill(BuildContext context) async {
    if(!_formState.currentState!.validate()){
      return;
    }

    NavigatorState navigator = Navigator.of(context);
    _formState.currentState!.save();

    // If there was a given skill id, it must update the existing skill that has the id. Otherwise, add it to the skills list
    if(widget.skillId != null) {
      await Provider.of<SkillController>(context, listen: false).updateSkill(widget.skillId!, _skillDTO);
    } 

    else {
      await Provider.of<SkillController>(context, listen: false).addSkill(_skillDTO);
    }

    navigator.pop();
  }

  Future _deleteSkill(BuildContext context) async {
    QuestController questController = Provider.of<QuestController>(context, listen: false);
    SkillController skillController = Provider.of<SkillController>(context, listen: false);
    NavigatorState navigator = Navigator.of(context);

    await questController.deleteSkillRewards(widget.skillId!); // Delete all skill rewards of the skill id
    await skillController.deleteSkill(widget.skillId!);

    navigator.pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_isInit && widget.skillId != null) {
      _skillDTO = Provider.of<SkillController>(context).getSkillById(widget.skillId!).dto;
      _isInit = true;
    } 
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SingleChildScrollView(
      child: Form(
        key: _formState,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text('Add a Skill'),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Title')
                ),
                initialValue: _skillDTO.title,
                validator: _validateSkillTitle,
                onSaved: (newTitle) => _skillDTO.title = newTitle,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end ,
                children: [
                  if(widget.skillId != null) 
                    ElevatedButton(
                      onPressed: () =>_deleteSkill(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).errorColor)
                      ), 
                      child: const Text('Delete'),
                    ),
                  const SizedBox(
                    width: 10
                  ),
                  ElevatedButton(
                    onPressed: () => _saveSkill(context), 
                    child: const Text('Save')
                  ),
                  const SizedBox(
                    width: 10
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    child: const Text('Cancel')
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
  
}