// External Dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Models  
import 'package:rpg/controllers/theme_controller.dart';

// Widgets
import 'package:rpg/screens/rpg_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {

  const MainApp({super.key});

  // This widget is the root of your application.
  @override  
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => ThemeController(),
    child: const RPGApp(),
  );
}




