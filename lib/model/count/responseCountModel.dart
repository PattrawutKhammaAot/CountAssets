// To parse this JSON data, do
//
//     final countEventModel = countEventModelFromJson(jsonString);

import 'dart:convert';

ResponseCountModel countEventModelFromJson(String str) =>
    ResponseCountModel.fromJson(json.decode(str));

String countEventModelToJson(ResponseCountModel data) =>
    json.encode(data.toJson());

class ResponseCountModel {
  String? barcode;
  String? asset;

  String? plan;
  String? location;
  String? department;
  String? name;
  String? costCenter;
  String? statusAsset;
  String? qty;
  String? cap_date;
  String? remark;
  String? scanDate;
  String? check;
  bool? is_Success;
  String? isValidate;

  ResponseCountModel({
    this.plan,
    this.asset,
    this.barcode,
    this.location,
    this.department,
    this.name,
    this.costCenter,
    this.statusAsset,
    this.remark,
    this.scanDate,
    this.is_Success,
    this.isValidate,
    this.qty,
    this.cap_date,
    this.check,
  });

  factory ResponseCountModel.fromJson(Map<String, dynamic> json) =>
      ResponseCountModel(
        plan: json["plan"],
        barcode: json["barcode"],
        location: json["location"],
        department: json["department"],
        name: json["name"],
        costCenter: json["costCenter"],
        statusAsset: json["status_asset"],
        remark: json["remark"],
        scanDate: json["scanDate"],
        is_Success: json["is_Success"],
        isValidate: json["isValidate"],
      );

  Map<String, dynamic> toJson() => {
        "plan": plan,
        "barcode": barcode,
        "location": location,
        "department": department,
        "name": name,
        "costCenter": costCenter,
        "status_asset": statusAsset,
        "remark": remark,
        "scanDate": scanDate,
        "is_Success": is_Success,
        "isValidate": isValidate,
      };
}
