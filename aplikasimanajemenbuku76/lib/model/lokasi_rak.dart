class LokasiRak {
  int? id;
  int shelfNumber;
  String aisleLetter;
  int floorLevel;

  LokasiRak({
    this.id,
    required this.shelfNumber,
    required this.aisleLetter,
    required this.floorLevel,
  });

  factory LokasiRak.fromJson(Map<String, dynamic> json) {
    return LokasiRak(
      id: json['id'] as int?, // Make sure this matches your API
      shelfNumber: json['shelf_number'] as int,
      aisleLetter: json['aisle_letter'] as String,
      floorLevel: json['floor_level'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shelf_number': shelfNumber,
      'aisle_letter': aisleLetter,
      'floor_level': floorLevel,
    };
  }
}
