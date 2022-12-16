// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/controllers/theme_controller.dart';
import 'package:rpg/controllers/notification_controller.dart';
import 'package:rpg/controllers/inventory_controller.dart';

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
    ThemeController themeController = Provider.of<ThemeController>(context, listen: false);
    SkillController skillController = Provider.of<SkillController>(context, listen: false);
    InventoryController inventoryController = Provider.of<InventoryController>(context, listen: false);
    ProfileController profileController = Provider.of<ProfileController>(context, listen: false);
    NotificationController.instance.initializeNotifier().then((_) => listenToNotification(context));

    await themeController.initializeSkin();
    await skillController.initializeSkills();
    await inventoryController.initializeItems();
    return profileController.isNewGame();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: initializeGame(context),
    builder: (context, snapshot) {
      Widget widget = const Scaffold(body: Center(child: CircularProgressIndicator()));
      if(snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data!){
        widget = const GameScreen();
      }
      if(snapshot.connectionState == ConnectionState.done && snapshot.data != null && !snapshot.data!){
        widget = const EditProfileScreen(false);
      }
      return widget;
    }
  );
  
}

