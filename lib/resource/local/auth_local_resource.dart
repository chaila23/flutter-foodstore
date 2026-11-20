   import 'package:shared_preferences/shared_preferences.dart';

   class AuthLocalResource {
     /// Simpan token ke storage
     static Future<void> saveToken(String token) async {
       final prefs = await SharedPreferences.getInstance();
       await prefs.setString('token', token);
     }

     /// Ambil token dari storage
     static Future<String?> getToken() async {
       final prefs = await SharedPreferences.getInstance();
       return prefs.getString('token');
     }

     /// Hapus token dari storage
     static Future<void> deleteToken() async {
       final prefs = await SharedPreferences.getInstance();
       await prefs.remove('token');
     }
   }