// To parse this JSON data, do
//
//     final countEventModel = countEventModelFromJson(jsonString);

import 'dart:convert';

CountModelEvent countEventModelFromJson(String str) =>
    CountModelEvent.fromJson(json.decode(str));

String countEventModelToJson(CountModelEvent data) =>
    json.encode(data.toJson());

class CountModelEvent {
  String? barcode;
  String? asset;
  String? plan;
  String? location;
  String? department;
  String? name;
  int? costCenter;
  String? statusAsset;
  String? remark;
  String? scanDate;
  bool? is_Success;
  String? qty;
  String? isValidate;

  CountModelEvent({
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
    this.qty,
    this.isValidate,
  });

  factory CountModelEvent.fromJson(Map<String, dynamic> json) =>
      CountModelEvent(
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
