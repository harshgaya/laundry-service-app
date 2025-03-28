import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/campus_employee/models/day_sheet_history.dart';
import 'package:laundry_service/modules/segregation/controler/seg_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../widegets/round_button_animate.dart';

class SegEnterTagNo extends StatefulWidget {
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final String selectedRange;
  final bool isUniform;
  final String collectionId;
  final String status;
  final String tagId;
  final bool noTag;
  final String noTagValue;
  const SegEnterTagNo(
      {super.key,
      required this.selectedRange,
      required this.isUniform,
      required this.studentData,
      required this.facultyData,
      required this.collectionId,
      required this.status,
      required this.tagId,
      required this.noTag,
      required this.noTagValue});

  @override
  State<SegEnterTagNo> createState() => _SegEnterTagNoState();
}

class _SegEnterTagNoState extends State<SegEnterTagNo> {
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final segController = Get.put(SegController());
  List<Map<String, String>> warehouseRemark = [];
  List<Map<String, dynamic>> studentDaySheet = [];
  int counter = 0;
  final formKey = GlobalKey<FormState>();

  int minRange = 0;
  int maxRange = 0;

  final TextEditingController tagController = TextEditingController();
  final TextEditingController campusUniformController = TextEditingController();
  final TextEditingController campusRegularController = TextEditingController();
  final TextEditingController warehouseRegularController =
      TextEditingController();
  final TextEditingController warehouseUniformController =
      TextEditingController();
  Rx<SearchTagModel?> searchResult = Rx<SearchTagModel?>(null);
  bool buttonVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final parts = widget.selectedRange.split('-');
    minRange = int.tryParse(parts[0])!;
    maxRange = int.tryParse(parts[1])!;
    segController.getUserId();
    if (widget.noTag) {
      campusRegularController.text = widget.noTagValue;
      buttonVisible = true;
      setState(() {});
    }
    tagController.addListener(() {
      if (tagController.text.length == 3) {
        _secondFocusNode.requestFocus();
      }
    });
  }

  bool isAscending = true;
  int? sortColumnIndex;

  void sortTable(int columnIndex) {
    setState(() {
      if (sortColumnIndex == columnIndex) {
        isAscending = !isAscending;
      } else {
        sortColumnIndex = columnIndex;
        isAscending = true;
      }

      segController.searchTag.sort((a, b) {
        int compare;
        switch (columnIndex) {
          case 0:
            compare = a.tagNo.compareTo(b.tagNo);
            break;
          case 1:
            compare = a.totalCloths.compareTo(b.totalCloths);
            break;
          case 2:
            compare = a.totalUniforms.compareTo(b.totalUniforms);
            break;
          case 3:
            compare = a.totalMissing.compareTo(b.totalMissing);
            break;
          case 4:
            compare = a.totalExtra.compareTo(b.totalExtra);
            break;
          default:
            compare = 0;
        }
        return isAscending ? compare : -compare;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Tag No',
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Range',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.selectedRange,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Text(
                          '   ',
                          style: TextStyle(fontSize: 8),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 60,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(widget.tagId)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Enter Tag No',
                            style: TextStyle(fontSize: 8),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                              focusNode: _firstFocusNode,
                              controller: tagController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (widget.noTag) {
                                  return null;
                                }
                                if (value == null || value.isEmpty) {
                                  return 'Enter tag no';
                                }
                                final number = int.tryParse(value);
                                if (number! < minRange || number > maxRange) {
                                  return 'Range error between $minRange and $maxRange';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Tag No',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    buttonVisible = true;
                                  });
                                  final number = int.tryParse(value);
                                  if (number! < minRange || number > maxRange) {
                                    setState(() {
                                      buttonVisible = false;
                                    });
                                    return;
                                  }

                                  var matchedElement = widget.studentData
                                      .firstWhereOrNull((element) =>
                                          element.tagNumber!.toLowerCase() ==
                                          '${widget.tagId}${value.toLowerCase()}'
                                              .toLowerCase());

                                  if (matchedElement != null) {
                                    print('matched');
                                    campusRegularController.text =
                                        matchedElement.campusRegularCloths
                                            .toString();
                                    campusUniformController.text =
                                        matchedElement.campusUniforms
                                            .toString();
                                    print(
                                        'Data ${matchedElement.campusRegularCloths}');
                                    setState(() {});
                                  } else {
                                    setState(() {
                                      campusUniformController.clear();
                                      campusRegularController.clear();
                                    });
                                  }
                                } else {
                                  setState(() {
                                    buttonVisible = false;
                                  });
                                }
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Campus Regular Cloth',
                            style: TextStyle(fontSize: 8),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            readOnly: true,
                            controller: campusRegularController,
                            decoration: const InputDecoration(
                              hintText: 'Campus Cloth',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (widget.isUniform)
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Campus Uniform',
                              style: TextStyle(fontSize: 8),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              readOnly: true,
                              controller: campusUniformController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Campus Uniform',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Warehouse Cloth',
                            style: TextStyle(fontSize: 8),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            focusNode: _secondFocusNode,
                            controller: warehouseRegularController,
                            onFieldSubmitted: (val) {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                int campusCloth = int.tryParse(
                                        campusRegularController.text) ??
                                    0;
                                int campusUniform = int.tryParse(
                                        campusUniformController.text) ??
                                    0;
                                int campusCount = campusCloth + campusUniform;
                                int warehouseCloth = int.tryParse(
                                        warehouseRegularController.text) ??
                                    0;
                                int warehouseUniform = int.tryParse(
                                        warehouseUniformController.text) ??
                                    0;
                                int warehouseCount =
                                    warehouseCloth + warehouseUniform;
                                int index = segController.searchTag.indexWhere(
                                    (order) =>
                                        order.tagNo.toLowerCase() ==
                                        tagController.text.toLowerCase());
                                if (index != -1) {
                                  final order = segController.searchTag[index];

                                  final tagControllerDialog =
                                      TextEditingController();
                                  tagControllerDialog.text =
                                      tagController.text.toString();
                                  final totalClothController =
                                      TextEditingController();
                                  totalClothController.text =
                                      order.totalCloths.toString();

                                  Utils.showDialogPopUp(
                                      context: context,
                                      function: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            tagControllerDialog,
                                                        readOnly: true,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        decoration:
                                                            const InputDecoration(
                                                                label: Text(
                                                                    'Tag No')),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            totalClothController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        decoration:
                                                            const InputDecoration(
                                                                label: Text(
                                                                    'Warehouse count')),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue),
                                                          onPressed: () {
                                                            if (totalClothController
                                                                .text
                                                                .isNotEmpty) {
                                                              if (campusCount >
                                                                  int.parse(
                                                                      totalClothController
                                                                          .text)) {
                                                                segController
                                                                        .searchTag[
                                                                            index]
                                                                        .totalCloths =
                                                                    int.parse(
                                                                        totalClothController
                                                                            .text);
                                                                segController
                                                                    .searchTag[
                                                                        index]
                                                                    .totalExtra = 0;
                                                                segController
                                                                        .searchTag[
                                                                            index]
                                                                        .totalMissing =
                                                                    campusCount -
                                                                        int.parse(
                                                                            totalClothController.text);
                                                              } else if (campusCount <
                                                                  int.parse(
                                                                      totalClothController
                                                                          .text)) {
                                                                segController
                                                                        .searchTag[
                                                                            index]
                                                                        .totalCloths =
                                                                    int.parse(
                                                                        totalClothController
                                                                            .text);
                                                                segController
                                                                    .searchTag[
                                                                        index]
                                                                    .totalExtra = int.parse(
                                                                        totalClothController
                                                                            .text) -
                                                                    campusCount;
                                                                segController
                                                                    .searchTag[
                                                                        index]
                                                                    .totalMissing = 0;
                                                              } else {
                                                                segController
                                                                        .searchTag[
                                                                            index]
                                                                        .totalCloths =
                                                                    int.parse(
                                                                        totalClothController
                                                                            .text);
                                                                segController
                                                                    .searchTag[
                                                                        index]
                                                                    .totalExtra = 0;
                                                                segController
                                                                    .searchTag[
                                                                        index]
                                                                    .totalMissing = 0;
                                                              }
                                                              segController
                                                                  .searchTag
                                                                  .refresh();
                                                              campusRegularController
                                                                  .clear();
                                                              campusUniformController
                                                                  .clear();
                                                              warehouseUniformController
                                                                  .clear();
                                                              warehouseRegularController
                                                                  .clear();
                                                              tagController
                                                                  .clear();
                                                              tagControllerDialog
                                                                  .clear();
                                                              buttonVisible =
                                                                  false;
                                                              setState(() {});
                                                            }
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Replace',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      title:
                                          'Tag No ${widget.tagId}${tagController.text} is already added? do you want to replace?');
                                } else {
                                  if (campusCount > 0 &&
                                      campusCount > warehouseCount) {
                                    print(
                                        'this 1 $campusCount $warehouseCount');
                                    warehouseRemark.add({
                                      'tag_number':
                                          '${widget.tagId}${tagController.text}',
                                      'remark': 'Cloth missing in warehouse',
                                      'employee': segController.userId.value
                                    });
                                    segController.searchTag.add(SearchTagModel(
                                      tagNo: tagController.text,
                                      totalUniforms: campusUniform,
                                      totalCloths: campusCloth,
                                      totalExtra: 0,
                                      totalMissing:
                                          campusCount - warehouseCount,
                                    ));
                                  } else if (campusCount > 0 &&
                                      campusCount < warehouseCount) {
                                    print('this 2');
                                    warehouseRemark.add({
                                      'tag_number':
                                          '${widget.tagId}${tagController.text}',
                                      'remark': 'Cloth extra in warehouse',
                                      'employee': segController.userId.value
                                    });
                                    segController.searchTag.add(SearchTagModel(
                                      tagNo: tagController.text,
                                      totalUniforms: campusUniform,
                                      totalCloths: campusCloth,
                                      totalExtra: warehouseCount - campusCount,
                                      totalMissing: 0,
                                    ));
                                  } else if (campusCount == 0 &&
                                      warehouseCount > 0) {
                                    print('this 3');
                                    warehouseRemark.add({
                                      'tag_number':
                                          '${widget.tagId}${tagController.text}',
                                      'remark':
                                          'No cloth in campus but present in warehouse',
                                      'employee': segController.userId.value
                                    });
                                    segController.searchTag.add(SearchTagModel(
                                      tagNo: tagController.text,
                                      totalUniforms: campusUniform,
                                      totalCloths: campusCloth,
                                      totalExtra: warehouseCount - campusCount,
                                      totalMissing:
                                          warehouseCount - campusCount,
                                    ));
                                  } else if (campusCount > 0 &&
                                      warehouseCount == 0) {
                                    print('this 4');
                                    warehouseRemark.add({
                                      'tag_number':
                                          '${widget.tagId}${tagController.text}',
                                      'remark':
                                          'Cloth in campus but not present in warehouse',
                                      'employee': segController.userId.value
                                    });
                                    segController.searchTag.add(SearchTagModel(
                                      tagNo: tagController.text,
                                      totalUniforms: campusUniform,
                                      totalCloths: campusCloth,
                                      totalExtra: 0,
                                      totalMissing:
                                          warehouseCount - campusCount,
                                    ));
                                  } else if (campusCount == 0 &&
                                      warehouseCount == 0) {
                                    print('this 5');
                                    warehouseRemark.add({
                                      'tag_number':
                                          '${widget.tagId}${tagController.text}',
                                      'remark':
                                          'No cloth in both campus and warehouse',
                                      'employee': segController.userId.value
                                    });
                                    segController.searchTag.add(SearchTagModel(
                                      tagNo: tagController.text,
                                      totalUniforms: campusUniform,
                                      totalCloths: campusCloth,
                                      totalExtra: 0,
                                      totalMissing: warehouseCount,
                                    ));
                                  } else {
                                    final item = widget.studentData
                                        .firstWhereOrNull((element) =>
                                            element.tagNumber ==
                                            '${widget.tagId}${tagController.text}');
                                    print('item ${item?.tagNumber}');
                                    if (item != null) {
                                      studentDaySheet.add({
                                        'uid': item.uid,
                                        'tag_number': item.tagNumber,
                                        'campus_regular_cloths':
                                            item.campusRegularCloths,
                                        'campus_regular_uniforms':
                                            item.campusUniforms,
                                        'ware_house_regular_cloths':
                                            warehouseCloth,
                                        'ware_house_uniform': warehouseUniform,
                                        'delivered': false,
                                      });
                                    }

                                    print('this 6');
                                    segController.searchTag.add(SearchTagModel(
                                      tagNo: tagController.text,
                                      totalUniforms: campusUniform,
                                      totalCloths: campusCloth,
                                      totalExtra: 0,
                                      totalMissing: 0,
                                    ));
                                  }
                                  campusRegularController.clear();
                                  campusUniformController.clear();
                                  warehouseUniformController.clear();
                                  warehouseRegularController.clear();
                                  tagController.clear();
                                  _firstFocusNode.requestFocus();
                                  setState(() {
                                    buttonVisible = false;
                                  });
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter warehouse cloth count';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Warehouse cloth',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (widget.isUniform)
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Warehouse Uniform',
                              style: TextStyle(fontSize: 8),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: warehouseUniformController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter warehouse uniform count';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Warehouse Uniform',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: buttonVisible,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          int campusCloth =
                              int.tryParse(campusRegularController.text) ?? 0;
                          int campusUniform =
                              int.tryParse(campusUniformController.text) ?? 0;
                          int campusCount = campusCloth + campusUniform;
                          int warehouseCloth =
                              int.tryParse(warehouseRegularController.text) ??
                                  0;
                          int warehouseUniform =
                              int.tryParse(warehouseUniformController.text) ??
                                  0;
                          int warehouseCount =
                              warehouseCloth + warehouseUniform;
                          int index = segController.searchTag.indexWhere(
                              (order) =>
                                  order.tagNo.toLowerCase() ==
                                  tagController.text.toLowerCase());
                          if (index != -1) {
                            final order = segController.searchTag[index];

                            final tagControllerDialog = TextEditingController();
                            tagControllerDialog.text =
                                tagController.text.toString();
                            final totalClothController =
                                TextEditingController();
                            totalClothController.text =
                                order.totalCloths.toString();

                            Utils.showDialogPopUp(
                                context: context,
                                function: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  controller:
                                                      tagControllerDialog,
                                                  readOnly: true,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          label:
                                                              Text('Tag No')),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      totalClothController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          label: Text(
                                                              'Warehouse count')),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.blue),
                                                    onPressed: () {
                                                      if (totalClothController
                                                          .text.isNotEmpty) {
                                                        if (campusCount >
                                                            int.parse(
                                                                totalClothController
                                                                    .text)) {
                                                          segController
                                                                  .searchTag[index]
                                                                  .totalCloths =
                                                              int.parse(
                                                                  totalClothController
                                                                      .text);
                                                          segController
                                                              .searchTag[index]
                                                              .totalExtra = 0;
                                                          segController
                                                                  .searchTag[index]
                                                                  .totalMissing =
                                                              campusCount -
                                                                  int.parse(
                                                                      totalClothController
                                                                          .text);
                                                        } else if (campusCount <
                                                            int.parse(
                                                                totalClothController
                                                                    .text)) {
                                                          segController
                                                                  .searchTag[index]
                                                                  .totalCloths =
                                                              int.parse(
                                                                  totalClothController
                                                                      .text);
                                                          segController
                                                              .searchTag[index]
                                                              .totalExtra = int.parse(
                                                                  totalClothController
                                                                      .text) -
                                                              campusCount;
                                                          segController
                                                              .searchTag[index]
                                                              .totalMissing = 0;
                                                        } else {
                                                          segController
                                                                  .searchTag[index]
                                                                  .totalCloths =
                                                              int.parse(
                                                                  totalClothController
                                                                      .text);
                                                          segController
                                                              .searchTag[index]
                                                              .totalExtra = 0;
                                                          segController
                                                              .searchTag[index]
                                                              .totalMissing = 0;
                                                        }
                                                        segController.searchTag
                                                            .refresh();
                                                        campusRegularController
                                                            .clear();
                                                        campusUniformController
                                                            .clear();
                                                        warehouseUniformController
                                                            .clear();
                                                        warehouseRegularController
                                                            .clear();
                                                        tagController.clear();
                                                        tagControllerDialog
                                                            .clear();
                                                        buttonVisible = false;
                                                        setState(() {});
                                                      }
                                                      Get.back();
                                                    },
                                                    child: const Text(
                                                      'Replace',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                title:
                                    'Tag No ${widget.tagId}${tagController.text} is already added? do you want to replace?');
                          } else {
                            if (campusCount > 0 &&
                                campusCount > warehouseCount) {
                              print('this 1 $campusCount $warehouseCount');
                              warehouseRemark.add({
                                'tag_number':
                                    '${widget.tagId}${tagController.text}',
                                'remark': 'Cloth missing in warehouse',
                                'employee': segController.userId.value
                              });
                              segController.searchTag.add(SearchTagModel(
                                tagNo: tagController.text,
                                totalUniforms: campusUniform,
                                totalCloths: campusCloth,
                                totalExtra: 0,
                                totalMissing: campusCount - warehouseCount,
                              ));
                            } else if (campusCount > 0 &&
                                campusCount < warehouseCount) {
                              print('this 2');
                              warehouseRemark.add({
                                'tag_number':
                                    '${widget.tagId}${tagController.text}',
                                'remark': 'Cloth extra in warehouse',
                                'employee': segController.userId.value
                              });
                              segController.searchTag.add(SearchTagModel(
                                tagNo: tagController.text,
                                totalUniforms: campusUniform,
                                totalCloths: campusCloth,
                                totalExtra: warehouseCount - campusCount,
                                totalMissing: 0,
                              ));
                            } else if (campusCount == 0 && warehouseCount > 0) {
                              print('this 3');
                              warehouseRemark.add({
                                'tag_number':
                                    '${widget.tagId}${tagController.text}',
                                'remark':
                                    'No cloth in campus but present in warehouse',
                                'employee': segController.userId.value
                              });
                              segController.searchTag.add(SearchTagModel(
                                tagNo: tagController.text,
                                totalUniforms: campusUniform,
                                totalCloths: campusCloth,
                                totalExtra: warehouseCount - campusCount,
                                totalMissing: warehouseCount - campusCount,
                              ));
                            } else if (campusCount > 0 && warehouseCount == 0) {
                              print('this 4');
                              warehouseRemark.add({
                                'tag_number':
                                    '${widget.tagId}${tagController.text}',
                                'remark':
                                    'Cloth in campus but not present in warehouse',
                                'employee': segController.userId.value
                              });
                              segController.searchTag.add(SearchTagModel(
                                tagNo: tagController.text,
                                totalUniforms: campusUniform,
                                totalCloths: campusCloth,
                                totalExtra: 0,
                                totalMissing: warehouseCount - campusCount,
                              ));
                            } else if (campusCount == 0 &&
                                warehouseCount == 0) {
                              print('this 5');
                              warehouseRemark.add({
                                'tag_number':
                                    '${widget.tagId}${tagController.text}',
                                'remark':
                                    'No cloth in both campus and warehouse',
                                'employee': segController.userId.value
                              });
                              segController.searchTag.add(SearchTagModel(
                                tagNo: tagController.text,
                                totalUniforms: campusUniform,
                                totalCloths: campusCloth,
                                totalExtra: 0,
                                totalMissing: warehouseCount,
                              ));
                            } else {
                              final item = widget.studentData.firstWhereOrNull(
                                  (element) =>
                                      element.tagNumber ==
                                      '${widget.tagId}${tagController.text}');
                              print('item ${item?.tagNumber}');
                              if (item != null) {
                                studentDaySheet.add({
                                  'uid': item.uid,
                                  'tag_number': item.tagNumber,
                                  'campus_regular_cloths':
                                      item.campusRegularCloths,
                                  'campus_regular_uniforms':
                                      item.campusUniforms,
                                  'ware_house_regular_cloths': warehouseCloth,
                                  'ware_house_uniform': warehouseUniform,
                                  'delivered': false,
                                });
                              }

                              print('this 6');
                              segController.searchTag.add(SearchTagModel(
                                tagNo: tagController.text,
                                totalUniforms: campusUniform,
                                totalCloths: campusCloth,
                                totalExtra: 0,
                                totalMissing: 0,
                              ));
                            }
                            campusRegularController.clear();
                            campusUniformController.clear();
                            warehouseUniformController.clear();
                            warehouseRegularController.clear();
                            tagController.clear();
                            _firstFocusNode.requestFocus();
                            setState(() {
                              buttonVisible = false;
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => SingleChildScrollView(
                      child: Table(
                        border: const TableBorder(
                            horizontalInside:
                                BorderSide(color: Colors.black, width: 0.2)),
                        children: [
                          // Table header
                          TableRow(
                            children: [
                              TableCell(
                                child: InkWell(
                                  onTap: () => sortTable(0),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'TAG NO.',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: InkWell(
                                  onTap: () => sortTable(1),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'CLOTHS',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.isUniform)
                                TableCell(
                                  child: InkWell(
                                    onTap: () => sortTable(2),
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          'UNIFORMS',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              TableCell(
                                child: InkWell(
                                  onTap: () => sortTable(3),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'MISSING',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: InkWell(
                                  onTap: () => sortTable(4),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'EXTRA',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Table rows from the orders list
                          ...segController.searchTag
                              .asMap()
                              .entries
                              .map((order) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.tagNo.toString()}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.totalCloths}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.isUniform)
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '${order.value.totalUniforms}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.totalMissing}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.totalExtra}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Obx(() => segController.uploadingData.value
          ? LoadingAnimationWidget.discreteCircle(
              size: 40,
              color: Colors.blue,
              secondRingColor: const Color(0xFF1A1A3F),
              thirdRingColor: const Color(0xFFEA3799))
          : RoundButtonAnimate(
              buttonName: 'Done',
              onClick: () {
                Utils.showDialogPopUp(
                    context: context,
                    function: () async {
                      // Get.offAll(() => UserState());

                      if (widget.noTag) {
                        await segController.updateNoTagRemark(
                          collectionId: widget.collectionId,
                          context: context,
                          remark: [
                            {
                              'tag_number': 'No Tag',
                              'remark':
                                  'No Tag clothes in warehouse-${widget.noTagValue} and in segregation ${warehouseRegularController.text}',
                              'employee': segController.userId.value
                            }
                          ],
                        );
                      } else {
                        await segController.updateStatus(
                            collectionId: widget.collectionId,
                            status: widget.status,
                            context: context,
                            remark: warehouseRemark,
                            studentData: studentDaySheet,
                            range: widget.selectedRange);
                      }
                    },
                    title: 'Finish adding tags?');
              },
              image: const Icon(
                Icons.done,
                color: Colors.white,
              ))),
    );
  }
}
