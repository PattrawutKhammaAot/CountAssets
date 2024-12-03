import 'dart:convert';

import 'package:ams_express/main.dart';
import 'package:ams_express/model/location/locationModel.dart';
import 'package:ams_express/services/database/import_db.dart';

class LocationDB {
  String tableName = ImportDB.field_tableName;

  Future<List<LocationModel>> getLocation() async {
    final db = await appDb.database;
    // Fetch data from the database
    final result = await db
        .query(tableName, distinct: true, columns: [ImportDB.field_location]);
    List<LocationModel> newItems = [];
    for (var json in result) {
      newItems.add(LocationModel.fromJson(json));
    }

    return newItems;
  }
}
