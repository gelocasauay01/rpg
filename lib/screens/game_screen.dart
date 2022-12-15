// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Utils
import 'package:rpg/utils/string_utils.dart';

// Models
import 'package:rpg/enum/page.dart' as page_enum;
import 'package:rpg/controllers/profile_controller.dart';

// Widgets
import 'package:rpg/widgets/character_header.dart';
import 'package:rpg/screens/quest_screen.dart';
import 'package:rpg/screens/profile_screen.dart';
import 'package:rpg/screens/statistics_screen.dart';
import 'package:rpg/screens/shop_screen.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>{
  page_enum.Page currentPage = page_enum.Page.quests;

  final List<Map<String, dynamic>> pages = [
    {
      "name": page_enum.Page.profile.name,
      "icon": const Icon(Icons.person)
    },
    {
      "name": page_enum.Page.statistics.name, 
      "icon": const Icon(Icons.bar_chart)
    },
    {
      "name": page_enum.Page.quests.name,
      "icon": const Icon(Icons.task_alt)
    },
    {
      "name": page_enum.Page.shop.name,
      "icon": const Icon(Icons.store)
    },
  ];
  
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Consumer<ProfileController>(builder: (context, value, child) => CharacterHeader(profile: value.profile!)),
          if (currentPage == page_enum.Page.quests) const QuestScreen()
          else if (currentPage == page_enum.Page.profile) const ProfileScreen()
          else if (currentPage == page_enum.Page.shop) const ShopScreen()
          else if(currentPage == page_enum.Page.statistics) const StatisticsScreen()
        ]
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: currentPage.index,
      onTap: ((index) => setState(() {
        currentPage = page_enum.Page.values[index];
      })),
      items: pages.map((page) => BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColor,
        icon: page["icon"],
        label: StringUtils.toSentenceCase(page["name"]) 
      )).toList()
    ),
  );
  
}
            