// Models
import 'package:rpg/enum/shop_mode.dart';
import 'package:rpg/models/shop_item.dart';
import 'package:rpg/models/potions.dart';
import 'package:rpg/models/skins.dart';
import 'package:rpg/models/consumable_item.dart';
import 'package:rpg/models/item.dart';
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

  static void buyItem({required ProfileController profileController, required InventoryController inventoryController, required ShopItem shopItem, required ShopMode shopMode, required Function onError}) {
    if(profileController.isCanBuy(shopItem.price)) {
      Item newItem = shopItem.item;

      // Converts item to consumable item
      if(shopMode == ShopMode.consumable) {
        newItem = ConsumableItem.fromItem(item: newItem, quantity: 1);
      }

      inventoryController.addItem(newItem, shopMode);
      profileController.payGold(shopItem.price);
    }
    
    else {
      onError();
    }
  }
}
