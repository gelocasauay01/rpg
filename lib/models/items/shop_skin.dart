import 'package:rpg/models/items/shop_item.dart';
import 'package:rpg/models/items/skin.dart';
import 'package:rpg/models/items/inventory_skin.dart';

class ShopSkin extends ShopItem {
  ShopSkin({
    required Skin skin,
    required super.price
  }) : super(item: skin);

  @override 
  InventorySkin toInventoryItem() => InventorySkin(skin: item as Skin);
 
}