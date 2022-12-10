class StringUtils {
  static String toSentenceCase(String word) {
    return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
  }
}