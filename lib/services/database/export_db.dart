import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ams_express/main.dart';
import 'package:ams_express/model/dashboard/view_dashboard_model.dart';
import 'package:ams_express/model/export/exportModel.dart';
import 'package:ams_express/services/database/dashboard_db.dart';
import 'package:ams_express/services/database/gallery_db.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:ams_express/services/theme/storage_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class ExportDB {
  final String mainFolderPath = '/storage/emulated/0/ams_export';
  final String text_name = 'folder:ams_export';

  Future<List<String>> getPlan() async {
    final db = await appDb.database;
    final resultPlan = await db.query(ImportDB.field_tableName,
        distinct: true, columns: [ImportDB.field_plan]);
    final plans =
        resultPlan.map((row) => row[ImportDB.field_plan].toString()).toList();
    return plans;
  }

  Future<void> ExportAllAssetByPlan(String plan) async {
    try {
      String gettingPath = await StorageManager.getDrive();
      final db = await appDb.database;
      const int batchSize = 100; // Reduce batch size to lower memory usage
      int offset = 0;
      bool hasMoreData = true;

      // Create Excel file
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];

      final headers = [
        'Plan',
        'Asset',
        'Description',
        'Cost Center',
        'Capitalized on',
        'Location',
        'Department',
        'Owner Name',
        'Status Check',
        'Status Asset',
        'Scan Date',
        'Count Location',
        'Count Department',
        'Remark',
        'Asset Not In Plan',
        'USER DEF1',
        'USER DEF2'
      ];
      // Add headers
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle.backColor = '#FFD700';
      }

      int currentRow = 2;

      // Show loading
      EasyLoading.show(
          status: 'Loading...', maskType: EasyLoadingMaskType.black);

      // Get total count of assets for progress calculation
      final totalAssets = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM ${ImportDB.field_tableName} WHERE ${ImportDB.field_plan} = ?',
          [plan]))!;

      while (hasMoreData) {
        // Query assets data in batches
        final assets = await db.query(
          ImportDB.field_tableName,
          where: '${ImportDB.field_plan} = ?',
          whereArgs: [plan],
          limit: batchSize,
          offset: offset,
        );

        if (assets.isEmpty) {
          hasMoreData = false;
          break;
        }

        for (int i = 0; i < assets.length; i++) {
          // Add asset data to Excel row
          sheet
              .getRangeByIndex(currentRow, 1)
              .setText(assets[i][ImportDB.field_plan]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 2)
              .setText(assets[i][ImportDB.field_asset]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 3)
              .setText(assets[i][ImportDB.field_description]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 4)
              .setText(assets[i][ImportDB.field_costCenter]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 5).setText(
              assets[i][ImportDB.field_Capitalized_on]?.toString() == "null" ||
                      assets[i][ImportDB.field_Capitalized_on]?.toString() == ""
                  ? ''
                  : assets[i][ImportDB.field_Capitalized_on]?.toString());
          sheet
              .getRangeByIndex(currentRow, 6)
              .setText(assets[i][ImportDB.field_location]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 7)
              .setText(assets[i][ImportDB.field_department]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 8).setText(
              assets[i][ImportDB.field_asset_Owner]?.toString() == "null" ||
                      assets[i][ImportDB.field_asset_Owner]?.toString() == ""
                  ? ''
                  : assets[i][ImportDB.field_asset_Owner]?.toString());

          sheet.getRangeByIndex(currentRow, 9).setText(
              assets[i][ImportDB.field_status_check]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 10).setText(
              assets[i][ImportDB.field_status_assets]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 11)
              .setText(assets[i][ImportDB.field_scan_date]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 12).setText(
              assets[i][ImportDB.field_count_location]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 13).setText(
              assets[i][ImportDB.field_count_department]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 14)
              .setText(assets[i][ImportDB.field_remark]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 15).setText(
              assets[i][ImportDB.field_asset_not_in_plan]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 16).setText(
              assets[i][ImportDB.field_user_def_1]?.toString() == "null" ||
                      assets[i][ImportDB.field_user_def_1]?.toString() == ""
                  ? ''
                  : assets[i][ImportDB.field_user_def_1]?.toString());
          sheet.getRangeByIndex(currentRow, 17).setText(
              assets[i][ImportDB.field_user_def_2]?.toString() == "null" ||
                      assets[i][ImportDB.field_user_def_2]?.toString() == ""
                  ? ''
                  : assets[i][ImportDB.field_user_def_2]?.toString());
          currentRow++;
        }

        // Update progress
        final progress = (offset + assets.length) / totalAssets;
        EasyLoading.showProgress(
          progress,
          status:
              '${appLocalization.localizations.export_loading}. ${(progress * 100).toStringAsFixed(0)}%',
          maskType: EasyLoadingMaskType.black,
        );

        // Move to the next batch of data
        offset += batchSize;
      }
      await createFolderInDocument();
      // Save Excel file
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      // Path ที่ต้องการบันทึกไฟล์
      final String downloadPath = path.join(mainFolderPath);

      String baseFileName = 'export-$plan';
      String fileExtension = '.xlsx';
      String outputFile =
          path.join(downloadPath, '$baseFileName$fileExtension');
      int fileIndex = 1;

      // Check if file already exists and find a unique file name
      while (File(outputFile).existsSync()) {
        outputFile =
            path.join(downloadPath, '$baseFileName($fileIndex)$fileExtension');
        fileIndex++;
      }

      // Write the file
      File(outputFile).writeAsBytesSync(bytes);

      // Dismiss loading
      EasyLoading.showSuccess(
          '${appLocalization.localizations.export_to} $text_name $baseFileName($fileIndex)$fileExtension',
          maskType: EasyLoadingMaskType.black);
    } catch (e, s) {
      EasyLoading.showError('$e');
      print(e);
      print(s);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> exportSheet2Image(xlsio.Workbook workbook, String plan) async {
    final xlsio.Worksheet worksheet = workbook.worksheets.addWithName('Image');

    try {
      final db = await appDb.database;
      // Add headers
      worksheet.getRangeByName('A1').setText('Plan');
      worksheet.getRangeByName('B1').setText('Asset');
      worksheet.getRangeByName('C1').setText('Image');

      bool hasMoreData = true;
      const int batchSize = 100; // Reduce batch size to lower memory usage
      int offset = 0;
      int currentRow = 2;

      while (hasMoreData) {
        // Query associated images
        final images = await db.query(
          GalleryDB.field_tableName,
          where: '${GalleryDB.field_plan} = ?',
          whereArgs: [plan],
          limit: batchSize,
          offset: offset,
        );

        if (images.isEmpty) {
          hasMoreData = false;
          break;
        }

        for (var image in images) {
          final asset = image[GalleryDB.field_asset];
          final imageFilePath = image[GalleryDB.field_image_file_path];

          // Set asset and plan
          worksheet.getRangeByIndex(currentRow, 1).setText(plan);
          worksheet.getRangeByIndex(currentRow, 1).columnWidth = 25;
          worksheet.getRangeByIndex(currentRow, 2).setText(asset.toString());
          worksheet.getRangeByIndex(currentRow, 2).columnWidth = 25;

          // Insert image if it exists
          if (imageFilePath != null && imageFilePath is String) {
            File imageFile = File(imageFilePath);
            if (await imageFile.exists()) {
              final Uint8List imageBytes = await imageFile.readAsBytes();
              final xlsio.Picture picture =
                  worksheet.pictures.addStream(currentRow, 3, imageBytes);

              // Set the size of the picture
              picture.width = 150;
              picture.height = 150;

              // Adjust the row height and column width to fit the picture
              worksheet.getRangeByIndex(currentRow, 3).rowHeight = 100;
              worksheet.getRangeByIndex(currentRow, 3).columnWidth = 25;
            }
          }

          currentRow++;
        }

        // Move to the next batch of data
        offset += batchSize;
      }
    } catch (e, s) {
      print('Error exporting image: $e');
      print(s);
    }
  }

  Future<String> exportImageToFolder(
      Uint8List imageBytes, String fileName) async {
    try {
      final Directory? downloadDirectory = await getExternalStorageDirectory();
      if (downloadDirectory == null) {
        throw Exception("Unable to get download directory");
      }

      final String folderPath = '$mainFolderPath/image';

      final String filePath = '$folderPath/$fileName';
      final File file = File(filePath);

      // บันทึกไฟล์รูปภาพ
      await file.writeAsBytes(imageBytes);

      return filePath;
    } catch (e) {
      print('Error saving image: $e');
      return '';
    }
  }

  Future<void> createFolderInDocument() async {
    try {
      // Get the path to the Pictures directory
      final Directory? picturesDirectory = await getExternalStorageDirectory();
      if (picturesDirectory == null) {
        throw Exception("Unable to get pictures directory");
      }
      // Path ที่ต้องการสร้างโฟลเดอร์ย่อย
      final String subFolderPath = '$mainFolderPath/image';

      // สร้างโฟลเดอร์หลัก
      final Directory mainDirectory = Directory(mainFolderPath);
      if (!await mainDirectory.exists()) {
        await mainDirectory.create(recursive: true);
      }

      // // สร้างโฟลเดอร์ย่อย
      // final Directory subDirectory = Directory(subFolderPath);
      // if (!await subDirectory.exists()) {
      //   await subDirectory.create(recursive: true);
      // }
    } catch (e) {
      print('Error creating folder: $e');
    }
  }

  Future<List<ViewDashboardModel>> getDetailFromPlan(valuePlan) async {
    final master = ImportDB.field_tableName;
    final gallery = GalleryDB.field_tableName;
    final db = await appDb.database;
    final resultPlan = await db.query(master,
        where: "${ImportDB.field_plan} = ?",
        columns: [ImportDB.field_plan],
        whereArgs: [valuePlan],
        limit: 1);

    // Extract the list of plans
    final plan = resultPlan.first['Plan'];

    final List<ViewDashboardModel> planReturn = [];

    final countPlanCheck = await db.rawQuery(
        'SELECT COUNT(*) FROM $master WHERE ${ImportDB.field_status_check} = ? AND ${ImportDB.field_plan} = ?',
        [StatusCheck.status_checked, plan]);

    final countPlanUncheck = await db.rawQuery(
        'SELECT COUNT(*) FROM $master WHERE ${ImportDB.field_status_check} = ? AND ${ImportDB.field_plan} = ?',
        [StatusCheck.status_uncheck, plan]);
    final countPlanImageList = await db.rawQuery(
        'SELECT COUNT(*) FROM $gallery WHERE ${GalleryDB.field_plan} = ?',
        [plan]);
    final countAssetInPlan = await db.rawQuery(
        'SELECT COUNT(*) FROM $master WHERE ${ImportDB.field_plan} = ?',
        [plan]);

    final totalListAsset = Sqflite.firstIntValue(countAssetInPlan);
    final totalImageList = Sqflite.firstIntValue(countPlanImageList);
    final totalCheck = Sqflite.firstIntValue(countPlanCheck);
    final totalUncheck = Sqflite.firstIntValue(countPlanUncheck);

    planReturn.add(ViewDashboardModel(
      sum_asset: totalListAsset,
      plan: plan.toString(),
      uncheck: totalUncheck,
      check: totalCheck,
      image: totalImageList,
    ));
    if (kDebugMode) {
      print(planReturn);
    }

    return planReturn;
  }
}
