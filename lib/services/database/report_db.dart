import 'dart:convert';

import 'package:ams_express/main.dart';
import 'package:ams_express/model/report/viewReportDropdownPlanModel.dart';
import 'package:ams_express/model/report/viewReportListDataModel.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:sqflite/sqflite.dart';

class ReportDB {
  String tableName = ImportDB.field_tableName;
  Future<List<ViewReportDropdownPlanModel>> getListDropdown() async {
    final db = await appDb.database;
    final resultPlan = await db
        .query(tableName, distinct: true, columns: [ImportDB.field_plan]);

    // Extract the list of plans
    final plans = resultPlan.map((row) => row[ImportDB.field_plan]).toList();

    final List<ViewReportDropdownPlanModel> planReturn = [];

    for (var plan in plans) {
      final countPlanCheck = await db.rawQuery(
          'SELECT COUNT(*) FROM $tableName WHERE ${ImportDB.field_status_check} = ? AND ${ImportDB.field_plan} = ?',
          [StatusCheck.status_checked, plan]);

      final countPlanUncheck = await db.rawQuery(
          'SELECT COUNT(*) FROM $tableName WHERE ${ImportDB.field_status_check} = ? AND ${ImportDB.field_plan} = ?',
          [StatusCheck.status_uncheck, plan]);

      final totalCheck = Sqflite.firstIntValue(countPlanCheck);
      final totalUncheck = Sqflite.firstIntValue(countPlanUncheck);

      planReturn.add(ViewReportDropdownPlanModel(
        plan: plan.toString(),
        uncheck: totalUncheck,
        check: totalCheck,
      ));
    }

    return planReturn;
  }

  Future<List<ViewReportListDataModel>> getAssetsByPlan(String plan,
      {int limit = 50, int offset = 0}) async {
    final db = await appDb.database;
    final result = await db.query(
      tableName,
      where: '${ImportDB.field_plan} = ?',
      columns: [
        ImportDB.field_asset,
        ImportDB.field_description,
        ImportDB.field_costCenter,
        ImportDB.field_Capitalized_on,
        ImportDB.field_location,
        ImportDB.field_department,
        ImportDB.field_asset_Owner,
        ImportDB.field_user_def_1,
        ImportDB.field_user_def_2,
        ImportDB.field_status_check,
        ImportDB.field_status_assets
      ],
      whereArgs: [plan],
      limit: limit,
      offset: offset,
    );
    List<ViewReportListDataModel> detailReturn = [];
    for (var json in result) {
      detailReturn.add(ViewReportListDataModel(
        asset: json[ImportDB.field_asset].toString(),
        description: json[ImportDB.field_description].toString(),
        costCenter: json[ImportDB.field_costCenter] != "" &&
                json[ImportDB.field_costCenter] != null
            ? int.tryParse(json[ImportDB.field_costCenter].toString())
            : null,
        capitalizedOn: json[ImportDB.field_Capitalized_on].toString(),
        location: json[ImportDB.field_location].toString(),
        department: json[ImportDB.field_department].toString(),
        assetOwner: json[ImportDB.field_asset_Owner].toString(),
        userDef1: json[ImportDB.field_user_def_1].toString(),
        userDef2: json[ImportDB.field_user_def_2].toString(),
        status_asset: json[ImportDB.field_status_assets].toString(),
        status_check: json[ImportDB.field_status_check].toString(),
      ));
    }

    return detailReturn;
  }

  Future<List<ViewReportListDataModel>> getAssetsByPlanOnlyChecked(String plan,
      {int limit = 50, int offset = 0}) async {
    final db = await appDb.database;
    final result = await db.query(
      tableName,
      where:
          '${ImportDB.field_plan} = ? AND ${ImportDB.field_status_check} = ?',
      columns: [
        ImportDB.field_asset,
        ImportDB.field_description,
        ImportDB.field_costCenter,
        ImportDB.field_Capitalized_on,
        ImportDB.field_location,
        ImportDB.field_department,
        ImportDB.field_asset_Owner,
        ImportDB.field_user_def_1,
        ImportDB.field_user_def_2,
        ImportDB.field_status_check,
        ImportDB.field_status_assets
      ],
      whereArgs: [plan, StatusCheck.status_checked],
      limit: limit,
      offset: offset,
    );
    List<ViewReportListDataModel> detailReturn = [];
    for (var json in result) {
      detailReturn.add(ViewReportListDataModel(
        asset: json[ImportDB.field_asset].toString(),
        description: json[ImportDB.field_description].toString(),
        costCenter: json[ImportDB.field_costCenter] != "" &&
                json[ImportDB.field_costCenter] != null
            ? int.tryParse(json[ImportDB.field_costCenter].toString())
            : null,
        capitalizedOn: json[ImportDB.field_Capitalized_on].toString(),
        location: json[ImportDB.field_location].toString(),
        department: json[ImportDB.field_department].toString(),
        assetOwner: json[ImportDB.field_asset_Owner].toString(),
        userDef1: json[ImportDB.field_user_def_1].toString(),
        userDef2: json[ImportDB.field_user_def_2].toString(),
        status_asset: json[ImportDB.field_status_assets].toString(),
        status_check: json[ImportDB.field_status_check].toString(),
      ));
    }

    return detailReturn;
  }

  Future<List<ViewReportListDataModel>> getAssetsByPlanOnlyUnChecked(
      String plan,
      {int limit = 50,
      int offset = 0}) async {
    final db = await appDb.database;
    final result = await db.query(
      tableName,
      where:
          '${ImportDB.field_plan} = ? AND ${ImportDB.field_status_check} = ?',
      columns: [
        ImportDB.field_asset,
        ImportDB.field_description,
        ImportDB.field_costCenter,
        ImportDB.field_Capitalized_on,
        ImportDB.field_location,
        ImportDB.field_department,
        ImportDB.field_asset_Owner,
        ImportDB.field_user_def_1,
        ImportDB.field_user_def_2,
        ImportDB.field_status_check,
        ImportDB.field_status_assets
      ],
      whereArgs: [plan, StatusCheck.status_uncheck],
      limit: limit,
      offset: offset,
    );
    List<ViewReportListDataModel> detailReturn = [];
    for (var json in result) {
      detailReturn.add(ViewReportListDataModel(
        asset: json[ImportDB.field_asset].toString(),
        description: json[ImportDB.field_description].toString(),
        costCenter: json[ImportDB.field_costCenter] != "" &&
                json[ImportDB.field_costCenter] != null
            ? int.tryParse(json[ImportDB.field_costCenter].toString())
            : null,
        capitalizedOn: json[ImportDB.field_Capitalized_on].toString(),
        location: json[ImportDB.field_location].toString(),
        department: json[ImportDB.field_department].toString(),
        assetOwner: json[ImportDB.field_asset_Owner].toString(),
        userDef1: json[ImportDB.field_user_def_1].toString(),
        userDef2: json[ImportDB.field_user_def_2].toString(),
        status_asset: json[ImportDB.field_status_assets].toString(),
        status_check: json[ImportDB.field_status_check].toString(),
      ));
    }

    return detailReturn;
  }
}
