// External Dependencies
import 'package:flutter/material.dart';

//Models
import 'package:rpg/models/nav_item.dart';

class CircularNav extends StatelessWidget {
  
  final List<NavItem> navItems;
  final dynamic currentValue;

  const CircularNav({ 
    required this.navItems,
    required this.currentValue,
    super.key,
  });

  Widget _createNavButton(NavItem navItem, BuildContext context) {
    Widget navBtn = Expanded(
      child: TextButton(
        child: Text(navItem.title),
        onPressed: () => navItem.onClick(),
      ),
    );
    
    if(currentValue == navItem.value) {
      navBtn = Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: Theme.of(context).focusColor,
            child: TextButton(
              child: Text(navItem.title),
              onPressed: () => navItem.onClick(),
            ),
          ),
        ),
      );
    }

    return navBtn;
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      border: Border.all(
        color: Theme.of(context).dividerColor,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: navItems.map((navItem) => _createNavButton(navItem, context)).toList(),
    ),
  );
  
}