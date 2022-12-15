import 'package:rpg/models/items/item.dart';

class ShopItem {
  final Item item;
  final int price;
  
  ShopItem({
    required this.item,
    required this.price
  });
}