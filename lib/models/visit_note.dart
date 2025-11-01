class VisitNote {
  final String id;
  final DateTime date;
  final String location;
  final String apartmentName;
  final int? buildingAge;
  final String? direction; // 향 (남향, 남동향 등)
  final String? structure;
  final bool? hasElevator; // 엘리베이터 (있음/없음)
  final String? parkingType; // 주차장 (지상/지하/혼합)
  final int? householdCount; // 세대수
  final double? area; // 해당평형 (㎡)
  final String? schoolInfo; // 학교정보
  final int? onlinePrice; // 온라인 시세
  final int? fieldPrice; // 현장 시세
  final int? salePrice; // 매매가
  final int? rentPrice; // 전월세가
  final int? actualPrice; // 실거래가
  final String memo;
  final List<String> photoPaths;
  final int timestamp;

  VisitNote({
    required this.id,
    required this.date,
    required this.location,
    required this.apartmentName,
    this.buildingAge,
    this.direction,
    this.structure,
    this.hasElevator,
    this.parkingType,
    this.householdCount,
    this.area,
    this.schoolInfo,
    this.onlinePrice,
    this.fieldPrice,
    this.salePrice,
    this.rentPrice,
    this.actualPrice,
    required this.memo,
    required this.photoPaths,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'location': location,
        'apartmentName': apartmentName,
        'buildingAge': buildingAge,
        'direction': direction,
        'structure': structure,
        'hasElevator': hasElevator,
        'parkingType': parkingType,
        'householdCount': householdCount,
        'area': area,
        'schoolInfo': schoolInfo,
        'onlinePrice': onlinePrice,
        'fieldPrice': fieldPrice,
        'salePrice': salePrice,
        'rentPrice': rentPrice,
        'actualPrice': actualPrice,
        'memo': memo,
        'photoPaths': photoPaths,
        'timestamp': timestamp,
      };

  factory VisitNote.fromJson(Map<String, dynamic> json) {
    try {
      return VisitNote(
        id: json['id'] as String? ?? '',
        date: json['date'] != null 
            ? DateTime.parse(json['date'] as String)
            : DateTime.now(),
        location: json['location'] as String? ?? '',
        apartmentName: json['apartmentName'] as String? ?? '',
        buildingAge: json['buildingAge'] as int?,
        direction: json['direction'] as String?,
        structure: json['structure'] as String?,
        hasElevator: json['hasElevator'] as bool?,
        parkingType: json['parkingType'] as String?,
        householdCount: json['householdCount'] as int?,
        area: json['area'] != null ? (json['area'] as num).toDouble() : null,
        schoolInfo: json['schoolInfo'] as String?,
        onlinePrice: json['onlinePrice'] as int?,
        fieldPrice: json['fieldPrice'] as int?,
        salePrice: json['salePrice'] as int?,
        rentPrice: json['rentPrice'] as int?,
        actualPrice: json['actualPrice'] as int?,
        memo: json['memo'] as String? ?? '',
        photoPaths: json['photoPaths'] != null 
            ? List<String>.from(json['photoPaths'] as List) 
            : [],
        timestamp: json['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw FormatException('Failed to parse VisitNote from JSON: $e');
    }
  }

  VisitNote copyWith({
    String? id,
    DateTime? date,
    String? location,
    String? apartmentName,
    int? buildingAge,
    String? direction,
    String? structure,
    bool? hasElevator,
    String? parkingType,
    int? householdCount,
    double? area,
    String? schoolInfo,
    int? onlinePrice,
    int? fieldPrice,
    int? salePrice,
    int? rentPrice,
    int? actualPrice,
    String? memo,
    List<String>? photoPaths,
    int? timestamp,
  }) {
    return VisitNote(
      id: id ?? this.id,
      date: date ?? this.date,
      location: location ?? this.location,
      apartmentName: apartmentName ?? this.apartmentName,
      buildingAge: buildingAge ?? this.buildingAge,
      direction: direction ?? this.direction,
      structure: structure ?? this.structure,
      hasElevator: hasElevator ?? this.hasElevator,
      parkingType: parkingType ?? this.parkingType,
      householdCount: householdCount ?? this.householdCount,
      area: area ?? this.area,
      schoolInfo: schoolInfo ?? this.schoolInfo,
      onlinePrice: onlinePrice ?? this.onlinePrice,
      fieldPrice: fieldPrice ?? this.fieldPrice,
      salePrice: salePrice ?? this.salePrice,
      rentPrice: rentPrice ?? this.rentPrice,
      actualPrice: actualPrice ?? this.actualPrice,
      memo: memo ?? this.memo,
      photoPaths: photoPaths ?? this.photoPaths,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

