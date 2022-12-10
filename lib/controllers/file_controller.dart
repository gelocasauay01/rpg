// External Dependencies
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileController {
  
  static Future<void> writeFile(String fileName, String content) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String filePath = "${appDir.path}/$fileName";
    File file = File(filePath);
    await file.writeAsString(content);
  }

  static Future<String?> readFile(String fileName) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String filePath = "${appDir.path}/$fileName";
    File file = File(filePath);
    String? content;

    if(await file.exists()) {
      content = await file.readAsString();
    }

    return content;
  }

  static Future<void> deleteFile(String filePath) async {
    File file = File(filePath);
    await file.delete();
  }
}