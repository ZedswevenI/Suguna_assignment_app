#!/bin/bash

# Suguna Student App - Project Structure Creator
# This script creates the complete project structure with all necessary files

set -e

PROJECT_NAME="suguna_teachers_app"
PROJECT_DIR="./${PROJECT_NAME}"

echo "🚀 Creating Flutter project structure..."

# Create project directory
mkdir -p "${PROJECT_DIR}"
cd "${PROJECT_DIR}"

# Initialize Flutter project
flutter create . --org com.suguna --project-name ${PROJECT_NAME}

# Create lib directory structure
echo "📁 Creating directory structure..."

# Core directories
mkdir -p lib/core/{constants,resources,routes,services,theme,utils,widgets}

# Module directories - Only Home module
mkdir -p lib/modules/home

# Create bindings, controllers, views for home module
mkdir -p lib/modules/home/{bindings,controllers,views}

echo "✅ Directory structure created!"

# Update pubspec.yaml
echo "📦 Updating dependencies..."

cat > pubspec.yaml << 'EOF'
name: suguna_student_app
description: "A new Flutter project."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ^3.10.1

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  
  # State Management
  get: ^4.6.6
  
  # Routing
  go_router: ^14.2.7
  
  # Dependency Injection
  get_it: ^7.7.0
  
  # HTTP Client
  dio: ^5.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
EOF

echo "✅ pubspec.yaml created!"

# Create core constants
echo "📝 Creating core files..."

cat > lib/core/constants/app_constants.dart << 'EOF'
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const Duration timeout = Duration(seconds: 30);
  
  // Add more constants as needed
}
EOF

# Create app strings
cat > lib/core/resources/app_strings.dart << 'EOF'
class AppStrings {
  // App Info
  static const String appName = 'Suguna Student App';


  // Home
  static const String home = 'Home';

  // Common
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String info = 'Info';
  static const String na = 'N/A';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String update = 'Update';
  static const String submit = 'Submit';
  static const String back = 'Back';
  static const String close = 'Close';
}
EOF

# Create app colors
cat > lib/core/theme/app_colors.dart << 'EOF'
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryDark = Color(0xFF3700B3);
  static const Color primaryLight = Color(0xFFBB86FC);
  
  // Accent Colors
  static const Color accent = Color(0xFF03DAC6);
  static const Color accentLight = Color(0xFF66FFF9);
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFB00020);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
}
EOF

# Create app theme
cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:suguna_student_app/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}
EOF

# Create responsive helper
cat > lib/core/utils/responsive_helper.dart << 'EOF'
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double tabletBreakpoint = 600;

  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= tabletBreakpoint;
  }

  static bool isMobile(BuildContext context) {
    return !isTablet(context);
  }

  static EdgeInsets getPadding(BuildContext context) {
    if (isTablet(context)) {
      return const EdgeInsets.all(32);
    }
    return const EdgeInsets.all(16);
  }

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 48);
    }
    return const EdgeInsets.symmetric(horizontal: 24);
  }

  static EdgeInsets getVerticalPadding(BuildContext context) {
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(vertical: 32);
    }
    return const EdgeInsets.symmetric(vertical: 16);
  }

  static double getFontSizeMultiplier(BuildContext context) {
    if (isTablet(context)) {
      return 1.3;
    }
    return 1.0;
  }

  static double getIconSize(BuildContext context, {double baseSize = 48}) {
    if (isTablet(context)) {
      return baseSize * 1.5;
    }
    return baseSize;
  }

  static double getSpacing(BuildContext context, {double baseSpacing = 16}) {
    if (isTablet(context)) {
      return baseSpacing * 1.5;
    }
    return baseSpacing;
  }

  static double getMaxContentWidth(BuildContext context) {
    if (isTablet(context)) {
      return 1000;
    }
    return double.infinity;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    if (isTablet(context)) {
      return 3;
    }
    return 2;
  }
}
EOF

# Create app routes
cat > lib/core/routes/app_routes.dart << 'EOF'
class AppRoutes {
  static const String home = '/home';
}
EOF

# Create route config template
cat > lib/core/routes/route_config.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suguna_student_app/core/routes/app_routes.dart';
// Import bindings and views here

