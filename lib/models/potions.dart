import 'package:rpg/models/item.dart';
import 'package:rpg/controllers/profile_controller.dart';

class Potions {
  static const String potionId = 'potion1';
  static const String superPotionId = 'potion2';
  static const String maxPotionId = 'potion3';

  static final Item _potion = Item(
    id: potionId,
    title: 'Potion',
    description: 'Recovers 3 hp',
    imageUrl: 'assets/images/potions/potion.png',
    onUse: (ProfileController profileController) {
      profileController.heal(3);
    }
  );

  static final Item _superPotion = Item(
    id: superPotionId,
    title: 'Super Potion',
    description: 'Recovers 6 hp',
    imageUrl: 'assets/images/potions/super-potion.png',
    onUse: (ProfileController profileController) {
      profileController.heal(6);
    }
  );

  static final Item _maxPotion = Item(
    id: maxPotionId,
    title: 'Max Potion',
    description: 'Recovers full hp',
    imageUrl: 'assets/images/potions/max-potion.png',
    onUse: (ProfileController profileController) {
      profileController.heal(profileController.profile!.maxHealth);
    }
  );
  
  static Item getPotionById(String potionId) {
    List<Item> potions = [_potion, _superPotion, _maxPotion];
    return potions.firstWhere((potion) => potion.id == potionId);
  }
  
  
}
