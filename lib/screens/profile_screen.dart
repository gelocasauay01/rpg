// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/enum/profile_mode.dart';
import 'package:rpg/models/nav_item.dart';
import 'package:rpg/controllers/skill_controller.dart';
import 'package:rpg/controllers/inventory_controller.dart';

// Widgets
import 'package:rpg/widgets/circular_nav.dart';
import 'package:rpg/widgets/inventory_list.dart';
import 'package:rpg/widgets/skills_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileMode _currentMode = ProfileMode.skills;

  List<NavItem> _navItems = [];

  void _switchMode(ProfileMode profileMode) {
    setState(() {
      _currentMode = profileMode;
    });
  }

  Widget _showSkillsGrid() =>  Consumer<SkillController>(
    builder: (context, value, child) => SkillsGrid(value.skills),
  );
 

  Widget _showInventoryList() => Consumer<InventoryController>(
    builder: (context, value, child) => value.inventoryItems.isNotEmpty ? InventoryList(value.inventoryItems) : child!,
    child: const Center(child: Text('No items yet!')),
  );
  

  Widget _showCurrentWidget(BuildContext context) {
     Widget widget;
     switch(_currentMode) {

      case ProfileMode.skills: {
        widget = _showSkillsGrid();
        break;
      }

      case ProfileMode.inventory: {
        widget = _showInventoryList();
        break;
      }

     }
     return widget;
  }

  @override
  void initState() {
    super.initState();
    _navItems = [
      NavItem(
        value: ProfileMode.skills,
        title: 'Skills',
        onClick: () => _switchMode(ProfileMode.skills) 
      ),
      NavItem(
        value: ProfileMode.inventory,
        title: 'Inventory',
        onClick: () => _switchMode(ProfileMode.inventory) 
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Expanded(
    child: ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: Container(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularNav(
                navItems: _navItems,
                currentValue: _currentMode
              ),
              Expanded(child: _showCurrentWidget(context))
            ],
          ),
        )
      ),
    ),
  );
  
}