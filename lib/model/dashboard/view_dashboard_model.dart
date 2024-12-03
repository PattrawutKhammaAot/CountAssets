// To parse this JSON data, do
//
//     final viewReportListPlan = viewReportListPlanFromJson(jsonString);

import 'dart:convert';

ViewDashboardModel viewReportListPlanFromJson(String str) =>
    ViewDashboardModel.fromJson(json.decode(str));

String viewReportListPlanToJson(ViewDashboardModel data) =>
    json.encode(data.toJson());

class ViewDashboardModel {
  String? plan;
  int? uncheck;
  int? check;
  int? image;
  int? sum_asset;

  ViewDashboardModel({
    this.plan,
    this.uncheck,
    this.check,
    this.image,
    this.sum_asset,
  });

  factory ViewDashboardModel.fromJson(Map<String, dynamic> json) =>
      ViewDashboardModel(
        plan: json["Plan"],
        uncheck: json["Uncheck"],
        check: json["Check"],
      );

  Map<String, dynamic> toJson() => {
        "Plan": plan,
        "Uncheck": uncheck,
        "Check": check,
      };
}
