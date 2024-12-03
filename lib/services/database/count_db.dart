import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';

import 'package:ams_express/component/custom_botToast.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/model/count/countModelEvent.dart';
import 'package:ams_express/model/count/viewListCount.dart';
import 'package:ams_express/model/report/viewReportEditModel.dart';
import 'package:ams_express/services/database/gallery_db.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../extension/color_extension.dart';
import '../../model/count/responseCountModel.dart';
import '../../page/qr_Code_View_page.dart';

enum StatusQuery { inplan, notPlan, invalid }

class CountDB {
  String tableName = ImportDB.field_tableName;
  Future<List<ViewListCountModel>> getList() async {
    final db = await appDb.database;
    final result = await db.query(tableName, distinct: true, columns: [
      ImportDB.field_plan,
      ImportDB.field_created_date,
      ImportDB.field_status_plan
    ]);

    final Set<String> uniquePlans = {};
    final List<ViewListCountModel> planReturn = [];

    for (var json in result) {
      String planStr = json[ImportDB.field_plan].toString();
      String createdDate = json[ImportDB.field_created_date].toString();
      String statusPlan = json[ImportDB.field_status_plan].toString();

      if (!uniquePlans.contains(planStr)) {
        uniquePlans.add(planStr);
        planReturn.add(ViewListCountModel(
          plan: planStr,
          createdDate: createdDate,
          statusPlan: statusPlan,
        ));
      }
    }

    return planReturn;
  }

