// To parse this JSON data, do
//
//     final viewReportEditModel = viewReportEditModelFromJson(jsonString);

import 'dart:convert';

import '../../services/database/import_db.dart';

ViewReportEditModel viewReportEditModelFromJson(String str) =>
    ViewReportEditModel.fromJson(json.decode(str));

String viewReportEditModelToJson(ViewReportEditModel data) =>
    json.encode(data.toJson());

class ViewReportEditModel {
  String? description;
  String? costCenter;
  String? cap;
  String? location;
  String? departmen;
  String? assetOwner;
  String? createdDate;
  String? statusCheck;
  String? statusAsset;
  String? countLocation;
  String? countDepartment;
  String? remark;
  String? statusPlan;
  String? scanDate;
  String? qty;

  ViewReportEditModel(
      {this.description,
      this.costCenter,
      this.cap,
      this.location,
      this.departmen,
      this.assetOwner,
      this.createdDate,
      this.statusCheck,
      this.statusAsset,
      this.countLocation,
      this.countDepartment,
      this.remark,
      this.statusPlan,
      this.scanDate,
      this.qty});

  factory ViewReportEditModel.fromJson(Map<String, dynamic> json) =>
      ViewReportEditModel(
          description: json[ImportDB.field_description],
          costCenter: json[ImportDB.field_costCenter],
          cap: json[ImportDB.field_Capitalized_on],
          location: json[ImportDB.field_location],
          departmen: json[ImportDB.field_department],
          assetOwner: json[ImportDB.field_asset_Owner],
          createdDate: json[ImportDB.field_created_date],
          statusCheck: json[ImportDB.field_status_check],
          statusAsset: json[ImportDB.field_status_assets],
          countLocation: json[ImportDB.field_count_location],
          countDepartment: json[ImportDB.field_count_department],
          remark: json[ImportDB.field_remark],
          statusPlan: json[ImportDB.field_status_plan],
          scanDate: json[ImportDB.field_scan_date],
          qty: json[ImportDB.field_qty]);

  Map<String, dynamic> toJson() => {
        "description": description,
        "costCenter": costCenter,
        "cap": cap,
        "location": location,
        "departmen": departmen,
        "assetOwner": assetOwner,
        "created_date": createdDate,
        "status_check": statusCheck,
        "status_Asset": statusAsset,
        "count_location": countLocation,
        "count_department": countDepartment,
        "remark": remark,
        "status_plan": statusPlan,
        "scanDate": scanDate,
      };
}
