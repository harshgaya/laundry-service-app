import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/pages/view_remarks_from_warehouse.dart';
import 'package:laundry_service/modules/segregation/controler/seg_controller.dart';

import '../../campus_employee/widgets/round_button_custom.dart';
import '../../widegets/round_button_animate.dart';

class SegEnterTagNo extends StatefulWidget {
  const SegEnterTagNo({super.key});

  @override
  State<SegEnterTagNo> createState() => _SegEnterTagNoState();
}

class _SegEnterTagNoState extends State<SegEnterTagNo> {
  final segController = Get.put(SegController());
  final List<SearchTagModel> tags = <SearchTagModel>[
    SearchTagModel(tagNo: 34, no: 12, total: 0),
    SearchTagModel(tagNo: 14, no: 3, total: 0),
    SearchTagModel(tagNo: 10, no: 8, total: 0),
  ].obs;
  int counter = 0;
  final formKey = GlobalKey<FormState>();

  void _increment() {
    setState(() {
      counter++;
    });
  }

  void _decrement() {
    if (counter > 0) {
      setState(() {
        counter--;
      });
    }
  }

  final TextEditingController searchController = TextEditingController();
  Rx<SearchTagModel?> searchResult = Rx<SearchTagModel?>(null);
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
                      'Campus Name',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Sri Chaitnaya',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Collection No',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '1',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assigned To Zone',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '5',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter tag no';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter Tag No',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            int? searchTagNo = int.tryParse(value);
                            if (searchTagNo != null) {
                              searchResult.value = tags.firstWhereOrNull(
                                  (tag) => tag.tagNo == searchTagNo);
                            } else {
                              searchResult.value = null;
                            }
                          } else {
                            searchResult.value = null;
                          }
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Obx(() {
                      if (searchResult.value != null) {
                        return Text('Total Cloths: ${searchResult.value!.no}',
                            style: const TextStyle(fontSize: 12));
                      } else {
                        return const Text('Not found',
                            style: TextStyle(fontSize: 12));
                      }
                    }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      elevation: 1,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onPressed: _decrement,
                          ),
                          Text(
                            counter.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: _increment,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (counter > 0 && searchResult.value != null) {
                            SearchTagModel? data = tags.firstWhere((element) =>
                                element.tagNo ==
                                int.parse(searchController.text));
                            data.total = counter;
                            searchController.text = '';
                            counter = 0;
                            setState(() {});
                          }
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        child: Table(
                          border: const TableBorder(
                              horizontalInside:
                                  BorderSide(color: Colors.black, width: 0.2)),
                          children: [
                            // Table header
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'TAG NO.',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Campus Count'.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Your Count'.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Table rows from the orders list
                            ...tags.asMap().entries.map((order) {
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          order.value.tagNo.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${order.value.no}',
                                          style: TextStyle(
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
                                          '${order.value.total}',
                                          style: TextStyle(
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
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RoundButtonAnimate(
                      buttonName: 'Done',
                      onClick: () {
                        Utils.showDialogPopUp(
                            context: context,
                            function: () {
                              Get.offAll(() => UserState());
                            },
                            title: 'Done?');
                      },
                      image: Icon(
                        Icons.done,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
