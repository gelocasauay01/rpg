import 'package:rpg/models/items/inventory_item.dart';
import 'package:rpg/models/items/inventory_potion.dart';
import 'package:rpg/models/items/potion.dart';
import 'package:rpg/models/items/shop_item.dart';

class ShopPotion extends ShopItem{
  ShopPotion({
    required Potion potion,
    required super.price
  }) : super(item: potion);

  @override
  InventoryItem toInventoryItem() => InventoryPotion(potion: item as Potion);
}