// ExternalDependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg/controllers/inventory_controller.dart';

// Models
import 'package:rpg/interface/item_user.dart';
import 'package:rpg/models/items/inventory_item.dart';
import 'package:rpg/models/items/quantified_item.dart';

class InventoryItemWidget extends StatelessWidget {

  final InventoryItem inventoryItem;
  final ItemUser itemUser;

  const InventoryItemWidget({
    required this.inventoryItem,
    required this.itemUser,
    super.key
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).dividerColor),
      borderRadius: BorderRadius.circular(30.0)
    ),
    child: ListTile(
      leading: Image.asset(inventoryItem.item.imageUrl),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text (inventoryItem.item.title),
          
          if(inventoryItem is QuantifiedItem) 
            Text('x${(inventoryItem as QuantifiedItem).quantity.toString()}')
        ],
      ),
      subtitle: Text(inventoryItem.item.description),
      trailing:  ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40.0), 
          bottomRight: Radius.circular(40.0)
        ),
        child: ElevatedButton(
          onPressed: () async => Provider.of<InventoryController>(context, listen: false).useItem(inventoryItem.item.id, itemUser),
          child: const Text('Use'),
        ),
      )
    ),
  );
}