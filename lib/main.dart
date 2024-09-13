import 'package:chatapp/pages/login.dart';
import 'package:chatapp/utils.dart'; // Use the correct setup functions from utils
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
 await setup(); // Register your services
  runApp(const MyApp());
}
Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const Login(),
    );
  }
}

