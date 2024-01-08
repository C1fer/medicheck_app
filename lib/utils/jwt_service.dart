import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JWTService{
  static final storage = const FlutterSecureStorage();

  // Store JWT into OS-secure storage
  static Future<int?> saveJWT(String token) async {
    try {
      await storage.write(key: 'jwt', value: token);
      return 0;
    }
    catch (except) {
      print('Error saving token: $except');
      return 1;
    }
  }

  // Read JWT from OS-secure storage
  static Future<String?> readJWT() async {
    try {
      String? token = await storage.read(key: 'jwt');
      return token;

    } catch (except) {
      print('Error reading token: $except');
      return null;
    }

  }

  static Future<void> deleteJWT() async {
    try {
      await storage.delete(key: 'jwt');
    } catch (except) {
      print('Error deleting token: $except');
    }

  }
}
