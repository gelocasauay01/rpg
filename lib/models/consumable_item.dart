import 'package:rpg/models/item.dart';

class ConsumableItem extends Item {
  int quantity;

  ConsumableItem({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.onUse,
    required this.quantity
  });

  ConsumableItem.fromItem({
    required Item item, 
    required int quantity
  }) : this(
    id: item.id, 
    title: item.title, 
    description: item.description,
    imageUrl: item.imageUrl, 
    onUse: item.onUse, 
    quantity: quantity
  );

  void incrementQuantity(int additionalQuantity) {
    quantity += additionalQuantity;
  }

  void useItem() {
    if(quantity > 0) {
      onUse();
      quantity -= 1;
    }
  }

}