// Models
import 'package:rpg/models/skin.dart';
import 'package:rpg/models/skin_theme.dart';
import 'package:rpg/controllers/skin_controller.dart';

class Skins { 
  static const String normalId = 'skin1';
  static const String darkId = 'skin2';

  static final Skin _normal = Skin(
    id: normalId,
    title: 'Normal',
    description: 'Normal Skin UI',
    imageUrl: 'assets/images/skins/normal.png',
    themeData: SkinTheme.normal,
    onUse: (SkinController skinController) {
      skinController.setSkin(_normal.id);
    }
  );

  static final Skin _dark = Skin(
    id: darkId,
    title: 'Dark',
    description: 'Night Mode Skin',
    imageUrl: 'assets/images/skins/dark.png',
    themeData: SkinTheme.dark,
    onUse: (SkinController skinController) {
      skinController.setSkin(_dark.id);
    }
  );

  static Skin getSkinById(String skinId) {
    List<Skin> skins = [_normal, _dark];
    return skins.firstWhere((skin) => skin.id == skinId);
  }
}