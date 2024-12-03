// To parse this JSON data, do
//
//     final viewReportListDataModel = viewReportListDataModelFromJson(jsonString);

import 'dart:convert';

ViewReportListDataModel viewReportListDataModelFromJson(String str) =>
    ViewReportListDataModel.fromJson(json.decode(str));

String viewReportListDataModelToJson(ViewReportListDataModel data) =>
    json.encode(data.toJson());

class ViewReportListDataModel {
  String? asset;
  String? description;
  int? costCenter;
  String? capitalizedOn;
  String? location;
  String? department;
  String? assetOwner;
  String? userDef1;
  String? userDef2;
  String? status_check;
  String? status_asset;

  ViewReportListDataModel({
    this.asset,
    this.description,
    this.costCenter,
    this.capitalizedOn,
    this.location,
    this.department,
    this.assetOwner,
    this.userDef1,
    this.userDef2,
    this.status_check,
    this.status_asset,
  });

  factory ViewReportListDataModel.fromJson(Map<String, dynamic> json) =>
      ViewReportListDataModel(
        asset: json["assets"],
        description: json["description"],
        costCenter: json["costCenter"],
        capitalizedOn: json["capitalizedOn"],
        location: json["location"],
        department: json["department"],
        assetOwner: json["assetsOwner"],
        userDef1: json["user_def1"],
        userDef2: json["user_def2"],
        status_check: json["status_check"],
        status_asset: json["status_assets"],
      );

  Map<String, dynamic> toJson() => {
        "assets": asset,
        "description": description,
        "costCenter": costCenter,
        "capitalizedOn": capitalizedOn,
        "location": location,
        "department": department,
        "assetsOwner": assetOwner,
        "user_def1": userDef1,
        "user_def2": userDef2,
        "status_check": status_check,
        "status_assets": status_asset,
      };
}
