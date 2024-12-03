import 'package:flutter/foundation.dart';

class ViewGalleryModel {
  String? plan;
  String? asset;
  String? imageFile;
  String? createdDate;

  ViewGalleryModel({
    this.plan,
    this.asset,
    this.imageFile,
    this.createdDate,
  });

  // Create a GalleryModel from a map
  factory ViewGalleryModel.fromMap(Map<String, dynamic> map) {
    return ViewGalleryModel(
      plan: map['plan'],
      asset: map['asset'],
      imageFile: map['image_file'],
      createdDate: map['created_date'],
    );
  }

  // Convert a GalleryModel to a map
  Map<String, dynamic> toMap() {
    return {
      'plan': plan,
      'asset': asset,
      'image_file': imageFile,
      'created_date': createdDate,
    };
  }
}
