
import 'package:rpg/interface/item_user.dart';
import 'package:rpg/models/items/potion.dart';
import 'package:rpg/models/items/quantified_item.dart';

class InventoryPotion extends QuantifiedItem {
  InventoryPotion({
    required Potion potion,
    super.quantity = 1
  }) : super(
    item: potion
  );

  @override
  Map<String, dynamic> toJSON() => {
    'Id': item.id,
    'Type': 'Potion',
    'Quantity': quantity
  };

  @override
  Future<void> beUsed(ItemUser itemUser) async {
    await itemUser.useItem((item as Potion).healValue);
    quantity -= 1;
  }

}