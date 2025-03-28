class EmployeeCollections {
  String? message;
  List<EmployeeData> data;

  EmployeeCollections({
    required this.message,
    required this.data,
  });

  factory EmployeeCollections.fromJson(Map<String, dynamic> json, String key) {
    return EmployeeCollections(
      message: json['message'] ?? '',
      data: List<EmployeeData>.from(
          json[key].map((x) => EmployeeData.fromJson(x))),
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
  int? id;
  String? uid;
  String? currentStatus;
  String? createdAt;
  String? updatedAt;
  List<StudentDaySheet> studentDaySheet;
  List<FacultyDaySheet> facultyDaySheet;
  Campus campus;
  List<WarehouseRemark> warehouseRemarks;
  List<StudentRemark> studentRemarks;
  List<StatusEntry> statusEntry;
  String? noTag;
  Map<String, dynamic> completedSegRange;
  List<OtherClothDaySheet> otherClothDaySheet;

  EmployeeData({
    required this.id,
    required this.uid,
    required this.studentDaySheet,
    required this.facultyDaySheet,
    required this.campus,
    required this.currentStatus,
    required this.createdAt,
    required this.completedSegRange,
    required this.warehouseRemarks,
    required this.studentRemarks,
    required this.statusEntry,
    required this.updatedAt,
    required this.noTag,
    required this.otherClothDaySheet,
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
      currentStatus: json['current_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      otherClothDaySheet: List<OtherClothDaySheet>.from(
          json['other_cloth_daysheet']
              .map((x) => OtherClothDaySheet.fromJson(x))),
      completedSegRange: json['completed_segregation_range'] ?? {},
      warehouseRemarks: List<WarehouseRemark>.from(
          json['warehouse_remark'].map((x) => WarehouseRemark.fromJson(x))),
      studentRemarks: List<StudentRemark>.from(
          json['student_remark'].map((x) => StudentRemark.fromJson(x))),
      statusEntry: List<StatusEntry>.from(
          json['previous_status'].map((x) => StatusEntry.fromJson(x))),
      noTag: json['no_tag'].toString(),
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
      'current_status': currentStatus,
      'created_at': createdAt,
      'warehouse_remark':
          List<dynamic>.from(warehouseRemarks.map((x) => x.toJson())),
      'student_remark':
          List<dynamic>.from(studentRemarks.map((x) => x.toJson())),
    };
  }
}

class StudentDaySheet {
  int? id;
  String? uid;
  String? createdAt;
  String? updatedAt;
  String? tagNumber;
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
  int? id;
  Map<String, dynamic>? faculty;
  String? uid;
  String? createdAt;
  String? updatedAt;
  String? tagNumber;
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
    required this.faculty,
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
        faculty: json['faculty']);
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
      'faculty': faculty,
    };
  }
}

class Campus {
  int? id;
  College college;
  String? uid;
  bool isActive;
  String? createdAt;
  String? updatedAt;
  String? tagName;
  String? name;
  bool uniform;
  int? maxStudentCount;
  String color;

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
    required this.maxStudentCount,
    required this.color,
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
        maxStudentCount: json['max_student_count'],
        color: json['color']);
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
  int? id;
  String? uid;
  String? name;
  String? monthlyPayment;
  String? deliveryTime;
  int? schedule;
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

class WarehouseRemark {
  String tagNumber;
  String remark;
  String employee;

  WarehouseRemark({
    required this.tagNumber,
    required this.remark,
    required this.employee,
  });

  factory WarehouseRemark.fromJson(Map<String, dynamic> json) {
    return WarehouseRemark(
      tagNumber: json['tag_number'],
      remark: json['remark'],
      employee: json['employee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tag_number': tagNumber,
      'remark': remark,
      'employee': employee,
    };
  }
}

class StudentRemark {
  String tagNumber;
  String remark;
  String resolution;
  bool remarkStatus;

  StudentRemark({
    required this.tagNumber,
    required this.remark,
    required this.remarkStatus,
    required this.resolution,
  });

  factory StudentRemark.fromJson(Map<String, dynamic> json) {
    return StudentRemark(
        tagNumber: json['tag_number'] ?? '',
        remark: json['remark'] ?? '',
        resolution: json['resolution'] ?? '',
        remarkStatus: json['remark_status'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'tag_number': tagNumber,
      'remark': remark,
    };
  }
}

class StatusEntry {
  String status;
  String updatedTime;

  StatusEntry({required this.status, required this.updatedTime});

  factory StatusEntry.fromJson(Map<String, dynamic> json) {
    return StatusEntry(
      status: json['status'],
      updatedTime: json['updated_time'],
    );
  }
}

class StatusHandler {
  List<StatusEntry> previousStatus;

  StatusHandler({required this.previousStatus});

  factory StatusHandler.fromJson(List<dynamic> jsonList) {
    List<StatusEntry> statusList =
        jsonList.map((json) => StatusEntry.fromJson(json)).toList();

    return StatusHandler(previousStatus: statusList);
  }

  String? getUpdatedTime(String status) {
    for (var entry in previousStatus) {
      if (entry.status == status) {
        return entry.updatedTime;
      }
    }
    return null;
  }
}

class OtherClothDaySheet {
  String name;
  String uid;
  int noOfItems;
  bool delivered;

  OtherClothDaySheet({
    required this.delivered,
    required this.name,
    required this.noOfItems,
    required this.uid,
  });
  factory OtherClothDaySheet.fromJson(Map<String, dynamic> json) {
    return OtherClothDaySheet(
        delivered: json['delivered'],
        name: json['name'],
        noOfItems: json['number_of_items'],
        uid: json['uid']);
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'number_of_items': noOfItems, 'delivered': false};
  }
}
