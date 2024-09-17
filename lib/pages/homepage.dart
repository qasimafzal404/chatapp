import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/navigation_services.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GetIt getit = GetIt.instance;

  late AuthServices _authServices;
  late NavigationService _navigationService;
   late AlertServices _alertservices;
 @override
  void initState() {
  super.initState();
  _authServices = getit.get<AuthServices>();
  _navigationService = getit.get<NavigationService>();
   _alertservices = getit.get<AlertServices>();
   _authServices.authStateChangesStream().listen((user) {
      if (user == null) {
        // If user is logged out, navigate to login page
        _navigationService.pushNamedReplacement("/login");
      }
    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authServices.logout();
              if(result){
                _navigationService.pushNamedReplacement("/login"); 
               _alertservices.showToast(text: "Logout Successfuly !" , icon: Icons.check);
              }
            },
            icon: const Icon(Icons.logout_outlined),
            color: const Color.fromARGB(255, 125, 31, 24),
          )
        ],
      ),
    );
  }
}
