class EmployeeCollections {
  String message;
  List<EmployeeData> data;

  EmployeeCollections({
    required this.message,
    required this.data,
  });

  factory EmployeeCollections.fromJson(Map<String, dynamic> json) {
    return EmployeeCollections(
      message: json['message'],
      data: List<EmployeeData>.from(
          json['data'].map((x) => EmployeeData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class EmployeeData {
  int id;
  List<StudentDaySheet> studentDaySheet;
  List<FacultyDaySheet> facultyDaySheet;

  EmployeeData({
    required this.id,
    required this.studentDaySheet,
    required this.facultyDaySheet,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'],
      studentDaySheet: List<StudentDaySheet>.from(
          json['student_day_sheet'].map((x) => StudentDaySheet.fromJson(x))),
      facultyDaySheet: List<FacultyDaySheet>.from(
          json['faculty_day_sheet'].map((x) => FacultyDaySheet.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_day_sheet':
          List<dynamic>.from(studentDaySheet.map((x) => x.toJson())),
      'faculty_day_sheet':
          List<dynamic>.from(facultyDaySheet.map((x) => x.toJson())),
    };
  }
}

class StudentDaySheet {
  int id;
  String uid;
  String createdAt;
  String updatedAt;
  String tagNumber;
  int campusRegularCloths;
  int campusUniforms;
  int wareHouseRegularCloths;
  int wareHouseUniform;
  bool delivered;

  StudentDaySheet({
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.tagNumber,
    required this.campusRegularCloths,
    required this.campusUniforms,
    required this.wareHouseRegularCloths,
    required this.wareHouseUniform,
    required this.delivered,
  });

  factory StudentDaySheet.fromJson(Map<String, dynamic> json) {
    return StudentDaySheet(
      id: json['id'],
      uid: json['uid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      tagNumber: json['tag_number'],
      campusRegularCloths: json['campus_regular_cloths'],
      campusUniforms: json['campus_uniforms'],
      wareHouseRegularCloths: json['ware_house_regular_cloths'],
      wareHouseUniform: json['ware_house_uniform'],
      delivered: json['delivered'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'tag_number': tagNumber,
      'campus_regular_cloths': campusRegularCloths,
      'campus_uniforms': campusUniforms,
      'ware_house_regular_cloths': wareHouseRegularCloths,
      'ware_house_uniform': wareHouseUniform,
      'delivered': delivered,
    };
  }
}

class FacultyDaySheet {
  int id;
  String uid;
  String createdAt;
  String updatedAt;
  String tagNumber;
  int regularCloths;
  int wareHouseRegularCloths;
  bool delivered;

  FacultyDaySheet({
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.tagNumber,
    required this.regularCloths,
    required this.wareHouseRegularCloths,
    required this.delivered,
  });

  factory FacultyDaySheet.fromJson(Map<String, dynamic> json) {
    return FacultyDaySheet(
      id: json['id'],
      uid: json['uid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      tagNumber: json['tag_number'],
      regularCloths: json['regular_cloths'],
      wareHouseRegularCloths: json['ware_house_regular_cloths'],
      delivered: json['delivered'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'tag_number': tagNumber,
      'regular_cloths': regularCloths,
      'ware_house_regular_cloths': wareHouseRegularCloths,
      'delivered': delivered,
    };
  }
}