  Future<ResponseCountModel> scanCount(
      CountModelEvent obj, BuildContext context) async {
    try {
      ResponseCountModel itemReturn = ResponseCountModel();
      StatusQuery isAssetINPlan = await _checkAssetInPlan(obj);
      bool isCheckLocation;
      bool isCheckDepartment;
      if (isAssetINPlan == StatusQuery.inplan)
      //อยู่ในแผน
      {
        bool isCounted = await _checkStatusAsset(obj);
        //ถ้านับไปแล้ว
        if (isCounted) {
          bool isConfirm = await showDialogConfirm(context,
              title: appLocalization.localizations.warning_count_asset,
              content: appLocalization
                  .localizations.warning_count_asset_already_count,
              type: TypeAlert.warning);
          if (isConfirm) {
            //เช็คว่ามีLocation หรือ Department มีส่งมาไหม
            if (obj.location != null && obj.department != null) {
              //ถ้ามี Location และ Department
              isCheckLocation = await checkLocation(obj);
              isCheckDepartment = await checkDepartment(obj);
              if (isCheckLocation && isCheckDepartment) {
                CustomBotToast.showSuccess(
                    appLocalization.localizations.success);
              } else if (isCheckLocation && !isCheckDepartment) {
                CustomBotToast.showWarning(appLocalization
                    .localizations.warning_count_department_not_match);
              } else if (!isCheckLocation && isCheckDepartment) {
                CustomBotToast.showWarning(appLocalization
                    .localizations.warning_count_location_not_match);
              } else {
                CustomBotToast.showWarning(appLocalization.localizations
                    .warning_count_location_and_department_not_match);
              }
            } else if (obj.location != null && obj.department == null) {
              isCheckLocation = await checkLocation(obj);
              if (!isCheckLocation) {
                CustomBotToast.showWarning(appLocalization
                    .localizations.warning_count_location_not_match);
              }
            } else if (obj.location == null && obj.department != null) {
              isCheckDepartment = await checkDepartment(obj);
              if (!isCheckDepartment) {
                CustomBotToast.showWarning(appLocalization
                    .localizations.warning_count_department_not_match);
              }
            }
            itemReturn = await _updateInPlan(obj);
          }
        } else {
          //เช็คว่ามีLocation หรือ Department มีส่งมาไหม
          if (obj.location != null && obj.department != null) {
            //ถ้ามี Location และ Department
            isCheckLocation = await checkLocation(obj);
            isCheckDepartment = await checkDepartment(obj);
            if (isCheckLocation && isCheckDepartment) {
              CustomBotToast.showSuccess(appLocalization.localizations.success);
            } else if (isCheckLocation && !isCheckDepartment) {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_department_not_match);
            } else if (!isCheckLocation && isCheckDepartment) {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_location_not_match);
            } else {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_department_not_match);
            }
          } else if (obj.location != null && obj.department == null) {
            isCheckLocation = await checkLocation(obj);
            if (!isCheckLocation) {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_location_not_match);
            }
          } else if (obj.location == null && obj.department != null) {
            isCheckDepartment = await checkDepartment(obj);
            if (!isCheckDepartment) {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_department_not_match);
            }
          }
          itemReturn = await _updateInPlan(obj);
        }
      }
      //ไม่ได้อยู่ในแผน
      else if (isAssetINPlan == StatusQuery.notPlan) {
        bool isConfirmNotPlan = await showDialogConfirm(context,
            title: appLocalization.localizations.warning_count_asset,
            content:
                appLocalization.localizations.warning_count_asset_not_in_plan,
            type: TypeAlert.warning);
        if (isConfirmNotPlan) {
          if (obj.location != null && obj.department != null) {
            //ถ้ามี Location และ Department
            isCheckLocation = await checkLocation(obj);
            isCheckDepartment = await checkDepartment(obj);
            if (isCheckLocation && isCheckDepartment) {
              CustomBotToast.showSuccess(appLocalization.localizations.success);
            } else if (isCheckLocation && !isCheckDepartment) {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_department_not_match);
            } else if (!isCheckLocation && isCheckDepartment) {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_location_not_match);
            } else {
              CustomBotToast.showWarning(appLocalization.localizations
                  .warning_count_location_and_department_not_match);
            }
          } else if (obj.location != null && obj.department == null) {
            isCheckLocation = await checkLocation(obj);
            if (!isCheckLocation) {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_location_not_match);
            }
            //ถ้ามี Location แต่ไม่มี Department
          } else if (obj.location == null && obj.department != null) {
            //ถ้ามี Department แต่ไม่มี Location
            isCheckDepartment = await checkDepartment(obj);
            if (!isCheckDepartment) {
              CustomBotToast.showWarning(appLocalization
                  .localizations.warning_count_department_not_match);
            }
          }
          itemReturn = await _insertNotINPlan(obj);
        }
      } else if (isAssetINPlan == StatusQuery.invalid) {
        CustomBotToast.showWarning(appLocalization.localizations.no_data_found);
      }
      return itemReturn;
    } catch (e, s) {
      print(e);
      print(s);
      return ResponseCountModel(is_Success: false);
    }
  }

  Future<bool> _checkStatusAsset(CountModelEvent obj) async {
    final db = await appDb.database;
    final checkStatusAssets = await db.query(tableName,
        where:
            "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ? AND ${ImportDB.field_status_check} = ?",
        whereArgs: [obj.barcode, obj.plan, StatusCheck.status_checked],
        limit: 1);
    if (checkStatusAssets.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //ตรวจสอบว่า Assetอยู่ใน Plan หรือไม่
  Future<StatusQuery> _checkAssetInPlan(CountModelEvent obj) async {
    final db = await appDb.database;
    final checkInPlan = await db.query(tableName,
        where:
            ImportDB.field_asset + " = ? AND " + ImportDB.field_plan + " = ?",
        whereArgs: [obj.barcode, obj.plan],
        limit: 1);
    if (checkInPlan.isNotEmpty) {
      return StatusQuery.inplan;
    } else {
      final checkOutPlan = await db.query(tableName,
          where: ImportDB.field_asset + " = ?",
          whereArgs: [obj.barcode],
          limit: 1);
      if (checkOutPlan.isNotEmpty) {
        return StatusQuery.notPlan;
      } else {
        return StatusQuery.invalid;
      }
    }
  }

  Future<ResponseCountModel> _updateInPlan(CountModelEvent obj) async {
    try {
      ResponseCountModel itemReturn = ResponseCountModel();
      final db = await appDb.database;

      //ดึงStatus ของ Assets ตัวมันเองออกมา
      final checkStatusInAsset = await db.query(
        tableName,
        where:
            ImportDB.field_asset + " = ? AND " + ImportDB.field_plan + " = ?",
        whereArgs: [obj.barcode, obj.plan],
        columns: [ImportDB.field_asset_not_in_plan],
        limit: 1,
      );
      final updateInPlan = await db.update(
          tableName,
          {
            ImportDB.field_count_location: obj.location,
            ImportDB.field_count_department: obj.department,
            ImportDB.field_status_assets: obj.statusAsset,
            // ImportDB.field_remark: obj.remark ?? "",
            ImportDB.field_scan_date:
                DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
            ImportDB.field_status_check: StatusCheck.status_checked,
            ImportDB.field_asset_not_in_plan: checkStatusInAsset[0]
                            [ImportDB.field_asset_not_in_plan]
                        .toString() ==
                    "YES"
                ? "YES"
                : "NO",
          },
          where:
              ImportDB.field_asset + " = ? AND " + ImportDB.field_plan + " = ?",
          whereArgs: [obj.barcode, obj.plan]);
      if (updateInPlan != 0) {
        final result = await db.query(tableName,
            where: "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ?",
            whereArgs: [obj.barcode, obj.plan],
            limit: 1);
        itemReturn = ResponseCountModel(
            asset: result[0][ImportDB.field_asset].toString(),
            costCenter: result[0][ImportDB.field_costCenter].toString(),
            department: result[0][ImportDB.field_department].toString(),
            statusAsset: result[0][ImportDB.field_status_assets].toString(),
            remark: result[0][ImportDB.field_remark].toString(),
            scanDate: result[0][ImportDB.field_scan_date].toString(),
            qty: result[0][ImportDB.field_qty].toString(),
            cap_date: result[0][ImportDB.field_Capitalized_on].toString(),
            check: result[0][ImportDB.field_status_check].toString(),
            name: result[0][ImportDB.field_description].toString(),
            is_Success: true);
      } else {
        itemReturn = ResponseCountModel(is_Success: false);
      }
      await updateStatusPlan(obj);
      return itemReturn;
    } catch (e, s) {
      print(e);
      print(s);
      return ResponseCountModel(is_Success: false);
    }
  }

  Future<bool> checkLocation(CountModelEvent obj) async {
    final db = await appDb.database;
    final checkLocation = await db.query(tableName,
        where: ImportDB.field_location +
            " = ? AND " +
            ImportDB.field_asset +
            " = ? AND " +
            ImportDB.field_plan +
            " = ?  ",
        whereArgs: [obj.location, obj.barcode, obj.plan],
        limit: 1);
    if (checkLocation.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkDepartment(CountModelEvent obj) async {
    final db = await appDb.database;
    final checkDepartment = await db.query(tableName,
        where: ImportDB.field_department +
            " = ? AND " +
            ImportDB.field_asset +
            " = ? AND " +
            ImportDB.field_plan +
            " = ?  ",
        whereArgs: [obj.department, obj.barcode, obj.plan],
        limit: 1);
    if (checkDepartment.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //ตรวจสอบว่า Asset นั้นๆ มีการนับไปแล้วหรือยัง
  Future<void> updateStatusPlan(CountModelEvent obj) async {
    final db = await appDb.database;
    final queryCheckStatusPlan = await db.query(tableName,
        where: ImportDB.field_plan + " = ?", whereArgs: [obj.plan], limit: 1);
    if (queryCheckStatusPlan[0][ImportDB.field_status_plan].toString() ==
        StatusCheck.status_open) {
      var result = await db.update(
          tableName, {ImportDB.field_status_plan: StatusCheck.status_count},
          where: ImportDB.field_plan + " = ?", whereArgs: [obj.plan]);
    }
  }

  // Future<CountModelEvent> checkStatusAsset1234(CountModelEvent obj) async {
  //   CountModelEvent itemReturn = CountModelEvent();
  //   final db = await appDb.database;
  //   final checkStatusAssets = await db.query(tableName,
  //       where:
  //           "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ? AND ${ImportDB.field_status_check} = ?",
  //       whereArgs: [obj.barcode, obj.plan, StatusCheck.status_checked],
  //       limit: 1);
  //   if (checkStatusAssets.isNotEmpty) {
  //     //ถ้ามีข้อมูลในฐานข้อมูล
  //     itemReturn = CountModelEvent(
  //         plan: checkStatusAssets[0][ImportDB.field_plan].toString(),
  //         barcode: checkStatusAssets[0][ImportDB.field_asset].toString(),
  //         location: checkStatusAssets[0][ImportDB.field_location].toString(),
  //         department:
  //             checkStatusAssets[0][ImportDB.field_department].toString(),
  //         costCenter: checkStatusAssets[0][ImportDB.field_costCenter] as int,
  //         statusAsset:
  //             checkStatusAssets[0][ImportDB.field_status_assets].toString(),
  //         remark: checkStatusAssets[0][ImportDB.field_remark].toString(),
  //         scanDate: checkStatusAssets[0][ImportDB.field_scan_date].toString(),
  //         is_Success: true);
  //   } else {
  //     itemReturn = CountModelEvent(is_Success: false);
  //     //ถ้าไม่มีข้อมูลในฐานข้อมูล
  //   }

  //   return itemReturn;
  // }

  Future<ResponseCountModel> _insertNotINPlan(CountModelEvent obj) async {
    try {
      ResponseCountModel itemReturn = ResponseCountModel(is_Success: false);
      final db = await appDb.database;
      final queryAssetOutPlan = await db.query(tableName,
          where: "${ImportDB.field_asset} = ?",
          whereArgs: [obj.barcode],
          limit: 1);
      if (queryAssetOutPlan.isNotEmpty) {
        final insertNotInPlan = await db.insert(tableName, {
          ImportDB.field_plan: obj.plan.toString(),
          ImportDB.field_asset: obj.barcode,
          ImportDB.field_costCenter:
              queryAssetOutPlan[0][ImportDB.field_costCenter].toString(),
          ImportDB.field_description:
              queryAssetOutPlan[0][ImportDB.field_description].toString(),
          ImportDB.field_Capitalized_on:
              queryAssetOutPlan[0][ImportDB.field_Capitalized_on].toString(),
          ImportDB.field_location:
              queryAssetOutPlan[0][ImportDB.field_location].toString(),
          ImportDB.field_department:
              queryAssetOutPlan[0][ImportDB.field_department].toString(),
          ImportDB.field_asset_Owner:
              queryAssetOutPlan[0][ImportDB.field_asset_Owner].toString(),
          ImportDB.field_qty: obj.qty,
          ImportDB.field_status_assets: obj.statusAsset,
          ImportDB.field_remark: obj.remark ?? "",
          ImportDB.field_count_location: obj.location,
          ImportDB.field_count_department: obj.department,
          ImportDB.field_scan_date:
              DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
          ImportDB.field_status_check: StatusCheck.status_checked,
          ImportDB.field_asset_not_in_plan: "YES",
          ImportDB.field_status_plan: StatusCheck.status_count,
          ImportDB.field_created_date:
              queryAssetOutPlan[0][ImportDB.field_created_date].toString(),
        });
        final result = await db.query(tableName,
            where: "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ?",
            whereArgs: [obj.barcode, obj.plan],
            limit: 1);
        if (result.isNotEmpty) {
          itemReturn = ResponseCountModel(
              asset: result[0][ImportDB.field_asset].toString(),
              costCenter: result[0][ImportDB.field_costCenter].toString(),
              department: result[0][ImportDB.field_department].toString(),
              statusAsset: result[0][ImportDB.field_status_assets].toString(),
              remark: result[0][ImportDB.field_remark].toString(),
              scanDate: result[0][ImportDB.field_scan_date].toString(),
              qty: result[0][ImportDB.field_qty].toString(),
              cap_date: result[0][ImportDB.field_Capitalized_on].toString(),
              check: result[0][ImportDB.field_status_check].toString(),
              name: result[0][ImportDB.field_description].toString(),
              is_Success: true);
        }

        await updateStatusPlan(obj);

        return itemReturn;
      }

      return itemReturn;
    } catch (e, s) {
      print(e);
      print(s);
      return ResponseCountModel(is_Success: false);
    }
  }

  Future<bool> showDialogConfirm(BuildContext context,
      {required String? title, String? content, TypeAlert? type}) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  Text(title!),
                  type == TypeAlert.warning
                      ? Icon(
                          Icons.warning,
                          color: Colors.red,
                        )
                      : SizedBox.fromSize()
                ],
              ),
              content: Text(content ?? ""),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.contentColorRed)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(appLocalization.localizations.import_btn_cancel,
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green)),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    appLocalization.localizations.btn_ok,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if the dialog is dismissed without a selection
  }

  Future<bool> btnSave(CountModelEvent obj) async {
    final db = await appDb.database;
    final queryAssetOutPlan = await db.update(
        tableName,
        {
          ImportDB.field_status_assets: obj.statusAsset,
          ImportDB.field_remark: obj.remark,
        },
        where: "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ?",
        whereArgs: [obj.barcode, obj.plan]);

    if (queryAssetOutPlan != 0) {
      return true;
    }
    return false;
  }

  //////==================================EditPage=============================//////////////////////
  ///
  ///
  Future<ViewReportEditModel> getAssetEdit(
      {required String plan, required String asset}) async {
    ViewReportEditModel itemReturn = ViewReportEditModel();
    try {
      final db = await appDb.database;
      final result = await db.query(tableName,
          where: "${ImportDB.field_plan} = ? AND ${ImportDB.field_asset} = ?",
          whereArgs: [plan, asset],
          columns: [
            ImportDB.field_description,
            ImportDB.field_costCenter,
            ImportDB.field_Capitalized_on,
            ImportDB.field_location,
            ImportDB.field_department,
            ImportDB.field_asset_Owner,
            ImportDB.field_created_date,
            ImportDB.field_status_check,
            ImportDB.field_status_assets,
            ImportDB.field_count_location,
            ImportDB.field_count_department,
            ImportDB.field_remark,
            ImportDB.field_status_plan,
            ImportDB.field_scan_date,
            ImportDB.field_qty,
          ],
          limit: 1);
      itemReturn = ViewReportEditModel.fromJson(result[0]);
      print(jsonEncode(itemReturn));
      return itemReturn;
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }

  Future<ResponseCountModel> readQrCodeAndBarcode(
      BuildContext context, CountModelEvent obj) async {
    ResponseCountModel itemReturn = ResponseCountModel();
    var barcodeResult = await BarcodeScanner.scan();

    if (barcodeResult.rawContent.isNotEmpty &&
        barcodeResult.rawContent != '-1') {
      itemReturn = await scanCount(
        CountModelEvent(
          barcode: barcodeResult.rawContent.toUpperCase(),
          plan: obj.plan,
          location: obj.location,
          department: obj.department,
          statusAsset: obj.statusAsset,
          qty: obj.qty,
        ),
        context,
      );
    }
    return itemReturn;
  }
}
