class DryArea {
  final int id;
  final FillArea? fillArea; // Nullable fillArea
  final String uid;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int dryAreaId;
  final int row;
  final int column;

  DryArea({
    required this.id,
    this.fillArea, // Nullable fillArea
    required this.uid,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.dryAreaId,
    required this.row,
    required this.column,
  });

  factory DryArea.fromJson(Map<String, dynamic> json) {
    return DryArea(
      id: json['id'],
      fillArea: json['fill_area'] != null
          ? FillArea.fromJson(json['fill_area'])
          : null, // Handle null fill_area
      uid: json['uid'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      dryAreaId: json['dry_area_id'],
      row: json['row'],
      column: json['column'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fill_area': fillArea?.toJson(), // Handle nullable fillArea
      'uid': uid,
      'isActive': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'dry_area_id': dryAreaId,
      'row': row,
      'column': column,
    };
  }
}

class FillArea {
  final int? id;
  final Map<String, dynamic>? filled;
  final DryAreaCampus? campus;

  FillArea({
    required this.id,
    required this.filled,
    required this.campus,
  });

  factory FillArea.fromJson(Map<String, dynamic> json) {
    return FillArea(
      id: json['id'] as int?,
      filled: json['filled'] != null
          ? Map<String, dynamic>.from(json['filled'] as Map<String, dynamic>)
          : null,
      campus: json['campus'] != null
          ? DryAreaCampus.fromJson(json: json['campus'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filled': filled,
      'campus': campus,
    };
  }
}

class DryAreaCampus {
  String uid;
  String name;
  String color;

  DryAreaCampus({required this.name, required this.uid, required this.color});

  factory DryAreaCampus.fromJson({required Map<String, dynamic> json}) {
    return DryAreaCampus(
        uid: json['uid'],
        name: json['name'] ?? '',
        color: json['color'] ?? '#1F51FF');
  }
}
