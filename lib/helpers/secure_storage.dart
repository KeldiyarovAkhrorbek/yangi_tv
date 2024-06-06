import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

  Future<String?> getToken() async {
    String? value = await storage.read(key: 'token');
    return value;
  }

  Future<String?> getNumber() async {
    String? value = await storage.read(key: 'phone_number_new');
    return value;
  }

  deleteSecureData(String key) async {
    await storage.delete(key: key);
  }
}