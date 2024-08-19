import 'package:get/get.dart';

class SegController extends GetxController {
  List<DryingTask> dryingTask = <DryingTask>[
    DryingTask(collectionNo: 3, campusName: 'DAV'),
    DryingTask(collectionNo: 22, campusName: 'DPS'),
  ].obs;
  List<SearchTagModel> tags = <SearchTagModel>[
    SearchTagModel(tagNo: 34, no: 12),
    SearchTagModel(tagNo: 14, no: 3),
    SearchTagModel(tagNo: 10, no: 8),
  ].obs;

  RxList<SegRemarks> remarks = <SegRemarks>[
    SegRemarks(remarks: 'Missing', tagNo: 142),
    SegRemarks(remarks: 'Not cleaned', tagNo: 122),
  ].obs;
}

class DryingTask {
  int collectionNo;
  String campusName;
  DryingTask({required this.collectionNo, required this.campusName});
}

class SearchTagModel {
  int tagNo;
  int no;
  int total;
  SearchTagModel({required this.tagNo, required this.no, this.total = 0});
}

class SegRemarks {
  int tagNo;
  String remarks;
  SegRemarks({required this.remarks, required this.tagNo});
}
