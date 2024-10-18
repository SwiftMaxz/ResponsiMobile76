import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    String apiUrl = ApiUrl.registrasi;

    var body = {
      "nama": nama,
      "email": email,
      "password": password,
    };

    try {
      var response = await Api().post(apiUrl, body);
      var jsonObj = json.decode(response.body);
      return Registrasi.fromJson(jsonObj);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
