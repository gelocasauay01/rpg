// External Dependencies
import 'dart:convert';
import 'package:flutter/foundation.dart';

// Models
import 'package:rpg/enum/shop_mode.dart';
import 'package:rpg/models/item.dart';
import 'package:rpg/models/consumable_item.dart';
import 'package:rpg/models/potions.dart';
import 'package:rpg/models/skins.dart';
import 'package:rpg/controllers/file_controller.dart';

class InventoryController with ChangeNotifier{

  final String _fileName = 'item.json';
  List<Item> _items = [];

  List<Item> get items => [..._items];

  Future<void> initializeItems() async {
    String? itemJSON = await FileController.readFile(_fileName);
    
    if(itemJSON != null) {
      List<dynamic> itemsMap = jsonDecode(itemJSON);
      _items = itemsMap.map((item) => item['Type'] == 'Consumable' 
        ? ConsumableItem.fromItem(item: Potions.getPotionById(item['Id']), quantity: item['Quantity']) 
        : Skins.getSkinById(item['Id'])).toList();
    }

    else {
      _items = [Skins.getSkinById(Skins.normalId)];
      await _saveItems();
    }

  }

  Future<void> addItem(Item newItem, ShopMode shopMode) async {
    int index = _items.indexWhere((item) => item.id == newItem.id);

    if(index == -1) {
      _items.add(newItem);
    } 

    else if(_items[index] is ConsumableItem && shopMode == ShopMode.consumable) {
      ConsumableItem item = _items[index] as ConsumableItem;
      item.incrementQuantity(1);
      _items[index] = item;
    }

    await _saveItems();
    notifyListeners();
  }

  Future<void> decreaseConsumable(String itemId) async {
    int index = _items.indexWhere((item) => item.id == itemId);

    if(index == -1 || _items[index] is! ConsumableItem) {
      return;
    }

    ConsumableItem item = _items[index] as ConsumableItem;
    item.quantity -= 1;

    if(item.quantity <= 0) {
      _items.removeAt(index);
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
        ConsumableItem consumableItem = item;
        consumables.add({
          'Id': item.id,
          'Type': 'Consumable',
          'Quantity': consumableItem.quantity
        });
      }
      else {
        skins.add({
          'Id': item.id,
          'Type': 'Skin'
        });
      }
    }
    
    itemsMap = [...consumables, ...skins];
    await FileController.writeFile(_fileName, jsonEncode(itemsMap));
  }
}