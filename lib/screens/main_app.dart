// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/controllers/skin_controller.dart';

// Widgets
import 'package:rpg/screens/main_screen.dart';
import 'package:rpg/screens/quest_form_screen.dart';
import 'package:rpg/screens/edit_profile_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({ super.key });

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'RPG To-do List',
    theme: Provider.of<SkinController>(context).themeData,
    home: const MainScreen(),
    routes: {
      EditProfileScreen.routeName: (context) => const EditProfileScreen(true),
      MainScreen.routeName:(context) => const MainScreen(),
      QuestFormScreen.routeName: (context) => const QuestFormScreen()
    },
    debugShowCheckedModeBanner: false,
  );
  
}