import 'package:ams_express/extension/color_extension.dart';
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
  @override
  void initState() {
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
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, // Change this to your desired color
            ),
            title: Text(
              'Import Page',
              style: TextStyle(color: AppColors.mainTextColor1),
            ),
            backgroundColor: Colors.green.shade500),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.red)),
                          onPressed: !_isLoading
                              ? () async {
                                  _showDialogConfirmDelete();
                                }
                              : null,
                          child: Text(
                              appLocalization.localizations.import_btn_clearAll,
                              style: TextStyle(color: Colors.white))),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColors.contentColorBlue)),
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
                          child: Text(
                              appLocalization.localizations.import_btn_import,
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),
              Expanded(
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
                                    borderRadius: BorderRadius.circular(12),
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
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: "Delete",
                                  )
                                : Container(),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.view_detail_import,
                                arguments: itemPlan[index].plan),
                            child: Card(
                              shadowColor: AppColors.itemsBackground,
                              elevation: 8,
                              color: AppColors.mainTextColor1,
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.contentColorBlue,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(8)),
                                      ),
                                      height: 25,
                                      width: 80,
                                      child: Text(
                                        "View",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Plan : ${itemPlan[index].plan}",
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "Created date : ${itemPlan[index].createdDate}"),
                                            Text(
                                                "Qty Assets : ${itemPlan[index].qtyAssets}"),
                                          ],
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
