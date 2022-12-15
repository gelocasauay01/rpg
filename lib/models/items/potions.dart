import 'package:rpg/models/items/potion.dart';

class Potions {
  static const String potionId = 'potion1';
  static const String superPotionId = 'potion2';
  static const String maxPotionId = 'potion3';

  static final Potion _potion = Potion(
    id: potionId,
    title: 'Potion',
    description: 'Recovers 3 hp',
    imageUrl: 'assets/images/potions/potion.png',
    healValue: 3
  );

  static final Potion _superPotion = Potion(
    id: superPotionId,
    title: 'Super Potion',
    description: 'Recovers 6 hp',
    imageUrl: 'assets/images/potions/super-potion.png',
    healValue: 6
  );

  static final Potion _maxPotion = Potion(
    id: maxPotionId,
    title: 'Max Potion',
    description: 'Recovers full hp',
    imageUrl: 'assets/images/potions/max-potion.png',
    healValue: 10
  );
  
  static Potion getPotionById(String potionId) {
    List<Potion> potions = [_potion, _superPotion, _maxPotion];
    return potions.firstWhere((potion) => potion.id == potionId);
  }
  
  
}
