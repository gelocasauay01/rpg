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
}