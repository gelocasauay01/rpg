// External Dependencies
import 'dart:convert';
import 'package:flutter/foundation.dart';

// Models
import 'package:rpg/interface/item_user.dart';
import 'package:rpg/models/items/inventory_item.dart';
import 'package:rpg/models/items/inventory_potion.dart';
import 'package:rpg/models/items/inventory_skin.dart';
import 'package:rpg/models/items/quantified_item.dart';
import 'package:rpg/models/items/potions.dart';
import 'package:rpg/models/items/skins.dart';
import 'package:rpg/controllers/file_controller.dart';

class InventoryController with ChangeNotifier{

  final String _fileName = 'item.json';
  List<InventoryItem> _inventoryItems = [];
  List<InventoryItem> get inventoryItems => [..._inventoryItems];

  Future<void> initializeItems() async {
    String? itemJSON = await FileController.readFile(_fileName);
    final List<InventoryItem> initialItems = [InventorySkin(skin: Skins.getSkinById(Skins.normalId))];
    if(itemJSON != null && itemJSON.isNotEmpty) {
      initialItems.clear();
      List<dynamic> itemsMap = jsonDecode(itemJSON);
      if(itemsMap.isNotEmpty) {
        for(Map map in itemsMap) {
          switch(map['Type'] as String) {
            case 'Skin':
              initialItems.add(InventorySkin(skin: Skins.getSkinById(map['Id'])));
              break;
            case 'Potion':
              initialItems.add(InventoryPotion(potion: Potions.getPotionById(map['Id']), quantity: map['Quantity']));
              break;
            default:
              break;
          }

        }
      }
    } 
    _inventoryItems = initialItems;
  }

  Future<void> addItem(InventoryItem newInventoryItem) async {
    int index = _inventoryItems.indexWhere((inventoryItem) => inventoryItem.item.id == newInventoryItem.item.id);
    if(index == -1) {
      _inventoryItems.add(newInventoryItem);
    }
    else if(_inventoryItems[index] is QuantifiedItem) {
      QuantifiedItem quantifiedItem = _inventoryItems[index] as QuantifiedItem;
      quantifiedItem.setQuantity(quantifiedItem.quantity + 1);
      _inventoryItems[index] = quantifiedItem;
    }
    await _saveItems();
    notifyListeners();
  }

  Future<void> useItem(String itemId, ItemUser itemUser) async {
    int index = _inventoryItems.indexWhere((inventoryItem) => inventoryItem.item.id == itemId);
    if(index == -1) {
      return;
    }
    await _inventoryItems[index].beUsed(itemUser);
    if(_inventoryItems[index] is QuantifiedItem){
      QuantifiedItem quantifiedItem = _inventoryItems[index] as QuantifiedItem;
      if(quantifiedItem.quantity <= 0) {
        _inventoryItems.removeAt(index);
      }
    }
    await _saveItems();
    notifyListeners();
  }

  bool isItemExist(String itemId) {
    return _inventoryItems.indexWhere((inventoryItem) => inventoryItem.item.id == itemId) != -1;
  }

  Future<void> _saveItems() async {
    List<Map<String,dynamic>> itemsMap = _inventoryItems.map((inventoryItem) => inventoryItem.toJSON()).toList();
    await FileController.writeFile(_fileName, jsonEncode(itemsMap));
  }

}