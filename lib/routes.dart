import 'package:ams_express/page/main_menu.dart';
import 'package:ams_express/page/transaction/count_page.dart';
import 'package:ams_express/page/gallery_page.dart';
import 'package:ams_express/page/import/import_page.dart';
import 'package:ams_express/page/import/view_import_page.dart';
import 'package:ams_express/page/loading_page.dart';
import 'package:ams_express/page/report/report_page.dart';
import 'package:ams_express/page/transaction/listplan_page.dart';
import 'package:flutter/material.dart';

import 'page/export_page.dart';
import 'page/setting_page.dart';
import 'page/report/edit_data_count_page.dart';

class Routes {
  static const String home = '/';
  static const String count = '/count';
  static const String gallery = '/gallery';
  static const String report = '/report';
  static const String export = '/export';
  static const String setting = '/setting';
  static const String import = '/import';
  static const String view_detail_import = '/viewImportDetail';
  static const String select_plan = '/selectplan';
  static const String editPage = '/editPage';
  static const String menuPage = '/menuPage';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => Home(),
      import: (context) => ImportPage(),
      count: (context) => CountPage(),
      gallery: (context) => GalleryPage(),
      report: (context) => ReportPage(),
      export: (context) => ExportPage(),
      setting: (context) => SettingPage(),
      view_detail_import: (context) => ViewImportPage(),
      select_plan: (context) => ListPlanPage(),
      editPage: (context) => EditDataCountPage(),
      menuPage: (context) => MenuPage(),
    };
  }
}

class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static const String resetColor = '\x1B[0m';
  static const String redColor = '\x1B[31m';
  static const String greenColor = '\x1B[32m';
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      print('${greenColor}Navigating to ${route.settings.name}$resetColor');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is PageRoute) {
      print(
          '${redColor}Navigating back from ${route.settings.name}$resetColor');
    }
    if (previousRoute is PageRoute) {
      print(
          '${greenColor}Navigating back to ${previousRoute.settings.name}$resetColor');
    }
  }
}
