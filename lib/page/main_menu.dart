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

  // Define a consistent color palette
  final Color primaryColor = Color(0xFF2E7D32); // Deep green
  final Color secondaryColor = Color(0xFF81C784); // Light green
  final Color accentColor = Color(0xFFFFD54F); // Amber accent
  final Color backgroundColor = Color(0xFFF5F5F5); // Light background
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF333333);
  final Color subtitleColor = Color(0xFF757575);

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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.8),
                secondaryColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      children: [
                        // _buildWelcomeSection(),
                        const SizedBox(height: 24),
                        Expanded(
                          child: _buildMenuGrid(),
                        ),
                      ],
                    ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  'AMS Express',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _changeLanguage,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.language, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        Provider.of<LocaleNotifier>(context)
                            .locale
                            .languageCode
                            .toUpperCase(),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
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

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to AMS Express', // Fixed hardcoded string
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Provider.of<LocaleNotifier>(context).locale.languageCode == 'en'
                ? 'Please select an option below'
                : 'กรุณาเลือกตัวเลือกด้านล่าง', // Added both languages
            style: TextStyle(
              fontSize: 16,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                height: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [secondaryColor, primaryColor],
                    stops: [0, _animationController.value],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    // Create a coordinated color palette for menu items
    final List<Map<String, dynamic>> menuColorSchemes = [
      {
        'bgColor': Color(0xFFE0F7FA), // Cyan light
        'iconColor': Color(0xFF00ACC1), // Cyan
      },
      {
        'bgColor': Color(0xFFF1F8E9), // Light green light
        'iconColor': Color(0xFF7CB342), // Light green
      },
      {
        'bgColor': Color(0xFFFFF8E1), // Amber light
        'iconColor': Color(0xFFFFB300), // Amber
      },
    ];

    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      children: [
        _buildMenuItem(
          title: appLocalization.localizations.menu_import,
          lottiePath: 'assets/lotties/importLottie.json',
          onTap: () => Navigator.pushNamed(context, Routes.import),
          color: menuColorSchemes[0]['bgColor'],
          iconColor: menuColorSchemes[0]['iconColor'],
        ),
        _buildMenuItem(
          title: appLocalization.localizations.menu_count,
          lottiePath: 'assets/lotties/scan.json',
          onTap: () => Navigator.pushNamed(context, Routes.select_plan),
          color: menuColorSchemes[1]['bgColor'],
          iconColor: menuColorSchemes[1]['iconColor'],
        ),
        _buildMenuItem(
          title: appLocalization.localizations.menu_report,
          lottiePath: 'assets/lotties/report.json',
          onTap: () => Navigator.pushNamed(context, Routes.report),
          color: menuColorSchemes[2]['bgColor'],
          iconColor: menuColorSchemes[2]['iconColor'],
        ),
        // _buildMenuItem(
        //   title: 'Storage',
        //   lottiePath: 'assets/lotties/storage.json',
        //   onTap: () {
        //     // Add your action or new route here
        //   },
        //   color: Colors.green.shade100,
        //   iconColor: Colors.green.shade700,
        // ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String lottiePath,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Positioned(
              //   right: -20,
              //   bottom: -20,
              //   child: Container(
              //     height: 100,
              //     width: 100,
              //     decoration: BoxDecoration(
              //       color: color,
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      height: 60,
                      width: 60,
                      child: Lottie.asset(
                        lottiePath,
                        repeat: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: iconColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Provider.of<LocaleNotifier>(context)
                                      .locale
                                      .languageCode ==
                                  'en'
                              ? 'Tap to access'
                              : 'แตะเพื่อเข้าถึง', // Added both languages
                          style: TextStyle(
                            fontSize: 12,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Text(
        "Version $appVersion",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: subtitleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
