class MapUtils {
  static String getKeyOfMaxValue(Map<String, int> map) {
    int highestValue = 0;
    String highestValueKey = 'None';

    for(String key in map.keys) {
      if(map[key]! > highestValue) {
        highestValue = map[key]!;
        highestValueKey = key;
      }
    }

    return highestValueKey;
  }
}