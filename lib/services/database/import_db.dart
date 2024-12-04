import 'dart:convert';
import 'dart:io';

import 'package:ams_express/main.dart';
import 'package:ams_express/model/count/ViewSumStatusModel.dart';
import 'package:ams_express/model/importModel/view_Import_Model.dart';
import 'package:ams_express/model/importModel/view_import_detail_Model.dart';
import 'package:ams_express/services/database/gallery_db.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ImportDB {
  static String field_tableName = 'ImportMaster';
  static String field_plan = 'Plan';
  static String field_asset = 'Asset';
  static String field_description = 'Description';
  static String field_costCenter = 'CostCenter';
  static String field_Capitalized_on = 'Capitalized_on';
  static String field_location = 'Location';
  static String field_department = 'Department';
  static String field_asset_Owner = 'Asset_Owner';
  static String field_created_date = 'created_date';
  static String field_user_def_1 = 'User_def_1';
  static String field_user_def_2 = 'User_def_2';
  static String field_user_def_3 = 'User_def_3';
  static String field_user_def_4 = 'User_def_4';
  static String field_status_check = 'Status_Check';
  static String field_status_assets = 'Status_Asset';
  static String field_scan_date = 'Scan_Date';
  static String field_count_location = 'count_location';
  static String field_count_department = 'count_department';
  static String field_remark = 'remark';
  static String field_asset_not_in_plan = 'asset_not_in_plan';
  static String image_file_path = 'file_image';
  static String field_status_plan = 'status_plan';
  static String field_qty = 'qty';

  static const String counterFilePath = 'import_counter.txt';

  createTable(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $field_tableName ('
        '${QuickTypes.ID_PRIMARYKEY},'
        '$field_plan ${QuickTypes.TEXT},'
        '$field_asset ${QuickTypes.TEXT},'
        '$field_description ${QuickTypes.TEXT},'
        '$field_costCenter ${QuickTypes.TEXT},'
        '$field_Capitalized_on ${QuickTypes.TEXT},'
        '$field_location ${QuickTypes.TEXT},'
        '$field_department ${QuickTypes.TEXT},'
        '$field_asset_Owner ${QuickTypes.TEXT},'
        '$field_created_date ${QuickTypes.TEXT},'
        '$field_status_check ${QuickTypes.TEXT},'
        '$field_status_assets ${QuickTypes.TEXT},'
        '$field_scan_date ${QuickTypes.TEXT},'
        '$field_count_location ${QuickTypes.TEXT},'
        '$field_count_department ${QuickTypes.TEXT},'
        '$field_remark ${QuickTypes.TEXT},'
        '$field_asset_not_in_plan ${QuickTypes.TEXT},'
        '$field_qty ${QuickTypes.TEXT},'
        '$image_file_path BLOB,'
        '$field_status_plan ${QuickTypes.TEXT},'
        '$field_user_def_1 ${QuickTypes.TEXT},'
        '$field_user_def_2 ${QuickTypes.TEXT},'
        '$field_user_def_3 ${QuickTypes.TEXT},'
        '$field_user_def_4 ${QuickTypes.TEXT}'
        ')');
  }

  Future<void> saveCounter(int counter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('import_counter', counter);
  }

  Future<int> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('import_counter') ?? 1; // Default value if not set
  }

  Future<void> clearCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('import_counter');
  }

  Future<void> importFileExcel() async {
    try {
      EasyLoading.show(
          status: appLocalization.localizations.loading,
          maskType: EasyLoadingMaskType.black);
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        EasyLoading.show(
            status: appLocalization.localizations.import_loading,
            maskType: EasyLoadingMaskType.black);
        final String excelPath = result.files.single.path!;

        final bytes = File(excelPath).readAsBytesSync();
        final excel = Excel.decodeBytes(bytes);

        final List<List<dynamic>> excelData = [];

        for (var table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet != null) {
            for (var row in sheet.rows) {
              final List<dynamic> rowData =
                  row.map((cell) => cell?.value).toList();
              excelData.add(rowData);
            }
          }
        }

        // Skip the header row
        final List<List<dynamic>> dataWithoutHeader =
            excelData.skip(1).toList();

        // Initialize EasyLoading

        // Load the counter value
        int importCounter = await loadCounter();

        // Process data in chunks
        const int chunkSize = 100; // Adjust the chunk size as needed
        String plan_id =
            '${DateFormat('yyyyMMdd').format(DateTime.now())}-${importCounter.toString().padLeft(5, '0')}';
        String created_dated =
            '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}';
        for (int i = 0; i < dataWithoutHeader.length; i += chunkSize) {
          final chunk = dataWithoutHeader.skip(i).take(chunkSize).toList();

          await insertExcelToSql(chunk, plan_id, created_dated);

          final progress = ((i + chunkSize) / dataWithoutHeader.length) * 100;
          if (progress <= 100) {
            EasyLoading.showProgress(progress / 100,
                status:
                    '${appLocalization.localizations.import_loading} ${progress.toStringAsFixed(0)}%',
                maskType: EasyLoadingMaskType.black);
          }
        }

        // Dismiss EasyLoading
        EasyLoading.dismiss();

        // Increment the counter and save it
        importCounter++;
        await saveCounter(importCounter);
      }
    } catch (e, s) {
      EasyLoading.showError('Error: $e');
      print(e);
      print(s);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future insertExcelToSql(
      List<List<dynamic>> data, String header, String current_date) async {
    final db = await appDb.database;
    final batch = db.batch();
    for (var row in data) {
      batch.insert(field_tableName, {
        field_plan: header,
        field_asset: row[0].toString().toUpperCase(),
        field_description: row[1].toString(),
        field_costCenter: row[2].toString(),
        field_Capitalized_on: row[3].toString(),
        field_location: row[4].toString(),
        field_department: row[5].toString(),
        field_asset_Owner: row[6].toString(),
        field_user_def_1: row[7].toString(),
        field_user_def_2: row[8].toString(),
        field_user_def_3: null,
        field_user_def_4: null,
        field_created_date: current_date,
        field_status_check: StatusCheck.status_uncheck,
        field_status_plan: StatusCheck.status_open,
        field_asset_not_in_plan: "NO",
      });
    }
    await batch.commit(noResult: true);
  }

  // Function to count assets for a specific plan
  Future<int> countAssetsForPlan(String plan) async {
    final db = await appDb.database;
    final countAssets = await db.rawQuery(
        'SELECT COUNT(asset) as assetCount FROM $field_tableName WHERE ${field_plan} = ?',
        [plan]);
    final int count = Sqflite.firstIntValue(countAssets) ?? 0;
    return count;
  }

  // Function to select plans and their asset counts
  Future<List<ViewImportModel>> selectPlan() async {
    final db = await appDb.database;

    // Query to get distinct plans and their creation dates
    final result = await db.query(field_tableName,
        distinct: true, columns: [field_plan, field_created_date]);

    // Initialize an empty list to store the ViewImportModel objects
    final List<ViewImportModel> planReturn = [];

    // Iterate over each distinct plan
    for (var json in result) {
      String planStr = json[field_plan].toString();
      String createdDate = json['created_date'].toString();

      // Get the count of assets for the current plan
      final int count = await countAssetsForPlan(planStr);

      // Create a ViewImportModel object and add it to the list
      planReturn.add(ViewImportModel(
        plan: planStr,
        createdDate: createdDate,
        qtyAssets: count.toString(),
      ));
    }

    return planReturn;
  }

  Future<List<ViewImportdetailModel>> viewDetail(String objPlan,
      {int limit = 10, int offset = 0}) async {
    final db = await appDb.database;
    final result = await db.query(
      field_tableName,
      where: '$field_plan = ?',
      whereArgs: [objPlan],
      limit: limit,
      offset: offset,
    );

    final List<ViewImportdetailModel> detailReturn = [];

    for (var json in result) {
      detailReturn.add(ViewImportdetailModel(
        id: int.tryParse(json['ID'].toString()),
        plan: json[field_plan].toString(),
        asset: json[field_asset].toString(),
        description: json[field_description].toString(),
        costCenter: json[field_costCenter].toString(),
        capitalizedOn: json[field_Capitalized_on].toString(),
        location: json[field_location].toString(),
        department: json[field_department].toString(),
        assetOwner: json[field_asset_Owner].toString(),
        createdDate: json[field_created_date].toString(),
        userDef1: json[field_user_def_1].toString(),
        userDef2: json[field_user_def_2].toString(),
        userDef3: json[field_user_def_3].toString(),
        userDef4: json[field_user_def_4].toString(),
      ));
    }
    return detailReturn;
  }

  Future deleteData(String planOrder) async {
    if (planOrder.isNotEmpty) {
      final db = await appDb.database;
      await db.delete(field_tableName,
          where: '$field_plan = ?', whereArgs: [planOrder]);
      await db.delete(GalleryDB.field_tableName,
          where: '${GalleryDB.field_plan} = ?', whereArgs: [planOrder]);
    } else {
      final db = await appDb.database;
      await db.delete(field_tableName);
      await db.delete(GalleryDB.field_tableName);
      await ImportDB().clearCounter();
    }
  }

  Future<ViewSumStatusModel> getSummaryViewOnSelectPlan() async {
    final db = await appDb.database;
    final queryUncheck = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $field_tableName WHERE $field_status_check = ?',
      [StatusCheck.status_uncheck],
    );
    final queryChecked = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $field_tableName WHERE $field_status_check = ?',
      [StatusCheck.status_checked],
    );

    final queryAllPlan = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $field_tableName',
    );

    // Extract the count from the result
    int resultUncheck = Sqflite.firstIntValue(queryUncheck) ?? 0;
    int resultcheck = Sqflite.firstIntValue(queryChecked) ?? 0;
    int allPlan = Sqflite.firstIntValue(queryAllPlan) ?? 0;

    ViewSumStatusModel item = ViewSumStatusModel(
        uncheck: resultUncheck, checked: resultcheck, allitem: allPlan);
    return item;
  }
}
