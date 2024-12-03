import 'package:ams_express/services/database/gallery_db.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:flutter/foundation.dart';

class ExportModel {
  String? plan;
  String? asset;
  String? description;
  String? costCenter;
  String? capitalizedOn;
  String? location;
  String? department;
  String? ownerName;
  String? userDef1;
  String? userDef2;
  String? statusCheck;
  String? statusAsset;
  String? scanDate;
  String? countLocation;
  String? countDepartment;
  String? remark;
  String? assetNotInPlan;
  Uint8List? image;

  ExportModel({
    this.plan,
    this.asset,
    this.description,
    this.costCenter,
    this.capitalizedOn,
    this.location,
    this.department,
    this.ownerName,
    this.userDef1,
    this.userDef2,
    this.statusCheck,
    this.statusAsset,
    this.scanDate,
    this.countLocation,
    this.countDepartment,
    this.remark,
    this.assetNotInPlan,
    this.image,
  });

  factory ExportModel.fromJson(Map<String, dynamic> json) {
    return ExportModel(
      plan: json[ImportDB.field_plan],
      asset: json[ImportDB.field_asset],
      description: json[ImportDB.field_description],
      costCenter: json[ImportDB.field_costCenter],
      capitalizedOn: json[ImportDB.field_Capitalized_on],
      location: json[ImportDB.field_location],
      department: json[ImportDB.field_department],
      ownerName: json[ImportDB.field_asset_Owner],
      userDef1: json[ImportDB.field_user_def_1],
      userDef2: json[ImportDB.field_user_def_2],
      statusCheck: json[ImportDB.field_status_check],
      statusAsset: json[ImportDB.field_status_assets],
      scanDate: json[ImportDB.field_scan_date],
      countLocation: json[ImportDB.field_count_location],
      countDepartment: json[ImportDB.field_count_department],
      remark: json[ImportDB.field_remark],
      assetNotInPlan: json[ImportDB.field_asset_not_in_plan],
      image: json[GalleryDB.field_image_file_path],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ImportDB.field_plan: plan,
      ImportDB.field_asset: asset,
      ImportDB.field_description: description,
      ImportDB.field_costCenter: costCenter,
      ImportDB.field_Capitalized_on: capitalizedOn,
      ImportDB.field_location: location,
      ImportDB.field_department: department,
      ImportDB.field_asset_Owner: ownerName,
      ImportDB.field_user_def_1: userDef1,
      ImportDB.field_user_def_2: userDef2,
      ImportDB.field_status_check: statusCheck,
      ImportDB.field_status_assets: statusAsset,
      ImportDB.field_scan_date: scanDate,
      ImportDB.field_count_location: countLocation,
      ImportDB.field_count_department: countDepartment,
      ImportDB.field_remark: remark,
      ImportDB.field_asset_not_in_plan: assetNotInPlan,
      GalleryDB.field_image_file_path: image,
    };
  }
}
