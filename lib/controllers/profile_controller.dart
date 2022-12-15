// External Dependencies
import 'dart:convert';
import 'package:flutter/foundation.dart';

// Models
import 'package:rpg/models/profile.dart';
import 'package:rpg/controllers/file_controller.dart';

class ProfileController with ChangeNotifier{
  final String _fileName = 'profile.json';
  Profile? _profile; 

  Profile? get profile {
    return Profile(
      imageUrl: _profile!.imageUrl,
      name: _profile!.name,
      healthValue: _profile!.healthValue,
      goldValue: _profile!.goldValue,
    );
  }

  bool get isAlive {
    return _profile!.isAlive;
  }

  Future<void> setProfile(Profile profile) async {
    _profile = profile;
    await _writeProfile();
  }

  Future<void> updateProfile(String name, String? imagePath) async {
    if(_profile == null) return;

    _profile!.name = name;

    if(imagePath != null){
      await FileController.deleteFile(_profile!.imageUrl);
      _profile!.imageUrl = imagePath;
    } 

    await _writeProfile();
    notifyListeners();
  }

  Future<void> takeDamage(int damage) async {
    _profile!.takeDamage(damage);
    await _writeProfile();
    notifyListeners();
  }

  Future<void> receiveGoldReward(int goldReward) async {
    _profile!.receiveGoldReward(goldReward);
    await _writeProfile();
    notifyListeners();
  }

  Future<void> heal(int healValue) async {
    _profile!.heal(healValue);
    await _writeProfile();
    notifyListeners();
  }

  Future<void> payGold(int paymentValue) async {
    _profile!.payGold(paymentValue);
    await _writeProfile();
    notifyListeners();
  }

  bool isCanBuy(int price) {
    return _profile!.goldValue >= price;
  }

  Future<bool> isNewGame() async {
    bool isInit = false;

    if(_profile == null) {
      String? profileJSON = await FileController.readFile(_fileName);

      if(profileJSON != null) {
        _profile = Profile.fromJSON(jsonDecode(profileJSON));
        isInit = true;
      }
      
    } 

    else {
      isInit = true;
    }

    return isInit;
  }

    Future<void> _writeProfile() async {
    await FileController.writeFile(_fileName, jsonEncode(profile!.toJSON()));
  }
}