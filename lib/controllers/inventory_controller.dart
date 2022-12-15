// External Dependencies
import 'dart:convert';
import 'package:flutter/foundation.dart';

// Models
import 'package:rpg/models/items/item.dart';
import 'package:rpg/models/items/consumable_item.dart';
import 'package:rpg/models/items/potion.dart';
import 'package:rpg/models/items/potions.dart';
import 'package:rpg/models/items/skin.dart';
import 'package:rpg/models/items/skins.dart';
import 'package:rpg/controllers/file_controller.dart';

class InventoryController with ChangeNotifier{

  final String _fileName = 'item.json';
  List<Item> _items = [];

  List<Item> get items => [..._items];

  Future<void> initializeItems() async {
    String? itemJSON = await FileController.readFile(_fileName);
    List<Item> initialItems = [Skins.getSkinById(Skins.normalId)];
    if(itemJSON != null) {
      List<dynamic> itemsMap = jsonDecode(itemJSON);
      initialItems = itemsMap.map((item) => item['Type'] == 'Consumable' 
        ? ConsumableItem.fromPotion(potion: Potions.getPotionById(item['Id']), quantity: item['Quantity']) 
        : Skins.getSkinById(item['Id'])).toList();
    }
    _items = initialItems;
  }

  Future<void> addItem(Item newItem) async {
    int index = _items.indexWhere((item) => item.id == newItem.id);
    bool isPotion = newItem is Potion;
    
    if(index == -1) {
      if(isPotion) {
        newItem = ConsumableItem.fromPotion(potion: newItem, quantity: 1);
      }
      _items.add(newItem);
    } 

    else if (isPotion){
      ConsumableItem item = _items[index] as ConsumableItem;
      item.incrementQuantity(1);
      _items[index] = item;
    }

    await _saveItems();
    notifyListeners();
  }

  Future<void> decreaseConsumable(String itemId) async {
    int index = _items.indexWhere((item) => item.id == itemId);

    if(index == -1 || _items[index] is Skin) {
      return;
    }

    if(_items[index] is ConsumableItem) {
      ConsumableItem item = _items[index] as ConsumableItem;
      item.incrementQuantity(-1);
      if(item.quantity <= 0) {
        _items.removeAt(index);
      }
    } 

    await _saveItems();
    notifyListeners();
  }

  bool isItemExist(String itemId) {
    return _items.indexWhere((item) => item.id == itemId) != -1;
  }

  Future<void> _saveItems() async {
    List<Map<String, dynamic>> itemsMap = [];
    List<Map<String, dynamic>> consumables = [];
    List<Map<String, dynamic>> skins = [];

    for(Item item in _items) {
      if(item is ConsumableItem) {
        consumables.add(item.toJSON());
      }
      else if(item is Skin){
        skins.add(item.toJSON());
      }
    }
    
    itemsMap = [...consumables, ...skins];
    await FileController.writeFile(_fileName, jsonEncode(itemsMap));
  }
}