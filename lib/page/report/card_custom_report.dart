import 'package:ams_express/component/label.dart';
import 'package:ams_express/extension/color_extension.dart';
import 'package:flutter/material.dart';

import '../../model/report/viewReportListDataModel.dart';
import '../../services/database/quickType.dart';

class CardCustomReport extends StatelessWidget {
  CardCustomReport({super.key, required this.dataList, this.onTap});

  ViewReportListDataModel dataList;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 15,
        color: Colors.white,
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            color: dataList.status_check == StatusCheck.status_uncheck
                ? Colors.red
                : Colors.green,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 19,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: dataList.status_check ==
                                    StatusCheck.status_uncheck
                                ? Colors.red
                                : Colors.green,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(14)),
                          ),
                          child: Text(
                            "${dataList.asset}",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Label("Description : ${dataList.description}",
                          maxLine: 3,
                          color: AppColors.contentColorBlue,
                          fontSize: 14),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Label(
                          "Department : ${dataList.department == null || dataList.department == "" ? "-" : dataList.department}",
                          color: AppColors.contentColorBlue,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                          child: Label(
                              "Location : ${dataList.location == null ? "-" : dataList.location} ",
                              color: AppColors.contentColorBlue,
                              fontSize: 14)),
                      // Expanded(
                      //   child: Label(
                      //       "Count Status : ${item.STATUS_CHECK} ",
                      //       color: colorPrimary,
                      //       fontSize: 14),
                      // ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    dataList.status_check != StatusCheck.status_uncheck
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Label(
                                  "Status Name : ${dataList.status_asset ?? "-"} ",
                                  color: AppColors.contentColorBlue,
                                  fontSize: 14),
                            ),
                          )
                        : Expanded(child: SizedBox.shrink()),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 21,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: dataList.status_check ==
                                    StatusCheck.status_uncheck
                                ? Colors.red
                                : Colors.green,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(14)),
                          ),
                          child: Text(
                            "${dataList.status_check} ",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
