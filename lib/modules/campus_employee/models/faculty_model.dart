class FacultyListModel {
  String message;
  List<Faculty> data;

  FacultyListModel({
    required this.message,
    required this.data,
  });

  factory FacultyListModel.fromJson(Map<String, dynamic> json) {
    return FacultyListModel(
      message: json['message'],
      data: List<Faculty>.from(json['data'].map((x) => Faculty.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class Faculty {
  int id;
  String campus;
  String uid;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String name;

  Faculty({
    required this.id,
    required this.campus,
    required this.uid,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'],
      campus: json['campus'],
      uid: json['uid'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campus': campus,
      'uid': uid,
      'isActive': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'name': name,
    };
  }
}
