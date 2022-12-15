// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/controllers/theme_controller.dart';
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/controllers/bad_habit_controller.dart';
import 'package:rpg/controllers/bad_habit_occurrence_controller.dart';
import 'package:rpg/controllers/inventory_controller.dart';
import 'package:rpg/controllers/quest_controller.dart';
import 'package:rpg/controllers/quest_history_controller.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/controllers/skill_usage_controller.dart';

// Widgets
import 'package:rpg/screens/main_screen.dart';
import 'package:rpg/screens/quest_form_screen.dart';
import 'package:rpg/screens/edit_profile_screen.dart';

class RPGApp extends StatelessWidget {
  const RPGApp({ super.key });

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers:[
      ChangeNotifierProvider(create: (_) => ProfileController()),
      ChangeNotifierProvider(create: (_) => SkillController()),
      ChangeNotifierProvider(create: (_) => SkillUsageController()),
      ChangeNotifierProvider(create: (_) => InventoryController()),
      ChangeNotifierProvider(create: (_) => QuestHistoryController()),
      ChangeNotifierProvider(create: (_) => QuestController()),
      ChangeNotifierProvider(create: (_) => BadHabitController()),
      ChangeNotifierProvider(create: (_) => BadHabitOccurrenceController()),
    ],
    child: MaterialApp(
      title: 'RPG To-do List',
      theme: Provider.of<ThemeController>(context).themeData,
      home: const MainScreen(),
      routes: {
        EditProfileScreen.routeName: (context) => const EditProfileScreen(true),
        MainScreen.routeName:(context) => const MainScreen(),
        QuestFormScreen.routeName: (context) => const QuestFormScreen()
      },
      debugShowCheckedModeBanner: false,
    ),
  );
  
}



      