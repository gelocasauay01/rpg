// External Dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg/controllers/profile_controller.dart';


// Models
import 'package:rpg/models/items/shop_item.dart';
import 'package:rpg/controllers/inventory_controller.dart';
import 'package:rpg/enum/shop_mode.dart';
import 'package:rpg/controllers/shop_controller.dart';

class ShopItemWidget extends StatefulWidget {

  final ShopItem _shopItem;
  final ShopMode _shopMode;

  const ShopItemWidget(
    this._shopItem,
    this._shopMode,
    { super.key }
  );

  @override
  State<ShopItemWidget> createState() => _ShopItemWidgetState();
}

class _ShopItemWidgetState extends State<ShopItemWidget> {

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.monetization_on),
        title: const Text('Insufficient Funds', textAlign: TextAlign.start),
        content: const Text('Not enough gold to buy'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text('Ok')
          )
        ],
      )
    );
  }

  void _buyItem() {

    ShopController.buyItem(
      profileController: Provider.of<ProfileController>(context, listen: false),
      inventoryController: Provider.of<InventoryController>(context, listen: false),
      shopItem: widget._shopItem, 
      onError: () => _showErrorDialog(context)
    );
    
    // rebuilds an item when a skin is bought
    if(widget._shopMode == ShopMode.skin) {
      setState(() { }); 
    }
  }

  Widget _createBuyButton() => Row(
    children: [
      Container(
        height: 15,
        width: 15,
        margin: const EdgeInsets.only(right: 8.0),
        child: Image.asset('assets/images/coin.png')
      ),
      Text(widget._shopItem.price.toString()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    InventoryController inventoryController = Provider.of<InventoryController>(context, listen: false);
    bool isSkinBought = widget._shopMode == ShopMode.skin && inventoryController.isItemExist(widget._shopItem.item.id);
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(30.0)
      ),
      child: ListTile(
        leading: Image.asset(widget._shopItem.item.imageUrl),
        title: Text (widget._shopItem.item.title),
        subtitle: Text(widget._shopItem.item.description),
        trailing:  ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40.0), 
            bottomRight: Radius.circular(40.0)
          ),
          child: isSkinBought 
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Sold', style: Theme.of(context).textTheme.caption),
          ) 
          : ElevatedButton(
            onPressed: _buyItem,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: _createBuyButton() 
            ),
          ),
        )
      ),
    );
  }
}