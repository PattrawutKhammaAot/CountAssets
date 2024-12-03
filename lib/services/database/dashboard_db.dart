import 'package:ams_express/page/dashboard_page.dart';
import 'package:ams_express/services/database/gallery_db.dart';
import 'package:ams_express/services/database/import_db.dart';
import 'package:ams_express/services/database/quickType.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';
import '../../model/dashboard/view_dashboard_model.dart';

class DashboardDB {
  String master = ImportDB.field_tableName;
  String gallery = GalleryDB.field_tableName;
  Future<List<ViewDashboardModel>> getListDropdown() async {
    final db = await appDb.database;
    final resultPlan =
        await db.query(master, distinct: true, columns: [ImportDB.field_plan]);

    // Extract the list of plans
    final plans = resultPlan.map((row) => row[ImportDB.field_plan]).toList();

    final List<ViewDashboardModel> planReturn = [];

    for (var plan in plans) {
      final countPlanCheck = await db.rawQuery(
          'SELECT COUNT(*) FROM $master WHERE ${ImportDB.field_status_check} = ? AND ${ImportDB.field_plan} = ?',
          [StatusCheck.status_checked, plan]);

      final countPlanUncheck = await db.rawQuery(
          'SELECT COUNT(*) FROM $master WHERE ${ImportDB.field_status_check} = ? AND ${ImportDB.field_plan} = ?',
          [StatusCheck.status_uncheck, plan]);
      final countPlanImageList = await db.rawQuery(
          'SELECT COUNT(*) FROM $gallery WHERE ${GalleryDB.field_plan} = ?',
          [plan]);
      final countAssetInPlan = await db.rawQuery(
          'SELECT COUNT(*) FROM $master WHERE ${ImportDB.field_plan} = ?',
          [plan]);

      final totalListAsset = Sqflite.firstIntValue(countAssetInPlan);
      final totalImageList = Sqflite.firstIntValue(countPlanImageList);
      final totalCheck = Sqflite.firstIntValue(countPlanCheck);
      final totalUncheck = Sqflite.firstIntValue(countPlanUncheck);

      planReturn.add(ViewDashboardModel(
        sum_asset: totalListAsset,
        plan: plan.toString(),
        uncheck: totalUncheck,
        check: totalCheck,
        image: totalImageList,
      ));
    }

    return planReturn;
  }

  static void refreshDashboard(BuildContext context) {
    Provider.of<DashBoardNotifier>(context, listen: false).refreshDashboard();
  }
}
