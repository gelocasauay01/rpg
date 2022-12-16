import 'package:rpg/interface/item_user.dart';
import 'package:rpg/models/items/inventory_item.dart';
import 'package:rpg/models/items/skin.dart';

class InventorySkin extends InventoryItem {
  InventorySkin({
    required Skin skin
  }) : super(item: skin);

  @override
  Map<String, dynamic> toJSON() => {
    'Id': item.id,
    'Type': 'Skin'
  };

  @override
  Future<void> beUsed(ItemUser itemUser) async {
    await itemUser.useItem(item.id);
  }
}