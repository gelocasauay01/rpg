import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/models/items/item.dart';

class Potion extends Item{

  final int healValue;

  Potion({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    this.healValue = 2
  });

  void heal(ProfileController profileController) {
    profileController.heal(healValue);
  }

}