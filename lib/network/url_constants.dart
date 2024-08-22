class UrlConstants {
//stagging
  static const BASE_URL = "http://13.233.145.19:8000/";

  ///authentication
  static const login = '${BASE_URL}college/login/';

  ///orders
  static const createCollectionNo = '${BASE_URL}createNewCollection';

  ///campus employee
  static const getCampus = '${BASE_URL}/college/get-campus-details';
  static const getLatestCollectionId =
      '${BASE_URL}/college/get-latest-collection';
  static const searchTag =
      '${BASE_URL}college/get-non-delivered-student-daysheet-collection/';
  static const getFacultyList = '${BASE_URL}college/get-faculty-list';
  static const uploadDaySheet = '${BASE_URL}college/collection/';
}
