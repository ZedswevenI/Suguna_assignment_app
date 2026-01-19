import 'package:get_it/get_it.dart';
// Import API services here

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static void setupServices() {
    // Register API services as singletons
    // getIt.registerLazySingleton<AuthApiService>(() => AuthApiService());
  }

  static T get<T extends Object>() {
    return getIt.get<T>();
  }
}
