import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/model/lokasi_rak.dart'; // Sesuaikan dengan model LokasiRak

class LokasiRakBloc {
  // Mendapatkan semua lokasi rak
  static Future<List<LokasiRak>> getLokasiRaks() async {
    String apiUrl = ApiUrl.listLokasiRak; // Endpoint untuk mendapatkan list lokasi rak
    var response = await Api().get(apiUrl);
    
    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      List<dynamic> listLokasiRak = (jsonObj as Map<String, dynamic>)['data'];
      List<LokasiRak> lokasiRaks = [];

      for (var item in listLokasiRak) {
        lokasiRaks.add(LokasiRak.fromJson(item)); // Pastikan model LokasiRak ada
      }
      return lokasiRaks;
    } else {
      // Handle error response
      throw Exception('Gagal memuat lokasi rak: ${response.statusCode}');
    }
  }

  // Menambahkan lokasi rak baru
  static Future<bool> addLokasiRak({LokasiRak? lokasiRak}) async {
    String apiUrl = ApiUrl.createLokasiRak; // Endpoint untuk menambahkan lokasi rak

    var body = {
    "shelf_number": lokasiRak!.shelfNumber.toString(), // Ensure it matches expected type
    "aisle_letter": lokasiRak.aisleLetter,
    "floor_level": lokasiRak.floorLevel.toString(), // Ensure it matches expected type
  };


    try {
      var response = await Api().post(apiUrl, body);
      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return jsonObj['status'] == true; // Check the status properly
      } else {
        print("Failed to add location: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }


  // Memperbarui lokasi rak yang ada
  static Future<bool> updateLokasiRak({required LokasiRak lokasiRak}) async {
    String apiUrl = ApiUrl.updateLokasiRak(lokasiRak.id!); // Make sure the ID is present

    var body = {
      "id": lokasiRak.id,  // You may include this if your API needs it, but usually not necessary.
      "shelf_number": lokasiRak.shelfNumber,
      "aisle_letter": lokasiRak.aisleLetter,
      "floor_level": lokasiRak.floorLevel,
    };

    try {
      var response = await Api().put(apiUrl, jsonEncode(body));
      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return jsonObj['status'] == true; // Check the status properly
      } else {
        print("Failed to update location: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }


  // Menghapus lokasi rak berdasarkan ID
  static Future<bool> deleteLokasiRak({required int id}) async {
    String apiUrl = ApiUrl.deleteLokasiRak(id); // Endpoint untuk menghapus lokasi rak

    var response = await Api().delete(apiUrl);
    
    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return jsonObj['data'] == true; // Assuming 'data' indicates success
    } else {
      // Handle error response
      throw Exception('Failed to delete lokasi rak: ${response.statusCode}');
    }
  }
}
