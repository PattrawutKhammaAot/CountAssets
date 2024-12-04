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
  int? sum_Uncheck;
  int? sum_Check;

  ViewReportDropdownPlanModel({
    this.plan,
    this.sum_Uncheck,
    this.sum_Check,
  });

  factory ViewReportDropdownPlanModel.fromJson(Map<String, dynamic> json) =>
      ViewReportDropdownPlanModel(
        plan: json["Plan"],
        sum_Uncheck: json["Uncheck"],
        sum_Check: json["Check"],
      );

  Map<String, dynamic> toJson() => {
        "Plan": plan,
        "Uncheck": sum_Uncheck,
        "Check": sum_Check,
      };
}
