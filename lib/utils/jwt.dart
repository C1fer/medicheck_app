import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JWTService{
  // Store JWT into OS-secure storage
  static Future<int?> saveJWT(String token) async {
    try {
      const storage = FlutterSecureStorage();
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
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'jwt');
      return token;

    } catch (except) {
      print('Error reading token: $except');
      return null;
    }

  }
}