class RouteConfig {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // Add routes here
    ],
  );
}
EOF

# Create base API service
cat > lib/core/services/api_service.dart << 'EOF'
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:suguna_student_app/core/constants/app_constants.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.timeout,
        receiveTimeout: AppConstants.timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      if (response.data == null || response.data.toString().isEmpty) {
        return {'success': true};
      }
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'success': true, 'data': response.data};
    } else {
      throw ApiException(
        message: 'An error occurred',
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  ApiException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final message = error.response?.data?['message'] ?? 'An error occurred';
    return ApiException(message: message, statusCode: statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}
EOF

# Create service locator
cat > lib/core/services/service_locator.dart << 'EOF'
import 'package:get_it/get_it.dart';
// Import API services here

final GetIt ServiceLocator = GetIt.instance;

class ServiceLocator {
  static void setupServices() {
    // Register API services as singletons
    // ServiceLocator.registerLazySingleton<AuthApiService>(() => AuthApiService());
  }

  static T get<T extends Object>() {
    return ServiceLocator.get<T>();
  }
}
EOF

# Create common widgets
cat > lib/core/widgets/app_text.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:suguna_student_app/core/theme/app_colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextDecoration? decoration;

  const AppText(
    this.text, {
    super.key,
    this.style = AppTextStyle.bodyMedium,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = _getTextStyle();
    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }

  TextStyle _getTextStyle() {
    TextStyle baseStyle = _getBaseStyle();
    return baseStyle.copyWith(
      color: color ?? baseStyle.color,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
      fontSize: fontSize ?? baseStyle.fontSize,
      decoration: decoration ?? baseStyle.decoration,
    );
  }

  TextStyle _getBaseStyle() {
    switch (style) {
      case AppTextStyle.headlineLarge:
        return const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.2);
      case AppTextStyle.headlineMedium:
        return const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.2);
      case AppTextStyle.headlineSmall:
        return const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.3);
      case AppTextStyle.titleLarge:
        return const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.3);
      case AppTextStyle.titleMedium:
        return const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);
      case AppTextStyle.titleSmall:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);
      case AppTextStyle.bodyLarge:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary, height: 1.5);
      case AppTextStyle.bodyMedium:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary, height: 1.5);
      case AppTextStyle.bodySmall:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary, height: 1.5);
      case AppTextStyle.labelLarge:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary, height: 1.4);
      case AppTextStyle.labelMedium:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4);
      case AppTextStyle.labelSmall:
        return const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4);
      case AppTextStyle.caption:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary, height: 1.4);
      case AppTextStyle.overline:
        return const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4, letterSpacing: 0.5);
    }
  }

  factory AppText.headlineLarge(String text, {Key? key, TextAlign? textAlign, Color? color, int? maxLines}) {
    return AppText(text, key: key, style: AppTextStyle.headlineLarge, textAlign: textAlign, color: color, maxLines: maxLines);
  }

  factory AppText.headlineMedium(String text, {Key? key, TextAlign? textAlign, Color? color, int? maxLines}) {
    return AppText(text, key: key, style: AppTextStyle.headlineMedium, textAlign: textAlign, color: color, maxLines: maxLines);
  }

  factory AppText.titleLarge(String text, {Key? key, TextAlign? textAlign, Color? color, int? maxLines}) {
    return AppText(text, key: key, style: AppTextStyle.titleLarge, textAlign: textAlign, color: color, maxLines: maxLines);
  }

  factory AppText.titleMedium(String text, {Key? key, TextAlign? textAlign, Color? color, int? maxLines}) {
    return AppText(text, key: key, style: AppTextStyle.titleMedium, textAlign: textAlign, color: color, maxLines: maxLines);
  }

  factory AppText.bodyLarge(String text, {Key? key, TextAlign? textAlign, Color? color, int? maxLines}) {
    return AppText(text, key: key, style: AppTextStyle.bodyLarge, textAlign: textAlign, color: color, maxLines: maxLines);
  }

  factory AppText.bodyMedium(String text, {Key? key, TextAlign? textAlign, Color? color, int? maxLines}) {
    return AppText(text, key: key, style: AppTextStyle.bodyMedium, textAlign: textAlign, color: color, maxLines: maxLines);
  }

  factory AppText.bodySmall(String text, {Key? key, TextAlign? textAlign, Color? color, int? maxLines}) {
    return AppText(text, key: key, style: AppTextStyle.bodySmall, textAlign: textAlign, color: color, maxLines: maxLines);
  }
}

