// To parse this JSON data, do
//
//     final viewReportListPlan = viewReportListPlanFromJson(jsonString);

import 'dart:convert';

ViewReportDropdownPlanModel viewReportListPlanFromJson(String str) =>
    ViewReportDropdownPlanModel.fromJson(json.decode(str));

String viewReportListPlanToJson(ViewReportDropdownPlanModel data) =>
    json.encode(data.toJson());

class ViewReportDropdownPlanModel {
  String? plan;
  int? uncheck;
  int? check;

  ViewReportDropdownPlanModel({
    this.plan,
    this.uncheck,
    this.check,
  });

  factory ViewReportDropdownPlanModel.fromJson(Map<String, dynamic> json) =>
      ViewReportDropdownPlanModel(
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
