import 'package:ams_express/component/custom_dropdown2.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/model/report/viewReportDropdownPlanModel.dart';
import 'package:ams_express/model/report/viewReportListDataModel.dart';
import 'package:ams_express/page/report/card_custom_report.dart';
import 'package:ams_express/routes.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:ams_express/services/database/report_db.dart';
import 'package:flutter/material.dart';

import '../../services/database/export_db.dart';

class ReportPage extends StatefulWidget {
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  List<ViewReportDropdownPlanModel> dropdownPlans = [];
  List<ViewReportListDataModel> dataList = [];
  String valueselected = '';
  String? previousValue;
  TextEditingController uncheck = TextEditingController(),
      checked = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int currentPage = 0;
  int pageSize = 50;
  bool isRefreshing = false;
  String valueViewButtonStatus = '';

  // Modern Blue Color Palette
  final Color primaryColor = Color(0xFF2196F3);
  final Color secondaryColor = Color(0xFF64B5F6);
  final Color accentColor = Color(0xFF00BCD4);
  final Color cardColor = Colors.white;
  final Color greenColor = Color(0xFF4CAF50);
  final Color redColor = Color(0xFFEF5350);

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
    valueViewButtonStatus = value;

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
    if (valueViewButtonStatus == StatusCheck.status_checked) {
      newItems = await ReportDB().getAssetsByPlanOnlyChecked(
        value,
        limit: pageSize,
        offset: currentPage * pageSize,
      );
    } else if (valueViewButtonStatus == StatusCheck.status_uncheck) {
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
      currentPage++;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          appLocalization.localizations.report_title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          valueselected.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await ExportDB().ExportAllAssetByPlan(valueselected);
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Export',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
      body: Column(
        children: [
          _buildDropdown(onChanged: (value) async {
            currentPage = 0;
            pageSize = 50;
            valueViewButtonStatus = '';

            valueselected = value;
            uncheck.text = dropdownPlans
                .where((element) => element.plan == valueselected)
                .first
                .sum_Uncheck
                .toString();
            checked.text = dropdownPlans
                .where((element) => element.plan == valueselected)
                .first
                .sum_Check
                .toString();

            dataList.clear();
            await _fetchListData(valueselected, false);
            setState(() {});
          }),
          Expanded(child: _listViewData()),
        ],
      ),
    );
  }

  Widget _listViewData() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade50, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
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
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        primaryColor),
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'กำลังโหลดข้อมูล...',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    }),
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.hourglass_empty_rounded,
                            size: 64,
                            color: primaryColor.withOpacity(0.5),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'กำลังโหลดข้อมูล',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildDropdown({dynamic Function(dynamic)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ]),
      padding: EdgeInsets.all(16),
      child: Wrap(
        children: [
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  dropdownPlans.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.folder_open_rounded,
                                color: primaryColor,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: CustomDropdownButton2(
                                  hintText: appLocalization
                                      .localizations.report_dropdown,
                                  items: dropdownPlans.map((item) {
                                    return DropdownMenuItem<dynamic>(
                                      value: item.plan,
                                      child: Text(
                                        "${item.plan}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: onChanged,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.fromSize(),
                  // Unchecked Section
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.pending_actions_rounded,
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalization
                                    .localizations.report_txt_uncheck,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextFormField(
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                controller: uncheck,
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _viewItem(StatusCheck.status_uncheck),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor, secondaryColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.visibility_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    appLocalization
                                        .localizations.report_btn_view_uncheck,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Checked Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: greenColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: greenColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: greenColor,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalization.localizations.report_txt_check,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextFormField(
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: greenColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                controller: checked,
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _viewItem(StatusCheck.status_checked),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [greenColor, Color(0xFF81C784)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: greenColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.visibility_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    appLocalization
                                        .localizations.report_btn_view_uncheck,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
