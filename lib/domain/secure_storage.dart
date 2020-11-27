import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageMixin {
  final secureStore = new FlutterSecureStorage();

  void setSecureStorage(String key, String data) async {
    await secureStore.write(key: key, value: data);
  }

  Future<String> getSecureStorage(String key) async {
    return await secureStore.read(key: key);
  }

  void delete(String key) async {
    await secureStore.delete(key: key);
  }

  void deleteAll() async {
    await secureStore.deleteAll();
  }

}
