import 'package:ams_express/routes.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../main.dart';
import '../../model/importModel/view_Import_Model.dart';

class ImportPage extends StatefulWidget {
  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  List<ViewImportModel> itemPlan = [];
  bool _isLoading = false;

  // Modern Blue Color Palette
  final Color primaryColor = Color(0xFF2196F3);
  final Color secondaryColor = Color(0xFF64B5F6);
  final Color accentColor = Color(0xFF00BCD4);
  final Color cardColor = Colors.white;

  @override
  void initState() {
    // itemPlan = [
    //   ViewImportModel(
    //       plan: "Sample Plan", createdDate: "2024-01-01", qtyAssets: "10"),
    //   ViewImportModel(
    //       plan: "Test Plan", createdDate: "2024-02-15", qtyAssets: "25"),
    //   ViewImportModel(
    //       plan: "Demo Plan1", createdDate: "2024-03-10", qtyAssets: "15"),
    //   ViewImportModel(
    //       plan: "Demo Plan2", createdDate: "2024-04-05", qtyAssets: "30"),
    //   ViewImportModel(
    //       plan: "Demo Plan3", createdDate: "2024-05-20", qtyAssets: "20"),
    // ];
    ImportDB().selectPlan().then((value) {
      setState(() {
        itemPlan = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isLoading ? false : true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Import Page',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return ImportDB().selectPlan().then((value) {
              setState(() {
                itemPlan = value;
              });
            });
          },
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: primaryColor.withOpacity(0.2), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.red.shade400),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            elevation: WidgetStatePropertyAll(0),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.delete_sweep_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: !_isLoading
                              ? () async {
                                  _showDialogConfirmDelete();
                                }
                              : null,
                          label: Text(
                              appLocalization.localizations.import_btn_clearAll,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ))),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(primaryColor),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            elevation: WidgetStatePropertyAll(2),
                            shadowColor: WidgetStatePropertyAll(
                                primaryColor.withOpacity(0.3)),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.file_upload_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: !_isLoading
                              ? () async {
                                  _isLoading = true;
                                  setState(() {});
                                  await ImportDB().importFileExcel().then(
                                      (event) => ImportDB().selectPlan().then(
                                          (value) => setState(
                                              () => itemPlan = value)));
                                  _isLoading = false;
                                  setState(() {});
                                }
                              : null,
                          label: Text(
                              appLocalization.localizations.import_btn_import,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ))),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                      itemCount: itemPlan.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: BehindMotion(),
                            children: [
                              !_isLoading
                                  ? SlidableAction(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      borderRadius: BorderRadius.circular(16),
                                      spacing: 2,
                                      onPressed: (BuildContext context) {
                                        ImportDB()
                                            .deleteData(itemPlan[index].plan!)
                                            .then((e) => ImportDB()
                                                    .selectPlan()
                                                    .then((value) {
                                                  setState(() {
                                                    itemPlan = value;
                                                  });
                                                }));
                                      },
                                      backgroundColor: Colors.red.shade400,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete_rounded,
                                      label: "Delete",
                                    )
                                  : Container(),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, Routes.view_detail_import,
                                  arguments: itemPlan[index].plan),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: primaryColor.withOpacity(0.15),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.08),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primaryColor,
                                              secondaryColor
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              topRight: Radius.circular(15)),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.visibility_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "View",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: primaryColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  Icons.folder_rounded,
                                                  color: primaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  "${itemPlan[index].plan}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: secondaryColor
                                                  .withOpacity(0.08),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .calendar_today_rounded,
                                                      size: 14,
                                                      color: primaryColor
                                                          .withOpacity(0.7),
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "${itemPlan[index].createdDate}",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors
                                                            .grey.shade700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        accentColor,
                                                        secondaryColor
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .inventory_2_rounded,
                                                        size: 14,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        "${itemPlan[index].qtyAssets}",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialogConfirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appLocalization.localizations.import_alert_title),
          content: Text(appLocalization.localizations.import_alert_content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(appLocalization.localizations.import_btn_cancel),
            ),
            TextButton(
              onPressed: () async {
                EasyLoading.show(
                    status: 'Loading ...', maskType: EasyLoadingMaskType.black);
                await ImportDB()
                    .deleteData("")
                    .then((value) => ImportDB().selectPlan().then((value) {
                          setState(() {
                            itemPlan = value;
                          });
                        }));

                EasyLoading.dismiss();

                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text(appLocalization.localizations.import_btn_delete),
            ),
          ],
        );
      },
    );
  }
}
