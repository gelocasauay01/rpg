import 'package:rpg/models/items/inventory_item.dart';

abstract class QuantifiedItem extends InventoryItem{
  int quantity;

  QuantifiedItem({
    required super.item,
    required this.quantity
  });

  void setQuantity(int newQuantity) {
    quantity = newQuantity;
  }
}