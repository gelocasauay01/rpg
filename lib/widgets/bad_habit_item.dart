// External Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/models/bad_habit.dart';
import 'package:rpg/controllers/bad_habit_controller.dart';
import 'package:rpg/controllers/profile_controller.dart';

// Widgets
import 'package:rpg/widgets/bad_habit_modal_form.dart';

class BadHabitItem extends StatelessWidget {
  final BadHabit _badHabit;

  const BadHabitItem(
    this._badHabit,
    {super.key}
  );

  String _displayLastActDate() {
    return 'Last Act: ${_badHabit.lastOccurred != null ? DateFormat('MMMM d, yyyy').add_jm().format(_badHabit.lastOccurred!) : 'None'}';
  }

  Future<void> _triggerBadHabit(BuildContext context) async {
    BadHabitController badHabitController = Provider.of<BadHabitController>(context, listen: false);
    ProfileController profileController = Provider.of<ProfileController>(context, listen: false);

    await badHabitController.updateOccurrence(_badHabit.id, DateTime.now());
    await profileController.takeDamage(_badHabit.damage);
  }

  @override
  Widget build(BuildContext context) => Dismissible(
    key: Key(_badHabit.id.toString()),
    direction: DismissDirection.startToEnd,
    onDismissed: (_) async => await Provider.of<BadHabitController>(context, listen: false).deleteBadHabit(_badHabit.id),
    background: Container(
      padding: const EdgeInsets.only(left: 10.0),
      color: Theme.of(context).errorColor,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Icon(Icons.delete)
      )
    ),
    child: GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context, 
        builder: (context) => BadHabitModalForm(badHabitId: _badHabit.id)
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black)
        ),
        child: ListTile(
          leading: Text(_badHabit.occurrenceCount.toString()),
          title: Text(_badHabit.title),
          trailing: IconButton(
            onPressed: () => _triggerBadHabit(context), 
            icon: const Icon(Icons.add)
          ),
          subtitle: Text(
            _displayLastActDate(),
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    ),
  );
  
}