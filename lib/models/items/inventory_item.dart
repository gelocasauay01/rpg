import 'package:rpg/interface/item_user.dart';
import 'package:rpg/models/items/item.dart';

abstract class InventoryItem<T>{
  Item item;
  InventoryItem({ required this.item });
  Map<String, dynamic> toJSON();
  Future<void> beUsed(ItemUser itemUser);
}