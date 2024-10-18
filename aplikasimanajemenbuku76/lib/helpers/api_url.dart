class ApiUrl {
  // Replace with the appropriate server address
  static const String baseUrl = 'http://responsi.webwizards.my.id/api';

  // Endpoints for registration and login
  static const String registrasi = '$baseUrl/registrasi'; // Registration (POST)
  static const String login = '$baseUrl/login';           // Login (POST)

  // Endpoints for operations on lokasi_rak
  static const String listLokasiRak = '$baseUrl/buku/lokasi_rak';  // Get list of locations (GET)
  static const String createLokasiRak = listLokasiRak; // Add new location (POST)

  // Get details of a location with a specific ID (GET)
  static String showLokasiRak(int id) {
    return '$listLokasiRak/$id'; // Example: http://responsi.webwizards.my.id/api/buku/lokasi_rak/1
  }

  // Update location data with a specific ID (PUT)
  static String updateLokasiRak(int id) {
    return '$listLokasiRak/$id/update'; // Example: http://responsi.webwizards.my.id/api/buku/lokasi_rak/1/update
  }

  // Delete location data with a specific ID (DELETE)
  static String deleteLokasiRak(int id) {
    return '$listLokasiRak/$id/delete'; // Example: http://responsi.webwizards.my.id/api/buku/lokasi_rak/1/delete
  }
}
