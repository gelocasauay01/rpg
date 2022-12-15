// External Dependencies
import 'package:flutter/material.dart';

// Models
import 'package:rpg/models/nav_item.dart';
import 'package:rpg/enum/shop_mode.dart';
import 'package:rpg/controllers/shop_controller.dart';
import 'package:rpg/models/items/shop_item.dart';

// Widget
import 'package:rpg/widgets/circular_nav.dart';
import 'package:rpg/widgets/shop_item_widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  final ShopController shopController = ShopController();
  ShopMode _currentMode = ShopMode.consumable;

  void _switchMode(ShopMode shopMode) {
    setState(() {
      _currentMode = shopMode;
    });
  }

  Widget _showShopItems() {
    List<ShopItem> shopItems = _currentMode == ShopMode.consumable ? shopController.consumableShopItems : shopController.skinShopItems; // Checks current shop mode to dynamically give shop items
    return ListView.builder(
      itemCount: shopItems.length,
      itemBuilder: (context, index) => ShopItemWidget(shopItems[index], _currentMode),
    );
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
                navItems: [
                  NavItem(
                    value: ShopMode.consumable, 
                    title: 'Consumables', 
                    onClick: () => _switchMode(ShopMode.consumable)
                  ),
                  NavItem(
                    value: ShopMode.skin, 
                    title: 'Skins', 
                    onClick: () => _switchMode(ShopMode.skin)
                  ),
                ],
                currentValue: _currentMode,
              ),
              Expanded(
                child: _showShopItems()
              )
            ],
          ),
        )
      ),
    ),
  );
  
}