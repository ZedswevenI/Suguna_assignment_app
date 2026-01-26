import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/routes/route_config.dart';
import 'package:suguna_assignment_app/core/services/service_locator.dart';
import 'package:suguna_assignment_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TeXRenderingServer.start();

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
    return GetMaterialApp(
      title: 'Suguna Assignment App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      getPages: RouteConfig.getPages(),
    );
  }
}
