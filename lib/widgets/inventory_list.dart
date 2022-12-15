// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg/controllers/inventory_controller.dart';
import 'package:rpg/controllers/theme_controller.dart';

// Models
import 'package:rpg/models/items/item.dart';
import 'package:rpg/models/items/consumable_item.dart';
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/models/items/skin.dart';

class InventoryList extends StatelessWidget {

  final List<Item> _items;

  const InventoryList(
    this._items,
    {super.key}
  );

  void _useItem(BuildContext context, Item item) {
    if(item is ConsumableItem) {
      // Pass the profile controller to manipulate gold value and inventory controller to manipulate item quantities
      item.useItem(Provider.of<ProfileController>(context, listen:false));
      Provider.of<InventoryController>(context, listen: false).decreaseConsumable(item.id);
    }

    else if(item is Skin){
      // Pass settings controller to manipulate theme data
      item.useItem(Provider.of<ThemeController>(context, listen: false));
    }
  }   

  Widget _createInventoryItem(Item item, BuildContext context,) => Container(
    margin: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).dividerColor),
      borderRadius: BorderRadius.circular(30.0)
    ),
    child: ListTile(
      leading: Image.asset(item.imageUrl),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text (item.title),
          
          if(item is ConsumableItem) 
            Text('x${item.quantity.toString()}')
        ],
      ),
      subtitle: Text(item.description),
      trailing:  ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40.0), 
          bottomRight: Radius.circular(40.0)
        ),
        child: ElevatedButton(
          onPressed: () => _useItem(context, item),
          child: const Text('Use'),
        ),
      )
    ),
  );

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: _items.length,
    itemBuilder: (context, index) => _createInventoryItem(_items[index], context)
  );
  
}