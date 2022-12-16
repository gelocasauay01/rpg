// Models
import 'package:rpg/models/items/shop_item.dart';
import 'package:rpg/models/items/potions.dart';
import 'package:rpg/models/items/shop_potion.dart';
import 'package:rpg/models/items/shop_skin.dart';
import 'package:rpg/models/items/skins.dart';
import 'package:rpg/controllers/inventory_controller.dart';
import 'package:rpg/controllers/profile_controller.dart';

class ShopController {
  final List<ShopItem> _consumableShopItems = [
    ShopPotion(
      potion: Potions.getPotionById(Potions.potionId),
      price: 100
    ),
    ShopPotion(
      potion: Potions.getPotionById(Potions.superPotionId),
      price: 190
    ),
    ShopPotion(
      potion: Potions.getPotionById(Potions.maxPotionId),
      price: 1000
    )
  ];

  final List<ShopItem> _skinShopItems = [
    ShopSkin(
      skin: Skins.getSkinById(Skins.darkId), 
      price: 1000
    )
  ];

  List<ShopItem> get consumableShopItems => [..._consumableShopItems];

  List<ShopItem> get skinShopItems => [..._skinShopItems];

  static void buyItem({required ProfileController profileController, required InventoryController inventoryController, required ShopItem shopItem, required Function onError}) {
    if(profileController.isCanBuy(shopItem.price)) {
      inventoryController.addItem(shopItem.toInventoryItem());
      profileController.payGold(shopItem.price);
    }
    else {
      onError();
    }
  }
}
