import 'package:ams_express/component/custom_range_pointer.dart';
import 'package:ams_express/component/textformfield/custom_input.dart';
import 'package:ams_express/extension/color_extension.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/model/count/ViewSumStatusModel.dart';
import 'package:ams_express/model/count/viewListCount.dart';
import 'package:ams_express/routes.dart';
import 'package:ams_express/services/database/count_db.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:flutter/material.dart';

import '../../component/label.dart';
import '../../model/importModel/view_Import_Model.dart';

class ListPlanPage extends StatefulWidget {
  const ListPlanPage({super.key});

  @override
  State<ListPlanPage> createState() => _ListPlanPageState();
}

class _ListPlanPageState extends State<ListPlanPage> {
  ViewSumStatusModel itemSum = ViewSumStatusModel();
  List<ViewListCountModel> itemPlan = [];
  @override
  void initState() {
    ImportDB().getSummaryViewOnSelectPlan().then((value) {
      setState(() {
        itemSum = value;
      });
    });
    CountDB().getList().then((value) {
      setState(() {
        itemPlan = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: colorPrimary,
        appBar: AppBar(
          backgroundColor: Colors.green.shade500,
          elevation: 10,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
          title: Text(
            appLocalization.localizations.listplan_title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 5,
                  shape: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        itemSum.uncheck != null
                            ? Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomRangePoint(
                                        color: Colors.red,
                                        valueRangePointer: itemSum.uncheck,
                                        allItem: itemSum.allitem,
                                        text: appLocalization
                                            .localizations.listplan_uncheked,
                                        colorText: AppColors.contentColorBlue,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : CircularProgressIndicator(),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Label(
                                appLocalization.localizations.listplan_total,
                                color: AppColors.contentColorBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              Label(
                                "${itemSum.allitem}",
                                color: AppColors.contentColorBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        itemSum.checked != null
                            ? Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomRangePoint(
                                        color: Colors.white,
                                        valueRangePointer: itemSum.checked,
                                        colorText: AppColors.contentColorBlue,
                                        allItem: itemSum.allitem,
                                        text: appLocalization
                                            .localizations.listplan_checked,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              )
                            : CircularProgressIndicator()
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: itemPlan.length,
                          itemBuilder: (context, index) {
                            return itemPlan.isNotEmpty
                                ? GestureDetector(
                                    onTap: () async {
                                      await Navigator.pushNamed(
                                              context, Routes.count,
                                              arguments: itemPlan[index].plan)
                                          .then((v) async {
                                        await ImportDB()
                                            .getSummaryViewOnSelectPlan()
                                            .then((value) {
                                          setState(() {
                                            itemSum = value;
                                          });
                                        });
                                        await CountDB().getList().then((value) {
                                          setState(() {
                                            itemPlan = value;
                                          });
                                        });
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 15,
                                        color: Colors.white,
                                        shape: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: itemPlan[index].statusPlan ==
                                                    "Open"
                                                ? Colors.green
                                                : AppColors.contentColorCyan,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      "${appLocalization.localizations.listplan_plan} : ${itemPlan[index].plan}"),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            "${appLocalization.localizations.listplan_created} : ${itemPlan[index].createdDate}"),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.3,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 21,
                                                              vertical: 7,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: itemPlan[index]
                                                                          .statusPlan ==
                                                                      "Open"
                                                                  ? Colors.green
                                                                  : AppColors
                                                                      .contentColorBlue,
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          14)),
                                                            ),
                                                            child: Text(
                                                              "${itemPlan[index].statusPlan}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : CircularProgressIndicator();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
