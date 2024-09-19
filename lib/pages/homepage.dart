import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/navigation_services.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/widgets/chat_tile.dart';
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
  late DatabaseService _databaseService;
  @override
  void initState() {
    super.initState();
    _authServices = getit.get<AuthServices>();
    _navigationService = getit.get<NavigationService>();
    _alertservices = getit.get<AlertServices>();
    _databaseService = getit.get<DatabaseService>();
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
              if (result) {
                _navigationService.pushNamedReplacement("/login");
                _alertservices.showToast(
                    text: "Logout Successfuly !", icon: Icons.check);
              }
            },
            icon: const Icon(Icons.logout_outlined),
            color: const Color.fromARGB(255, 125, 31, 24),
          )
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: _chatList(),
      ),
    );
  }

  Widget _chatList() {
    return StreamBuilder(
        stream: _databaseService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          print(snapshot.data);
          if (snapshot.hasData && snapshot.data != null) {
            final User = snapshot.data!.docs;
            return ListView.builder(
                itemCount: User.length,
                itemBuilder: (context, index) {
                  UserProfile user = User[index].data();
                  return Padding(padding: const EdgeInsets.symmetric(vertical: 10.0), child: ChatTile(userProfile: user, onTap: () async {
                    final chatExist =await _databaseService.checkChatExists(_authServices.user()!.uid, user.uid!);
                  if(!chatExist){
                    await _databaseService.createNewChat(_authServices.user()!.uid, user.uid!);
                  }
                _navigationService.push(MaterialPageRoute(builder:(context) => ChatPage(chatuser: user)));
                  }));
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
