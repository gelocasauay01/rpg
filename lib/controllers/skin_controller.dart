// External Dependencies
import 'dart:convert';
import 'package:flutter/material.dart';

// Models
import 'package:rpg/models/skins.dart';
import 'package:rpg/controllers/file_controller.dart';

class SkinController with ChangeNotifier {

  final String _jsonId = 'SkinId';
  final String _fileName = 'theme.json';

  String _activeSkinId = Skins.normalId;
  
  SkinController();

  ThemeData get themeData {
    return Skins.getSkinById(_activeSkinId).themeData;
  }

  Future<void> initializeSkin() async {
    String? skinJSON = await FileController.readFile(_fileName);

    if(skinJSON != null) {
      Map<String, dynamic> jsonContent = jsonDecode(skinJSON);
      _activeSkinId = jsonContent[_jsonId];
    }
    
    else {
      await writeSkin();
    }

    notifyListeners();
  }

  Future<void> writeSkin() async {
    await FileController.writeFile(_fileName, jsonEncode({_jsonId: _activeSkinId}));
  }

  Future<void> setSkin(String skinId) async {
    _activeSkinId = skinId;
    await writeSkin();
    notifyListeners();
  }
  
}