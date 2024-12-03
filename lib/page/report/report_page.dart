import 'package:ams_express/component/custom_dropdown2.dart';
import 'package:ams_express/component/label.dart';
import 'package:ams_express/extension/color_extension.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/model/report/viewReportDropdownPlanModel.dart';
import 'package:ams_express/model/report/viewReportListDataModel.dart';
import 'package:ams_express/page/report/card_custom_report.dart';
import 'package:ams_express/routes.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:ams_express/services/database/report_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../services/database/export_db.dart';

class ReportPage extends StatefulWidget {
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<ViewReportDropdownPlanModel> dropdownPlans = [];
  List<ViewReportListDataModel> dataList = [];
  List<ViewReportListDataModel> _tempItemList = [];
  String valueselected = '';
  String? previousValue;
  TextEditingController uncheck = TextEditingController(),
      checked = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int currentPage = 0;
  int pageSize = 50;
  bool isRefreshing = false;
  String currentStatus = '';

  @override
  void initState() {
    ReportDB().getListDropdown().then((value) {
      dropdownPlans = value;

      setState(() {});
    });

    _scrollController.addListener(_scrollListener);
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.75 &&
        !isLoading &&
        !isRefreshing) {
      if (valueselected.isNotEmpty) {
        await _fetchListData(valueselected, false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _viewItem(String value) async {
    dataList.clear();
    List<ViewReportListDataModel> newItems = [];
    currentPage = 0;
    pageSize = 50;
    currentStatus = value;

    if (value == StatusCheck.status_checked) {
      newItems = await ReportDB().getAssetsByPlanOnlyChecked(
        valueselected,
        limit: pageSize,
        offset: currentPage * pageSize,
      );
    } else if (value == StatusCheck.status_uncheck) {
      newItems = await ReportDB().getAssetsByPlanOnlyUnChecked(
        valueselected,
        limit: pageSize,
        offset: currentPage * pageSize,
      );
    }

    setState(() {
      dataList.addAll(newItems);
      _tempItemList = dataList;
      currentPage++;
      isRefreshing = false;
    });
  }

  Future _fetchListData(String value, bool isBack) async {
    if (isLoading || isRefreshing) return; // Prevent overlapping calls

    setState(() {
      isLoading = true;
    });

    List<ViewReportListDataModel> newItems = [];
    if (currentStatus == StatusCheck.status_checked) {
      newItems = await ReportDB().getAssetsByPlanOnlyChecked(
        value,
        limit: pageSize,
        offset: currentPage * pageSize,
      );
    } else if (currentStatus == StatusCheck.status_uncheck) {
      newItems = await ReportDB().getAssetsByPlanOnlyUnChecked(
        value,
        limit: pageSize,
        offset: currentPage * pageSize,
      );
    } else {
      newItems = await ReportDB().getAssetsByPlan(
        value,
        limit: pageSize,
        offset: currentPage * pageSize,
      );
    }
    if (isBack) {
      currentPage = 0;
      pageSize = 50;
      dataList.clear();
      newItems = await ReportDB().getAssetsByPlan(
        value,
        limit: pageSize,
        offset: currentPage * pageSize,
      );
    }
    Future.delayed(Duration(seconds: 2), () {});

    setState(() {
      dataList.addAll(newItems);
      _tempItemList = dataList;
      currentPage++;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green.shade500,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Label(
            appLocalization.localizations.report_title,
            fontSize: 18,
          ),
        ),
        actions: [
          valueselected.isNotEmpty
              ? IconButton(
                  onPressed: () async {
                    await ExportDB().ExportAllAssetByPlan(valueselected);
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.outbox_sharp,
                      size: 45,
                    ),
                  ))
              : SizedBox.fromSize()
        ],
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              _listViewData(),

              //CardDropdown
              _buildDropdown(onChanged: (value) async {
                currentPage = 0;
                pageSize = 50;
                currentStatus = '';

                valueselected = value;
                uncheck.text = dropdownPlans
                    .where((element) => element.plan == valueselected)
                    .first
                    .uncheck
                    .toString();
                checked.text = dropdownPlans
                    .where((element) => element.plan == valueselected)
                    .first
                    .check
                    .toString();

                dataList.clear();
                await _fetchListData(valueselected, false);
                setState(() {});
              }),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listViewData() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Column(
              children: [
                dataList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            controller: _scrollController,
                            itemCount: dataList.length + (isLoading ? 1 : 0),
                            itemBuilder: ((context, index) {
                              if (index == dataList.length) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return CardCustomReport(
                                dataList: dataList[index],
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    Routes.editPage,
                                    arguments: {
                                      "plan": valueselected,
                                      "asset": dataList[index].asset
                                    },
                                  ).then((v) async {
                                    isLoading = false;
                                    setState(() {});
                                    await _fetchListData(valueselected, true);
                                  });
                                },
                              );
                            })))
                    : const Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          ),
                        ),
                      )
              ],
            ),
          )),
    );
  }

  Widget _buildDropdown({dynamic Function(dynamic)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green.shade500,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      padding: EdgeInsets.all(8),
      child: Wrap(
        children: [
          Card(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 8),
              child: Column(
                children: [
                  dropdownPlans.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: SizedBox(
                                  child: CustomDropdownButton2(
                                    hintText: appLocalization
                                        .localizations.report_dropdown,
                                    items: dropdownPlans.map((item) {
                                      return DropdownMenuItem<dynamic>(
                                        value: item.plan,
                                        child: Text(
                                          "${item.plan}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: onChanged,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.fromSize(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Label(
                            "${appLocalization.localizations.report_txt_uncheck} : ",
                            color: AppColors.contentColorBlue,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: TextStyle(fontSize: 26, color: Colors.black),
                            controller: uncheck,
                            readOnly: true,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(4),
                                filled: true,
                                fillColor: Colors.transparent),
                          )),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _viewItem(StatusCheck.status_uncheck),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppColors.contentColorBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Center(
                                child: Label(appLocalization
                                    .localizations.report_btn_view_uncheck)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Label(
                            "${appLocalization.localizations.report_txt_check} : ",
                            color: AppColors.contentColorBlue,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: checked,
                            style: TextStyle(fontSize: 26),
                            readOnly: true,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(4),
                                filled: true,
                                fillColor: Colors.transparent),
                          )),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _viewItem(StatusCheck.status_checked),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppColors.contentColorBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Center(
                                child: Label(appLocalization
                                    .localizations.report_btn_view_uncheck)),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
