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
import 'package:permission_handler/permission_handler.dart';
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
  late AnimationController _animationController;

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  // Elegant Soft Blue Color Palette
  final Color primaryColor = Color(0xFF2196F3); // Soft vibrant blue
  final Color primaryLightColor = Color(0xFF42A5F5); // Light blue
  final Color secondaryColor = Color(0xFF64B5F6); // Lighter blue
  final Color accentColor = Color(0xFF00BCD4); // Cyan accent
  final Color backgroundColor = Color(0xFFF5F9FF); // Very light blue background
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF1565C0); // Rich blue text
  final Color subtitleColor =
      Color(0xFF90CAF9); // Soft light blue for subtitles
  final Color gradientStart = Color(0xFF64B5F6); // Start with light blue
  final Color gradientMiddle = Color(0xFF42A5F5); // Medium blue
  final Color gradientEnd = Color(0xFFBBDEFB); // End with very light blue

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DashboardDB.refreshDashboard(context);
    });
    _getAppVersion();
    reqpermission();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  reqpermission() async {
    await Permission.storage.request();
    await Permission.camera.request();
    await appDb.initializeDatabase();
  }

  void _changeLanguage() {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    if (localeNotifier.locale.languageCode == 'en') {
      localeNotifier.setLocale(Locale('th'));
    } else {
      localeNotifier.setLocale(Locale('en'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: _buildMenuGrid(),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.inventory_2_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Count Assets',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withOpacity(0.2),
                  secondaryColor.withOpacity(0.2)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: _changeLanguage,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.language_rounded,
                          color: primaryColor, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        Provider.of<LocaleNotifier>(context)
                            .locale
                            .languageCode
                            .toUpperCase(),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    // Modern blue gradient color schemes for menu items
    final List<Map<String, dynamic>> menuColorSchemes = [
      {
        'bgColor': Color(0xFFE3F2FD), // Light blue
        'iconColor': Color(0xFF1976D2), // Blue
        'gradientColors': [Color(0xFF64B5F6), Color(0xFF42A5F5)],
      },
      {
        'bgColor': Color(0xFFE0F7FA), // Cyan light
        'iconColor': Color(0xFF0097A7), // Cyan
        'gradientColors': [Color(0xFF4DD0E1), Color(0xFF00BCD4)],
      },
      {
        'bgColor': Color(0xFFE8EAF6), // Indigo light
        'iconColor': Color(0xFF3949AB), // Indigo
        'gradientColors': [Color(0xFF7986CB), Color(0xFF5C6BC0)],
      },
    ];

    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        _buildMenuItem(
          title: appLocalization.localizations.menu_import,
          lottiePath: 'assets/lotties/importLottie.json',
          onTap: () => Navigator.pushNamed(context, Routes.import),
          color: menuColorSchemes[0]['bgColor'],
          iconColor: menuColorSchemes[0]['iconColor'],
          gradientColors: menuColorSchemes[0]['gradientColors'],
        ),
        _buildMenuItem(
          title: appLocalization.localizations.menu_count,
          lottiePath: 'assets/lotties/scan.json',
          onTap: () => Navigator.pushNamed(context, Routes.select_plan),
          color: menuColorSchemes[1]['bgColor'],
          iconColor: menuColorSchemes[1]['iconColor'],
          gradientColors: menuColorSchemes[1]['gradientColors'],
        ),
        _buildMenuItem(
          title: appLocalization.localizations.menu_report,
          lottiePath: 'assets/lotties/report.json',
          onTap: () => Navigator.pushNamed(context, Routes.report),
          color: menuColorSchemes[2]['bgColor'],
          iconColor: menuColorSchemes[2]['iconColor'],
          gradientColors: menuColorSchemes[2]['gradientColors'],
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String lottiePath,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
    required List<Color> gradientColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  // Gradient background accent
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: iconColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          height: 65,
                          width: 65,
                          child: Lottie.asset(
                            lottiePath,
                            repeat: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Version $appVersion",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
