// To parse this JSON data, do
//
//     final viewSumStatusModel = viewSumStatusModelFromJson(jsonString);

import 'dart:convert';

ViewSumStatusModel viewSumStatusModelFromJson(String str) =>
    ViewSumStatusModel.fromJson(json.decode(str));

String viewSumStatusModelToJson(ViewSumStatusModel data) =>
    json.encode(data.toJson());

class ViewSumStatusModel {
  int? uncheck;
  int? checked;
  int? allitem;

  ViewSumStatusModel({
    this.uncheck,
    this.checked,
    this.allitem,
  });

  factory ViewSumStatusModel.fromJson(Map<String, dynamic> json) =>
      ViewSumStatusModel(
        uncheck: json["uncheck"],
        checked: json["checked"],
        allitem: json["allitem"],
      );

  Map<String, dynamic> toJson() => {
        "uncheck": uncheck,
        "checked": checked,
        "allitem": allitem,
      };
}
