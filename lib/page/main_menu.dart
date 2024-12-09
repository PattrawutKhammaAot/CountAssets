import 'dart:io';

import 'package:ams_express/component/custom_botToast.dart';
import 'package:ams_express/extension/color_extension.dart';
import 'package:ams_express/main.dart';
import 'package:ams_express/page/dashboard_page.dart';
import 'package:ams_express/routes.dart';
import 'package:ams_express/services/database/dashboard_db.dart';
import 'package:ams_express/services/localizationService.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../services/theme/theme_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  bool isRefresh = false;
  String appVersion = '';
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DashboardDB.refreshDashboard(context);
    });
    _getAppVersion();
    super.initState();
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.appName);
    setState(() {
      appVersion = packageInfo.version;
    });
    print(appVersion);
    return appVersion;
  }

  void _changeLanguage() {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    if (localeNotifier.locale.languageCode == 'en') {
      localeNotifier.setLocale(Locale('th'));
    } else {
      localeNotifier.setLocale(Locale('en'));
    }
  }

  // Future<void> _getAppVersion() async {
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   setState(() {
  //     appVersion = packageInfo.version;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(248, 255, 255, 255),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Colors.green.shade500,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        child: Image.asset(
                          'assets/images/logoNew.png',
                          height: 60.0,
                          width: 100.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        child: IconButton(
                          icon: const Icon(Icons.language),
                          onPressed: _changeLanguage,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromRGBO(210, 212, 215, 1),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                            context, Routes.import),
                                        child: Container(
                                          height: 125,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade300,
                                                blurRadius: 10,
                                                spreadRadius: 5,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  210, 212, 215, 1),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 5,
                                                right: 0,
                                                left: 0,
                                                bottom: 30,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 40,
                                                  child: Lottie.asset(
                                                      'assets/lotties/importLottie.json',
                                                      repeat: true,
                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 1,
                                                left: 1,
                                                child: Center(
                                                  child: Text(
                                                    appLocalization
                                                        .localizations
                                                        .menu_import,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                            context, Routes.select_plan),
                                        child: Container(
                                          height: 125,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade300,
                                                blurRadius: 10,
                                                spreadRadius: 5,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  210, 212, 215, 1),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 5,
                                                right: 0,
                                                left: 0,
                                                bottom: 30,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 40,
                                                  child: Lottie.asset(
                                                      'assets/lotties/scan.json',
                                                      repeat: true,
                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 1,
                                                left: 1,
                                                child: Center(
                                                  child: Text(
                                                    appLocalization
                                                        .localizations
                                                        .menu_count,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.report),
                        child: Container(
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromRGBO(210, 212, 215, 1),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 125,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade300,
                                                blurRadius: 10,
                                                spreadRadius: 5,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  210, 212, 215, 1),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 5,
                                                right: 0,
                                                left: 0,
                                                bottom: 30,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 40,
                                                  child: Lottie.asset(
                                                      'assets/lotties/report.json',
                                                      repeat: true,
                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 1,
                                                left: 1,
                                                child: Center(
                                                  child: Text(
                                                    appLocalization
                                                        .localizations
                                                        .menu_report,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Version $appVersion",
                  style: TextStyle(color: Colors.white),
                ),
              ]),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    right: 1,
                    bottom: 1,
                    left: 1,
                    top: 1,
                    child: Lottie.asset('assets/lotties/storage.json',
                        fit: BoxFit.fill, repeat: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String imagePath;
  final String text;
  final String routeName;
  final Function() onPressed;

  const MenuItem({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.routeName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 50.0,
              width: 50.0,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(60, 60, 60, 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
