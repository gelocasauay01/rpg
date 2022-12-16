// External Dependencies
import 'dart:convert';
import 'package:flutter/foundation.dart';

// Models
import 'package:rpg/models/profile.dart';
import 'package:rpg/controllers/file_controller.dart';
import 'package:rpg/interface/item_user.dart';

class ProfileController with ChangeNotifier implements ItemUser{
  final String _fileName = 'profile.json';
  Profile? _profile; 

  Profile get profile => Profile(
    imageUrl: _profile!.imageUrl,
    name: _profile!.name,
    healthValue: _profile!.healthValue,
    goldValue: _profile!.goldValue,
  );
  

  bool get isAlive => _profile!.isAlive;

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

  Future<void> payGold(int paymentValue) async {
    _profile!.payGold(paymentValue);
    await _writeProfile();
    notifyListeners();
  }

  bool isCanBuy(int price) {
    return _profile!.goldValue >= price;
  }

  Future<bool> isNewGame() async {
    String? profileJSON = await FileController.readFile(_fileName);
    if(_profile == null && profileJSON != null) {
      _profile = Profile.fromJSON(jsonDecode(profileJSON));
    }
    return _profile != null;
  }

  Future<void> _writeProfile() async {
    await FileController.writeFile(_fileName, jsonEncode(profile.toJSON()));
  }

  @override
  Future<void> useItem(dynamic newValue) async {
    _profile!.heal(newValue);
    await _writeProfile();
    notifyListeners();
  }
}