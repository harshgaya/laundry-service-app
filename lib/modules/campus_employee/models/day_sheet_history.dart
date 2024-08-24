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
  String uid;
  List<StudentDaySheet> studentDaySheet;
  List<FacultyDaySheet> facultyDaySheet;
  Campus campus;

  EmployeeData({
    required this.id,
    required this.uid,
    required this.studentDaySheet,
    required this.facultyDaySheet,
    required this.campus,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'],
      uid: json['uid'],
      studentDaySheet: List<StudentDaySheet>.from(
          json['student_day_sheet'].map((x) => StudentDaySheet.fromJson(x))),
      facultyDaySheet: List<FacultyDaySheet>.from(
          json['faculty_day_sheet'].map((x) => FacultyDaySheet.fromJson(x))),
      campus: Campus.fromJson(json['campus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'student_day_sheet':
          List<dynamic>.from(studentDaySheet.map((x) => x.toJson())),
      'faculty_day_sheet':
          List<dynamic>.from(facultyDaySheet.map((x) => x.toJson())),
      'campus': campus.toJson(),
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

class Campus {
  int id;
  College college;
  String uid;
  bool isActive;
  String createdAt;
  String updatedAt;
  String tagName;
  String name;
  bool uniform;

  Campus({
    required this.id,
    required this.college,
    required this.uid,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.tagName,
    required this.name,
    required this.uniform,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      id: json['id'],
      college: College.fromJson(json['college']),
      uid: json['uid'],
      isActive: json['isActive'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      tagName: json['tag_name'],
      name: json['name'],
      uniform: json['uniform'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'college': college.toJson(),
      'uid': uid,
      'isActive': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'tag_name': tagName,
      'name': name,
      'uniform': uniform,
    };
  }
}

class College {
  int id;
  String uid;
  String name;
  String monthlyPayment;
  String deliveryTime;
  int schedule;
  List<String> campusEmployee;

  College({
    required this.id,
    required this.uid,
    required this.name,
    required this.monthlyPayment,
    required this.deliveryTime,
    required this.schedule,
    required this.campusEmployee,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      monthlyPayment: json['monthly_payment'],
      deliveryTime: json['delivery_time'],
      schedule: json['schedule'],
      campusEmployee: List<String>.from(json['campus_employee']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'monthly_payment': monthlyPayment,
      'delivery_time': deliveryTime,
      'schedule': schedule,
      'campus_employee': List<dynamic>.from(campusEmployee.map((x) => x)),
    };
  }
}
