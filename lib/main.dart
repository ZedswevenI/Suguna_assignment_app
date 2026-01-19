import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suguna_teachers_app/core/routes/route_config.dart';
import 'package:suguna_teachers_app/core/services/service_locator.dart';
import 'package:suguna_teachers_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize services
  ServiceLocator.setupServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'Suguna Student App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerDelegate: RouteConfig.router.routerDelegate,
      routeInformationParser: RouteConfig.router.routeInformationParser,
      routeInformationProvider: RouteConfig.router.routeInformationProvider,
    );
  }
}
