class VehicleData {
  //int id;

  String uid;
  String name;
  // String lastDriver;
  // bool isActive;
  // DateTime createdAt;
  // DateTime updatedAt;

  // String make;
  // String? numberPlate;
  // int odoMeter;
  // String odoMeterImage;
  // String? spareTyre;
  // String? frontSide;
  // String? leftSide;
  // String? rightSide;
  // String? backSide;
  // int fuelLevel;
  // String? expenses;

  VehicleData({
    // required this.id,
    required this.uid,
    required this.name,
    //  required this.lastDriver,

    // required this.isActive,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.name,
    // required this.make,
    // this.numberPlate,
    // required this.odoMeter,
    // required this.odoMeterImage,
    // this.spareTyre,
    // this.frontSide,
    // this.leftSide,
    // this.rightSide,
    // this.backSide,
    // required this.fuelLevel,
    // this.expenses,
  });

  // Factory method to create an instance from JSON
  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      // id: json['id'],
      name: json['name'],
      // lastDriver: json['last_driver'],
      uid: json['uid'],
      // isActive: json['isActive'],
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),

      // make: json['make'],
      // numberPlate: json['number_plate'],
      // odoMeter: json['odo_meter'],
      // odoMeterImage: json['odo_meter_image'],
      // spareTyre: json['spare_tyre'],
      // frontSide: json['front_side'],
      // leftSide: json['left_side'],
      // rightSide: json['right_side'],
      // backSide: json['back_side'],
      // fuelLevel: json['fuel_level'],
      // expenses: json['expenses'],
    );
  }
}
