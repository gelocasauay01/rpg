// External Dependencies
import 'package:flutter/material.dart';

// Models
import 'package:rpg/models/items/item.dart';
import 'package:rpg/controllers/theme_controller.dart';

class Skin extends Item {
  final ThemeData themeData;

  Skin({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required this.themeData
  });

  void useItem(ThemeController themeController) {
    themeController.setSkin(id);
  }
  
  Map<String, dynamic> toJSON() => {
    'Id': id,
    'Type': 'Skin'
  };

}