enum AppTextStyle {
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  caption,
  overline,
}
EOF

cat > lib/core/widgets/app_app_bar.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suguna_student_app/core/routes/app_routes.dart';
import 'package:suguna_student_app/core/theme/app_colors.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const AppAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      centerTitle: centerTitle,
      elevation: 0,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ??
                      () {
                        context.go(AppRoutes.home);
                      },
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
EOF

cat > lib/core/widgets/app_rich_text.dart << 'EOF'
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:suguna_student_app/core/widgets/app_text.dart';

class AppRichText extends StatelessWidget {
  final List<AppTextSpan> spans;
  final TextAlign? textAlign;

  const AppRichText({
    super.key,
    required this.spans,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: spans.map((span) {
          final style = _getTextStyle(span.style);
          return TextSpan(
            text: span.text,
            style: style.copyWith(
              color: span.color ?? style.color,
              fontWeight: span.fontWeight ?? style.fontWeight,
            ),
            recognizer: span.onTap != null
                ? (TapGestureRecognizer()..onTap = span.onTap)
                : null,
          );
        }).toList(),
      ),
    );
  }

  TextStyle _getTextStyle(AppTextStyle style) {
    // Use same logic as AppText
    return const TextStyle();
  }
}

class AppTextSpan {
  final String text;
  final AppTextStyle style;
  final Color? color;
  final FontWeight? fontWeight;
  final VoidCallback? onTap;

  AppTextSpan({
    required this.text,
    required this.style,
    this.color,
    this.fontWeight,
    this.onTap,
  });
}
EOF

# Create main.dart template
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_student_app/core/routes/route_config.dart';
import 'package:suguna_student_app/core/services/service_locator.dart';
import 'package:suguna_student_app/core/theme/app_theme.dart';

void main() {
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
EOF

# Create module template files
create_module_files() {
    local module_name=$1
    local module_title=$2
    
    # Controller
    cat > "lib/modules/${module_name}/controllers/${module_name}_controller.dart" << EOF
import 'package:get/get.dart';
import 'package:suguna_student_app/core/resources/app_strings.dart';

class ${module_title}Controller extends GetxController {
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize data
  }
}
EOF

    # Binding
    cat > "lib/modules/${module_name}/bindings/${module_name}_binding.dart" << EOF
import 'package:get/get.dart';
import 'package:suguna_student_app/modules/${module_name}/controllers/${module_name}_controller.dart';

class ${module_title}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ${module_title}Controller());
  }
}
EOF

    # View template
    cat > "lib/modules/${module_name}/views/${module_name}_view.dart" << EOF
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_student_app/core/utils/responsive_helper.dart';
import 'package:suguna_student_app/core/widgets/app_app_bar.dart';
import 'package:suguna_student_app/core/widgets/app_text.dart';
import 'package:suguna_student_app/modules/${module_name}/controllers/${module_name}_controller.dart';

class ${module_title}View extends GetView<${module_title}Controller> {
  const ${module_title}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Home', showBackButton: false),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (ResponsiveHelper.isTablet(context)) {
            return _buildTabletLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return const Center(
      child: AppText('Mobile Layout'),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: const AppText('Tablet Layout'),
      ),
    );
  }
}
EOF
}

# Create home module files
echo "📝 Creating home module files..."

create_module_files "home" "Home"

echo "✅ Home module files created!"

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get

echo ""
echo "✨ Project structure created successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Update route_config.dart with home route"
echo "2. Implement API services in lib/core/services/ (if needed)"
echo "3. Register services in service_locator.dart (if needed)"
echo "4. Implement business logic in home_controller.dart"
echo "5. Complete UI implementation in home_view.dart"
echo ""
echo "🚀 Run: cd ${PROJECT_DIR} && flutter run"

