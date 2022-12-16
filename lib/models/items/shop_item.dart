import 'package:rpg/models/items/inventory_item.dart';
import 'package:rpg/models/items/item.dart';

abstract class ShopItem {
  final Item item;
  final int price;
  
  ShopItem({
    required this.item,
    required this.price
  });

  InventoryItem toInventoryItem();
}