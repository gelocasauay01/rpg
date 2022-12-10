// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg/controllers/inventory_controller.dart';
import 'package:rpg/controllers/skin_controller.dart';

// Models
import 'package:rpg/models/item.dart';
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/models/consumable_item.dart';


class InventoryList extends StatelessWidget {

  final List<Item> _items;

  const InventoryList(
    this._items,
    {super.key}
  );

  void _useItem(BuildContext context, Item item) {

    if(item is ConsumableItem) {
      // Pass the profile controller to manipulate gold value and inventory controller to manipulate item quantities
      item.onUse(Provider.of<ProfileController>(context, listen:false));
      Provider.of<InventoryController>(context, listen: false).decreaseConsumable(item.id);
    }

    else {
      // Pass settings controller to manipulate theme data
      item.onUse(Provider.of<SkinController>(context, listen: false));
    }
  }   

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: ListTile(
          leading: Image.asset(_items[index].imageUrl),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text (_items[index].title),
              
              if(_items[index] is ConsumableItem) 
                Text('x${(_items[index] as ConsumableItem).quantity.toString()}')
            ],
          ),
          subtitle: Text(_items[index].description),
          trailing:  ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40.0), 
              bottomRight: Radius.circular(40.0)
            ),
            child: ElevatedButton(
              onPressed: () => _useItem(context, _items[index]),
              child: const Text('Use'),
            ),
          )
        ),
      )
    );
  }
}