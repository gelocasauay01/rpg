import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/models/items/potion.dart';

class ConsumableItem extends Potion{
  int quantity;

  ConsumableItem({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    super.healValue,
    required this.quantity
  });

  ConsumableItem.fromPotion({
    required Potion potion, 
    required this.quantity
  }) : super(
    id: potion.id, 
    title: potion.title, 
    description: potion.description,
    imageUrl: potion.imageUrl, 
    healValue: potion.healValue
  );

  void incrementQuantity(int additionalQuantity) {
    quantity += additionalQuantity;
  }

  void useItem(ProfileController profileController) {
    if(quantity > 0) {
      heal(profileController);
    }
  }

  Map<String, dynamic> toJSON() => {
    'Id': id,
    'Type': 'Consumable',
    'Quantity': quantity
  };
}