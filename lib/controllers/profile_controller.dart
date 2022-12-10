// External Dependencies
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

// Models
import 'package:rpg/models/profile.dart';
import 'package:rpg/controllers/file_controller.dart';

class ProfileController with ChangeNotifier{
  Profile? _profile; 

  Profile? get profile {
    return Profile(
      imageUrl: _profile!.imageUrl,
      name: _profile!.name,
      maxHealth: _profile!.maxHealth,
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

  Future<void> updateProfile(String name, File? file) async {
    if(profile == null) return;

    profile!.name = name;
    if(file != null){
      await FileController.deleteFile(profile!.imageUrl);
      profile!.imageUrl = file.path;
    } 
      await _writeProfile();
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
      String? profileJSON = await FileController.readFile('profile.json');

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
    await FileController.writeFile('profile.json', jsonEncode(profile!.toJSON()));
  }
}