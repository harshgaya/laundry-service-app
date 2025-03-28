class UrlConstants {
//stagging
 // static const BASE_URL = "http://13.233.145.19:8000/";
  static const BASE_URL = "http://15.206.178.169:8000/";

  ///authentication
  static const login = '${BASE_URL}college/login/';
  static const employeeUpdate = '${BASE_URL}college/employee-update/';

  ///orders
  static const createCollectionNo = '${BASE_URL}createNewCollection';

  ///campus employee
  static const getCampus = '${BASE_URL}college/get-campus-details';
  static const getLatestCollectionId =
      '${BASE_URL}college/get-latest-collection';
  static const searchTag =
      '${BASE_URL}college/get-non-delivered-student-daysheet-collection/';
  static const getFacultyList = '${BASE_URL}college/get-faculty-list';
  static const uploadDaySheet = '${BASE_URL}college/collection/';
  static const getEmployeeCollectionHistory =
      '${BASE_URL}college/get-employee-collection-list';
  static const uploadRemarksByCampusEmployee = '${BASE_URL}college/collection/';
  static const getCampusDetails = '${BASE_URL}college/campus/';
  static const getActiveCollection =
      '${BASE_URL}college/get-employee-active-collection';
  static const getInActiveCollection =
      '${BASE_URL}college/get-employee-Inactive-collection';

  ///driver
  static const getDriverTodo = '${BASE_URL}college/get-driver-collection';
  static const getVehicles = '${BASE_URL}college/vehicle/';
  static const updateVehicle = '${BASE_URL}college/vehicle';

  ///washing
  static const getToDoList = '${BASE_URL}college/get-collection-task';
  static const updateData = '${BASE_URL}college/collection/';

  ///dry area
  static const getDryArea = '${BASE_URL}college/dryarea/';
  static const updateDryAreaFilled = '${BASE_URL}college/dryarea-update/';
}
