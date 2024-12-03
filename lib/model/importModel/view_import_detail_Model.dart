// To parse this JSON data, do
//
//     final viewImportdetailModel = viewImportdetailModelFromJson(jsonString);

import 'dart:convert';

ViewImportdetailModel viewImportdetailModelFromJson(String str) =>
    ViewImportdetailModel.fromJson(json.decode(str));

String viewImportdetailModelToJson(ViewImportdetailModel data) =>
    json.encode(data.toJson());

class ViewImportdetailModel {
  String? plan;
  String? asset;
  String? description;
  String? costCenter;
  String? capitalizedOn;
  String? location;
  String? department;
  String? assetOwner;
  String? createdDate;
  String? userDef1;
  String? userDef2;
  String? userDef3;
  String? userDef4;

  ViewImportdetailModel({
    this.plan,
    this.asset,
    this.description,
    this.costCenter,
    this.capitalizedOn,
    this.location,
    this.department,
    this.assetOwner,
    this.createdDate,
    this.userDef1,
    this.userDef2,
    this.userDef3,
    this.userDef4,
  });

  factory ViewImportdetailModel.fromJson(Map<String, dynamic> json) =>
      ViewImportdetailModel(
        plan: json["plan"],
        asset: json["asset"],
        description: json["description"],
        costCenter: json["costCenter"],
        capitalizedOn: json["Capitalized_on"],
        location: json["location"],
        department: json["department"],
        assetOwner: json["asset_Owner"],
        createdDate: json["created_date"],
        userDef1: json["user_def_1"],
        userDef2: json["user_def_2"],
        userDef3: json["user_def_3"],
        userDef4: json["user_def_4"],
      );

  Map<String, dynamic> toJson() => {
        "plan": plan,
        "asset": asset,
        "description": description,
        "costCenter": costCenter,
        "Capitalized_on": capitalizedOn,
        "location": location,
        "department": department,
        "asset_Owner": assetOwner,
        "created_date": createdDate,
        "user_def_1": userDef1,
        "user_def_2": userDef2,
        "user_def_3": userDef3,
        "user_def_4": userDef4,
      };
}
