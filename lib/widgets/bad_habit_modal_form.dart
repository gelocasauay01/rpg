// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// Models
import 'package:rpg/controllers/bad_habit_controller.dart';
import 'package:rpg/dto/bad_habit_dto.dart';

class BadHabitModalForm extends StatefulWidget {
  final int? badHabitId;

  const BadHabitModalForm({
    this.badHabitId,
    super.key
  });

  @override
  State<BadHabitModalForm> createState() => _BadHabitModalFormState();
}

class _BadHabitModalFormState extends State<BadHabitModalForm> {

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool _isInit = false;
  BadHabitDTO _badHabitDTO = BadHabitDTO();

  String? _validateBadHabitTitle(String? value) {
    String? result;

    if (value == null) {
      result = 'Title cannot be null';
    }

    else if (value.isEmpty || value.trim().isEmpty) {
      result = 'This field cannot be empty';
    }

    else if (value.length <= 3) {
      result = 'This field must have more than 3 characters';
    }

    return result;
  }

  String? _validateBadHabitDamage(String? value) {
    String? result;

    if (value == null) {
      result = 'Title cannot be null';
    }

    else if (value.isEmpty || value.trim().isEmpty) {
      result = 'This field cannot be empty';
    }

    else if (int.tryParse(value) == null) {
      result = 'Input must be an integer';
    }

    else if(int.tryParse(value)! < 1) {
      result = 'Input must be greater than 0';
    }

    return result;
  }

  Future<void> _saveBadHabit() async {
    if(!_formState.currentState!.validate()){
      return;
    }

    _formState.currentState!.save();
    BadHabitController badHabitController = Provider.of<BadHabitController>(context, listen: false);
    NavigatorState navigator = Navigator.of(context);

    // If there was a given bad habit id, it must update the existing bad habit that has the id. Otherwise, add it to the bad habit list
    if(widget.badHabitId != null) {
      await badHabitController.updateBadHabit(widget.badHabitId!, _badHabitDTO);
    } 
    
    else {
      await badHabitController.addBadHabit(_badHabitDTO);
    }

    navigator.pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_isInit && widget.badHabitId != null) {
      _badHabitDTO = Provider.of<BadHabitController>(context, listen: false).getBadHabitById(widget.badHabitId!).dto;
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
              const Text('Add a Bad Habit'),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                initialValue: _badHabitDTO.title,
                validator: _validateBadHabitTitle,
                onSaved: (newTitle) => _badHabitDTO.title = newTitle,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Damage'),
                ),
                initialValue: _badHabitDTO.damage.toString(),
                validator: _validateBadHabitDamage,
                onSaved: (newDamage) => _badHabitDTO.damage = int.parse(newDamage!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _saveBadHabit,
                    child: const Text('Save')
                  ),
                  const SizedBox(
                    width: 20
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    child: const Text('Cancel')
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}