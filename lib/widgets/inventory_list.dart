// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/controllers/theme_controller.dart';


// Models
import 'package:rpg/interface/item_user.dart';
import 'package:rpg/models/items/inventory_item.dart';
import 'package:rpg/models/items/inventory_potion.dart';
import 'package:rpg/widgets/inventory_item_widget.dart';

class InventoryList extends StatelessWidget {

  final List<InventoryItem> _inventoryItems;

  const InventoryList(
    this._inventoryItems,
    { super.key }
  );

  ItemUser _getItemUser(InventoryItem inventoryItem, BuildContext context) {
    ItemUser itemUser;
    if(inventoryItem is InventoryPotion) {
      itemUser = Provider.of<ProfileController>(context);
    }
    else {
      itemUser = Provider.of<ThemeController>(context);
    }
    return itemUser;
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: _inventoryItems.length,
    itemBuilder: (context, index) => InventoryItemWidget(
      inventoryItem:_inventoryItems[index],
      itemUser: _getItemUser(_inventoryItems[index], context),
    )
  );
  
}