// External Dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/controllers/bad_habit_controller.dart';
import 'package:rpg/controllers/inventory_controller.dart';
import 'package:rpg/controllers/quest_controller.dart';
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/controllers/quest_history_controller.dart';
import 'package:rpg/controllers/skin_controller.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/controllers/skill_usage_controller.dart';

// Widgets
import 'package:rpg/screens/main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const RPGApp());
}

class RPGApp extends StatelessWidget {

  const RPGApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SkinController()),
      ChangeNotifierProvider(create: (_) => ProfileController()),
      ChangeNotifierProvider(create: (_) => QuestController()),
      ChangeNotifierProvider(create: (_) => BadHabitController()),
      ChangeNotifierProvider(create: (_) => SkillController()),
      ChangeNotifierProvider(create: (_) => SkillUsageController()),
      ChangeNotifierProvider(create: (_) => InventoryController()),
      ChangeNotifierProvider(create: (_) => QuestHistoryController())
    ],
    child: const MainApp(),
  );
}


