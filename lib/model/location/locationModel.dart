// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  String? location;

  LocationModel({
    this.location,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        location: json["Location"],
      );

  Map<String, dynamic> toJson() => {
        "Location": location,
      };
}
