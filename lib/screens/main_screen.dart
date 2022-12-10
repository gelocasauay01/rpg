// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/controllers/bad_habit_controller.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/controllers/skin_controller.dart';
import 'package:rpg/controllers/inventory_controller.dart';
import 'package:rpg/controllers/notification_controller.dart';

// Widgets
import 'package:rpg/screens/edit_profile_screen.dart';
import 'package:rpg/screens/game_screen.dart';

class MainScreen extends StatelessWidget {
  static const String routeName = '/main';
  const MainScreen({super.key});

  void listenToNotification(BuildContext context) {
    NotificationController.instance.onNotificationClick.stream.listen((payload) {
      if(payload == null || payload.isEmpty) return;

      if(payload == 'quest-deadline') {
        Navigator.pushNamed(context, routeName);
      }

    });
  }  

  Future<bool> initializeGame(BuildContext context) async {
    SkinController skinController = Provider.of<SkinController>(context, listen: false);
    SkillController skillController = Provider.of<SkillController>(context, listen: false);
    BadHabitController badHabitController = Provider.of<BadHabitController>(context, listen: false);
    ProfileController profileController = Provider.of<ProfileController>(context, listen: false);
    InventoryController inventoryController = Provider.of<InventoryController>(context, listen: false);
    listenToNotification(context);
    
    await NotificationController.instance.initializeNotifier();
    await skinController.initializeSkin();
    await skillController.initializeSkills();
    await badHabitController.initializeBadHabits();
    await inventoryController.initializeItems();

    return profileController.isNewGame();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeGame(context),
      builder: (context, snapshot) {
        Widget widget = const Scaffold(body: Center(child: CircularProgressIndicator()));

        if(snapshot.connectionState == ConnectionState.done && snapshot.data!){
          widget = const GameScreen();
        }

        if(snapshot.connectionState == ConnectionState.done && !snapshot.data!){
          widget = const EditProfileScreen(false);
        }

        return widget;
      });
  }
}