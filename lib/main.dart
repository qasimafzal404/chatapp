import 'package:chatapp/Services/navigation_services.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/utils.dart'; // Use the correct setup functions from utils
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
 await setup(); // Register your services
  runApp(MyApp());
}
Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}
// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
      late NavigationService _navigationService;
      late AuthServices _authService;
   MyApp({super.key}   
   ){
   
        _navigationService = _getIt.get<NavigationService>();
        _authService = _getIt.get<AuthServices>();
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      // ignore: unnecessary_null_comparison
      initialRoute: _authService.user != null ? "/Homepage" : "/login",
      routes: _navigationService.routes,
    );
  }
}

