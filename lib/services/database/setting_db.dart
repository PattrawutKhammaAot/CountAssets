import 'package:ams_express/component/custom_botToast.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/services/database/dashboard_db.dart';
import 'package:ams_express/services/database/gallery_db.dart';
import 'package:ams_express/services/database/import_db.dart';

class SettingsDB {
  Future<void> deleteAllData(context) async {
    final db = await appDb.database;
    final result = await db.delete(ImportDB.field_tableName);
    await deleteAllImage(context);
    if (result != 0) {
      DashboardDB.refreshDashboard(context);
      CustomBotToast.showSuccess(appLocalization.localizations.delete_all_Data);
      await ImportDB().clearCounter();
    } else {
      final checkIsEmptyDB = await db.query(ImportDB.field_tableName);
      if (checkIsEmptyDB.isEmpty) {
        CustomBotToast.showError(appLocalization.localizations.no_data);
      } else {
        CustomBotToast.showError(
            appLocalization.localizations.failed_to_delete);
      }
    }
  }

  Future<void> deleteAllImage(context) async {
    final db = await appDb.database;
    final result = await db.delete(GalleryDB.field_tableName);
    if (result != 0) {
      DashboardDB.refreshDashboard(context);
      CustomBotToast.showSuccess(
          appLocalization.localizations.delete_all_images);
    } else {
      final checkIsEmptyDB = await db.query(GalleryDB.field_tableName);
      if (checkIsEmptyDB.isEmpty) {
        CustomBotToast.showError(appLocalization.localizations.no_image);
      } else {
        CustomBotToast.showError(
            appLocalization.localizations.failed_to_delete);
      }
    }
  }
}
