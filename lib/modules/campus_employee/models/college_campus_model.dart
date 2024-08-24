import 'dart:convert';

class CollegeCampusModel {
  String message;
  List<Data> data;

  CollegeCampusModel({
    required this.message,
    required this.data,
  });

  factory CollegeCampusModel.fromJson(Map<String, dynamic> json) {
    return CollegeCampusModel(
      message: json["message"],
      data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class Data {
  College college;
  List<Campus> campuses;

  Data({
    required this.college,
    required this.campuses,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      college: College.fromJson(json["college"]),
      campuses:
          List<Campus>.from(json["campuses"].map((x) => Campus.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "college": college.toJson(),
      "campuses": List<dynamic>.from(campuses.map((x) => x.toJson())),
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
      id: json["id"],
      uid: json["uid"],
      name: json["name"],
      monthlyPayment: json["monthly_payment"],
      deliveryTime: json["delivery_time"],
      schedule: json["schedule"],
      campusEmployee: List<String>.from(json["campus_employee"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "name": name,
      "monthly_payment": monthlyPayment,
      "delivery_time": deliveryTime,
      "schedule": schedule,
      "campus_employee": List<dynamic>.from(campusEmployee.map((x) => x)),
    };
  }
}

class Campus {
  int id;
  String uid;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String tagName;
  String name;
  bool uniform;
  int college;

  Campus({
    required this.id,
    required this.uid,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.tagName,
    required this.name,
    required this.uniform,
    required this.college,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      id: json["id"],
      uid: json["uid"],
      isActive: json["isActive"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      tagName: json["tag_name"],
      name: json["name"],
      uniform: json["uniform"],
      college: json["college"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "isActive": isActive,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "tag_name": tagName,
      "name": name,
      "uniform": uniform,
      "college": college,
    };
  }
}
