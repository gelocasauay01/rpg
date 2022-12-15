// External Dependencies
import 'package:flutter/material.dart';

// Models
import 'package:rpg/models/items/skin.dart';

class Skins { 
  static const String normalId = 'skin1';
  static const String darkId = 'skin2';

  static final Skin _normal = Skin(
    id: normalId,
    title: 'Normal',
    description: 'Normal Skin UI',
    imageUrl: 'assets/images/skins/normal.png',
    themeData: ThemeData.light(useMaterial3: true),
  );

  static final Skin _dark = Skin(
    id: darkId,
    title: 'Dark',
    description: 'Night Mode Skin',
    imageUrl: 'assets/images/skins/dark.png',
    themeData: ThemeData.dark(useMaterial3: true)
  );

  static Skin getSkinById(String skinId) {
    List<Skin> skins = [_normal, _dark];
    return skins.firstWhere((skin) => skin.id == skinId);
  }
}