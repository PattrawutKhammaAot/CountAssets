// To parse this JSON data, do
//
//     final viewListCount = viewListCountFromJson(jsonString);

import 'dart:convert';

ViewListCountModel viewListCountFromJson(String str) =>
    ViewListCountModel.fromJson(json.decode(str));

String viewListCountToJson(ViewListCountModel data) =>
    json.encode(data.toJson());

class ViewListCountModel {
  String? plan;
  String? createdDate;
  String? statusPlan;
  String? description;

  ViewListCountModel({
    this.plan,
    this.createdDate,
    this.statusPlan,
    this.description,
  });

  factory ViewListCountModel.fromJson(Map<String, dynamic> json) =>
      ViewListCountModel(
        plan: json["Plan"],
        createdDate: json["Created_date"],
        statusPlan: json["status_plan"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "Plan": plan,
        "Created_date": createdDate,
        "status_plan": statusPlan,
        "description": description,
      };
}
