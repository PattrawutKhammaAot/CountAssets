import 'package:ams_express/services/database/gallery_db.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/count_detail_model.dart';
import '../../model/count_master_model.dart';

class DbSqlite {
  static DbSqlite? _dbSqlite;
  static Database? _database;

  DbSqlite._createInstance();

  factory DbSqlite() {
    if (_dbSqlite == null) {
      _dbSqlite = DbSqlite._createInstance();
    }
    return _dbSqlite!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    try {
      String databasesPath = await getDatabasesPath();
      String dbPath = join(databasesPath, 'countOffline.db');

      var database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _createDb,
      );

      return database;
    } catch (e) {
      // String databasesPath = await getDatabasesPath();
      // EasyLoading.showError("$e $databasesPath",
      //     duration: Duration(seconds: 60), dismissOnTap: false);
      throw Exception();
    }
  }
}

void _createDb(Database db, int newVersion) async {
  ImportDB().createTable(db, newVersion);
  GalleryDB().createTable(db, newVersion);
}

// Future createDB() async {
//   try {
//     var databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, myDB);

//     await openDatabase(path, version: versionDB,
//         onCreate: (Database db, int version) async {
//       // When creating the db, create the table
//       await db.execute(
//           'CREATE TABLE t_count_asset_master (count_master_id INTEGER PRIMARY KEY autoincrement,count_code TEXT, count_name TEXT,file_name TEXT, create_date TEXT)');
//       await db.execute(
//           'CREATE TABLE t_count_asset_detail (count_detail_id INTEGER PRIMARY KEY autoincrement,count_master_id INTEGER , asset_code TEXT, asset_name TEXT,cost_center TEXT,cap_date TEXT,location_name TEXT,department_name TEXT,owner_name TEXT,udf_1 TEXT,udf_2 TEXT,status TEXT,remark TEXT,is_check INTEGER,location_check TEXT,department_check TEXT,status_count TEXT,scan_date TEXT,is_plan INTEGER)');
//     });
//   } on DatabaseException catch (de) {
//     print(de);
//   } catch (error) {
//     print(error);
//   }
// }

// Future<List<String>?> selectLocation(int countMasterId) async {
//   try {
//     var db = await openDatabase(myDB);
//     List<Map<String, Object?>> result = await db.rawQuery(
//         'SELECT DISTINCT location_name FROM t_count_asset_detail WHERE count_master_id=?',
//         [countMasterId]);
//     await db.close();
//     return result.map((json) => json.toString()).toList();
//   } on DatabaseException catch (de) {
//     print(de);
//     return null;
//   } catch (error) {
//     print(error);
//     return null;
//   }
// }

// Future<List<String>?> selectDepartment(int countMasterId) async {
//   try {
//     var db = await openDatabase(myDB);
//     final result = await db.rawQuery(
//         'SELECT DISTINCT department_name FROM t_count_asset_detail WHERE count_master_id=?',
//         [countMasterId]);
//     await db.close();
//     return result.map((json) => json.toString()).toList();
//   } on DatabaseException catch (de) {
//     print(de);
//     return null;
//   } catch (error) {
//     print(error);
//     return null;
//   }
// }

// Future<List<CountMaster>?> selectCountMaster() async {
//   try {
//     var db = await openDatabase(myDB);
//     final result =
//         await db.query('t_count_asset_master', orderBy: "count_code ASC");
//     await db.close();
//     return result.map((json) => CountMaster.fromJson(json)).toList();
//   } on DatabaseException catch (de) {
//     print(de);
//     return null;
//   } catch (error) {
//     print(error);
//     return null;
//   }
// }

// Future<int> countRowPlan(int? count_master_id) async {
//   try {
//     var db = await openDatabase(myDB);
//     int? count = 0;
//     if (count_master_id == null || count_master_id == 0) {
//       count = Sqflite.firstIntValue(
//           await db.rawQuery('SELECT COUNT(*) FROM t_count_asset_detail'));
//     } else {
//       count = Sqflite.firstIntValue(await db.rawQuery(
//           'SELECT COUNT(*) FROM t_count_asset_detail WHERE count_master_id=?',
//           [count_master_id]));
//     }

//     await db.close();
//     return count ?? 0;
//   } on DatabaseException catch (de) {
//     print(de);
//     return 0;
//   } catch (error) {
//     print(error);
//     return 0;
//   }
// }

//   Future<int> scanAsset(CountDetail countDT) async {
//     var db = await openDatabase(myDB);

//     // คืนค่าเป็นตัวเลขจำนวนรายการที่มีการเปลี่ยนแปลง
//     return db.update(
//       't_count_asset_detail',
//       countDT.toJson(),
//       where: 'count_detail_id = ?',
//       whereArgs: [countDT.count_detail_id],
//     );
//   }

//   Future<int> delete(int id) async {
//     var db = await openDatabase(myDB); // อ้างอิงฐานข้อมูล

//     // คืนค่าเป็นตัวเลขจำนวนรายการที่มีการเปลี่ยนแปลง
//     return db.delete(
//       't_count_asset_master',
//       where: '${CountMasterFields.count_master_id} = ?',
//       whereArgs: [id],
//     );
//   }
// }
