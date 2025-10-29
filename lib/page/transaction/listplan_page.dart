import 'package:ams_express/main.dart';
import 'package:ams_express/model/count/ViewSumStatusModel.dart';
import 'package:ams_express/model/count/viewListCount.dart';
import 'package:ams_express/routes.dart';
import 'package:ams_express/services/database/count_db.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:flutter/material.dart';

class ListPlanPage extends StatefulWidget {
  const ListPlanPage({super.key});

  @override
  State<ListPlanPage> createState() => _ListPlanPageState();
}

class _ListPlanPageState extends State<ListPlanPage> {
  ViewSumStatusModel itemSum = ViewSumStatusModel();
  List<ViewListCountModel> itemPlan = [];

  // Modern Blue Color Palette
  final Color primaryColor = Color(0xFF2196F3);
  final Color secondaryColor = Color(0xFF64B5F6);
  final Color accentColor = Color(0xFF00BCD4);
  final Color cardColor = Colors.white;
  final Color greenColor = Color(0xFF4CAF50);
  final Color redColor = Color(0xFFEF5350);

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
    // itemPlan = [
    //   ViewListCountModel(
    //       plan: "Plan A", createdDate: "2024-01-01", statusPlan: "Open"),
    //   ViewListCountModel(
    //       plan: "Plan B", createdDate: "2024-02-01", statusPlan: "Closed"),
    //   ViewListCountModel(
    //       plan: "Plan C", createdDate: "2024-03-01", statusPlan: "Open"),
    // ];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            appLocalization.localizations.listplan_title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 0.5),
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
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: primaryColor.withOpacity(0.2), width: 2),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      icon: Icons.cancel_rounded,
                      label: appLocalization.localizations.listplan_uncheked,
                      value: itemSum.uncheck ?? 0,
                      total: itemSum.allitem ?? 0,
                      color: redColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            appLocalization.localizations.listplan_total,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${itemSum.allitem ?? 0}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildStatusCard(
                      icon: Icons.check_circle_rounded,
                      label: appLocalization.localizations.listplan_checked,
                      value: itemSum.checked ?? 0,
                      total: itemSum.allitem ?? 0,
                      color: greenColor,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.list_alt_rounded,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Plan List',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          itemCount: itemPlan.length,
                          physics: BouncingScrollPhysics(),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: itemPlan[index].statusPlan ==
                                                    "Open"
                                                ? greenColor.withOpacity(0.3)
                                                : primaryColor.withOpacity(0.3),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  (itemPlan[index].statusPlan ==
                                                              "Open"
                                                          ? greenColor
                                                          : primaryColor)
                                                      .withOpacity(0.1),
                                              blurRadius: 10,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (itemPlan[index]
                                                                          .statusPlan ==
                                                                      "Open"
                                                                  ? greenColor
                                                                  : primaryColor)
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Icon(
                                                          Icons.folder_rounded,
                                                          color: itemPlan[index]
                                                                      .statusPlan ==
                                                                  "Open"
                                                              ? greenColor
                                                              : primaryColor,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          "${itemPlan[index].plan}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: itemPlan[index]
                                                                        .statusPlan ==
                                                                    "Open"
                                                                ? greenColor
                                                                : primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .calendar_today_rounded,
                                                        size: 14,
                                                        color: Colors
                                                            .grey.shade600,
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
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: itemPlan[index]
                                                                .statusPlan ==
                                                            "Open"
                                                        ? [
                                                            greenColor,
                                                            Color(0xFF66BB6A)
                                                          ]
                                                        : [
                                                            primaryColor,
                                                            secondaryColor
                                                          ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      itemPlan[
                                                                      index]
                                                                  .statusPlan ==
                                                              "Open"
                                                          ? Icons
                                                              .lock_open_rounded
                                                          : Icons.lock_rounded,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "${itemPlan[index].statusPlan}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          primaryColor),
                                    ),
                                  );
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

  Widget _buildStatusCard({
    required IconData icon,
    required String label,
    required int value,
    required int total,
    required Color color,
  }) {
    double percentage = total > 0 ? (value / total) * 100 : 0;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
