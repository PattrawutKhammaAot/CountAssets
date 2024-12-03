import 'package:ams_express/component/custom_dropdown2.dart';
import 'package:ams_express/component/custom_range_pointer.dart';
import 'package:ams_express/component/custombutton.dart';
import 'package:ams_express/extension/color_extension.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/model/dashboard/view_dashboard_model.dart';
import 'package:ams_express/services/database/export_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

class ExportPage extends StatefulWidget {
  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final List<String> itemDropdown = [];

  List<ViewDashboardModel> item = [];
  double height = 125;

  @override
  void initState() {
    ExportDB().getPlan().then((value) {
      setState(() {
        itemDropdown.addAll(value);
      });
    });
    super.initState();
  }

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.contentColorBlue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(appLocalization.localizations.export_title,
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: AppColors.contentColorBlue,
              child: Column(
                children: [
                  CustomDropdownButton2(
                    hintText: appLocalization.localizations.export_downdown,
                    items: itemDropdown
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) async {
                      selectedValue = value.toString();
                      item = await ExportDB().getDetailFromPlan(value);
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            selectedValue != null
                ? CustomButton(
                    isUseIcon: false,
                    text: appLocalization.localizations.export_btn_export,
                    color: AppColors.contentColorOrange,
                    onPressed: () async {
                      EasyLoading.show(
                          status: appLocalization.localizations.loading,
                          maskType: EasyLoadingMaskType.black);
                      await ExportDB().createFolderInDocument();
                      await ExportDB().ExportAllAssetByPlan(selectedValue!);
                    },
                  )
                : SizedBox.fromSize(),

            item.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 60),
                    shrinkWrap: true,
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      "${appLocalization.localizations.ov_plan} : ${item[index].plan}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: height,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomRangePoint(
                                                  text:
                                                      "${appLocalization.localizations.ov_plan}",
                                                  valueRangePointer:
                                                      item[index].sum_asset,
                                                  colorText: Colors.blue,
                                                  color: Colors.blue,
                                                  allItem:
                                                      item[index].sum_asset,
                                                  icon: Icon(
                                                    Icons.assignment,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: height,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomRangePoint(
                                                  text:
                                                      "${appLocalization.localizations.ov_images}",
                                                  valueRangePointer:
                                                      item[index].image,
                                                  colorText: Colors.blue,
                                                  color: Colors.blue,
                                                  allItem:
                                                      item[index].sum_asset,
                                                  icon: Icon(
                                                    Icons.image,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: height,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomRangePoint(
                                                  text:
                                                      "${appLocalization.localizations.ov_counted}",
                                                  valueRangePointer:
                                                      item[index].check,
                                                  colorText: Colors.blue,
                                                  color: Colors.blue,
                                                  allItem:
                                                      item[index].sum_asset,
                                                  icon: Icon(
                                                    Icons.check,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: height,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomRangePoint(
                                                  text:
                                                      "${appLocalization.localizations.ov_not_counted}",
                                                  colorText: Colors.blue,
                                                  valueRangePointer:
                                                      item[index].uncheck,
                                                  color: Colors.blue,
                                                  allItem:
                                                      item[index].sum_asset,
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox.fromSize()
            // Container(
            //   color: AppColors.contentColorBlack,
            //   child: Column(
            //     children: [Text("data")],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
