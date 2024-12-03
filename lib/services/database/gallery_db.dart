import 'dart:convert';
import 'dart:io';

import 'package:ams_express/component/custom_botToast.dart';
import 'package:ams_express/model/galleryModel/galleryModel.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';

class GalleryDB {
  static const String field_tableName = 'GalleryDB';
  static const String field_plan = 'Plan';
  static const String field_asset = 'Asset';
  static const String filed_name_image = 'name';
  static const String field_image_file_path = 'Image_file';
  static const String field_created_date = 'created_date';

  createTable(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $field_tableName ('
        '${QuickTypes.ID_PRIMARYKEY},'
        '$field_plan ${QuickTypes.TEXT},'
        '$field_asset ${QuickTypes.TEXT},'
        '$filed_name_image ${QuickTypes.TEXT},'
        '$field_image_file_path ${QuickTypes.TEXT},'
        '$field_created_date ${QuickTypes.TEXT}'
        ')');
  }

  Future<bool> insertImage(
      String filePath, String planValue, String assetValue) async {
    try {
      final db = await appDb.database;
      final Directory? appDocDir = await getExternalStorageDirectory();
      if (appDocDir == null) {
        print("Error: Unable to get external storage directory.");
        return false;
      }
      final String appDocPath = appDocDir.path;

      // สร้างพาธสำหรับเก็บรูปภาพ
      final String imageFileName =
          "${assetValue}-${DateFormat('HHmmss').format(DateTime.now())}.jpg";
      final String newImagePath = '$appDocPath/$imageFileName';

      // ตรวจสอบว่าไฟล์รูปภาพมีอยู่และไม่ว่างเปล่า
      final File fileImage = File(filePath);
      if (!(await fileImage.exists())) {
        print("Error: File does not exist.");
        return false;
      }
      if ((await fileImage.length()) == 0) {
        print("Error: File is empty.");
        return false;
      }

      // คัดลอกรูปภาพไปยังพาธใหม่
      await fileImage.copy(newImagePath);

      var checkInDB = await db.query(field_tableName,
          where: "$field_asset = ? AND $field_plan = ?",
          whereArgs: [assetValue, planValue],
          limit: 1);

      if (checkInDB.isEmpty) {
        var result = await db.insert(
          field_tableName, // Table name
          {
            filed_name_image: imageFileName,
            field_plan: planValue,
            field_asset: assetValue,
            field_image_file_path: newImagePath, // Store the path as a string
            field_created_date:
                DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
          }, // Column names and values
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        if (result != 0) {
          CustomBotToast.showSuccess(
              appLocalization.localizations.upload_image_success);
          return true;
        }
      } else {
        // update
        var result = await db.update(
          field_tableName, // Table name
          {
            filed_name_image: imageFileName,
            field_plan: planValue,
            field_asset: assetValue,
            field_image_file_path: newImagePath, // Store the path as a string
            field_created_date:
                DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
          }, // Column names and values
          where: "$field_asset = ? AND $field_plan = ?",
          whereArgs: [assetValue, planValue],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        if (result != 0) {
          CustomBotToast.showSuccess(
              appLocalization.localizations.update_image_success);
          return true;
        }
      }

      return false;
    } catch (e, s) {
      print("Error: $e");
      print("Stack trace: $s");
      return false;
    }
  }

  Future<List<ViewGalleryModel>> getImage(
      {int limit = 100, int offset = 0}) async {
    final db = await appDb.database;
    final List<ViewGalleryModel> imageReturn = [];
    bool hasMoreData = true;

    while (hasMoreData) {
      final result = await db.query(
        field_tableName,
        limit: limit,
        offset: offset,
      );

      if (result.isEmpty) {
        hasMoreData = false;
        break;
      }

      for (var json in result) {
        String planStr = json[field_plan].toString();
        String assetStr = json[field_asset].toString();
        String imageFile = json[field_image_file_path].toString();
        String createdDate = json[field_created_date] as String;

        imageReturn.add(ViewGalleryModel(
          plan: planStr,
          asset: assetStr,
          imageFile: imageFile,
          createdDate: createdDate,
        ));
      }

      offset += limit;
    }

    return imageReturn;
  }
}
