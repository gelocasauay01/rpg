// Models
import 'package:rpg/models/items/shop_item.dart';
import 'package:rpg/models/items/potions.dart';
import 'package:rpg/models/items/skins.dart';
import 'package:rpg/controllers/inventory_controller.dart';
import 'package:rpg/controllers/profile_controller.dart';

class ShopController {
  final List<ShopItem> _consumableShopItems = [
    ShopItem(
      item: Potions.getPotionById(Potions.potionId),
      price: 100
    ),
    ShopItem(
      item: Potions.getPotionById(Potions.superPotionId),
      price: 500
    ),
    ShopItem(
      item: Potions.getPotionById(Potions.maxPotionId),
      price: 1000
    )
  ];

  final List<ShopItem> _skinShopItems = [
    ShopItem(
      item: Skins.getSkinById(Skins.darkId), 
      price: 1000
    )
  ];

  List<ShopItem> get consumableShopItems => [..._consumableShopItems];

  List<ShopItem> get skinShopItems => [..._skinShopItems];

  static void buyItem({required ProfileController profileController, required InventoryController inventoryController, required ShopItem shopItem, required Function onError}) {
    if(profileController.isCanBuy(shopItem.price)) {
      inventoryController.addItem(shopItem.item);
      profileController.payGold(shopItem.price);
    }
    
    else {
      onError();
    }
  }
}
