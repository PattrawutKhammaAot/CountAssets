import 'dart:convert';

ViewImportModel viewImportModelFromJson(String str) =>
    ViewImportModel.fromJson(json.decode(str));

String viewImportModelToJson(ViewImportModel data) =>
    json.encode(data.toJson());

class ViewImportModel {
  String? plan;
  String? createdDate;
  String? qtyAssets;

  ViewImportModel({
    this.plan,
    this.createdDate,
    this.qtyAssets,
  });

  factory ViewImportModel.fromJson(Map<String, dynamic> json) =>
      ViewImportModel(
        plan: json["plan"],
        createdDate: json["created_date"],
        qtyAssets: json["qty_assets"],
      );

  Map<String, dynamic> toJson() => {
        "plan": plan,
        "created_date": createdDate,
        "qty_assets": qtyAssets,
      };
}
