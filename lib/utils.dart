import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/media_services.dart';
import 'package:chatapp/Services/navigation_services.dart';
import 'package:chatapp/Services/storage_services.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/auth/auth_services.dart';

// Initialize Firebase using the platform-specific options
Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

// Register services like AuthService
Future<void> registerServices() async {
  final getIt = GetIt.instance;
  getIt.registerSingleton<AuthServices>(AuthServices());
 getIt.registerSingleton<NavigationService>(NavigationService());
 getIt.registerSingleton<AlertServices>(AlertServices());
  getIt.registerSingleton<MediaServices>(MediaServices());
   getIt.registerSingleton<StorageServices>(StorageServices());
   getIt.registerSingleton<DatabaseService>(DatabaseService());

}
