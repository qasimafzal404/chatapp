import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/navigation_services.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/pages/chat_page.dart';

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
        _navigationService.pushNamedReplacement("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFF0F0F0), // Light background color
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 43, 162, 198), // Purple AppBar color
        title:const Center(
          child:  Text(
            "Messages",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 , color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authServices.logout();
              if (result) {
                _navigationService.pushNamedReplacement("/login");
                _alertservices.showToast(
                    text: "Logout Successfully!", icon: Icons.check);
              }
            },
            icon: const Icon(Icons.logout_outlined),
            color: Colors.white, // White icon for better contrast
          )
        ],
      ),
      body: _buildUI(),
    
    );
  }

  Widget _buildUI() {
    Color color = Color.fromARGB(255, 43, 162, 198);
    return SafeArea(
      
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Chats",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color:Color.fromARGB(255, 43, 162, 198),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: _chatList()), // Full-screen list with expansion
          ],
        ),
      ),
    );
  }

  Widget _chatList() {
    return StreamBuilder(
        stream: _databaseService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong",
                  style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            final User = snapshot.data!.docs;
            return ListView.builder(
              itemCount: User.length,
              itemBuilder: (context, index) {
                UserProfile user = User[index].data();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.pfpURL!),
                        backgroundColor: Colors.grey[300], // Fallback color
                      ),
                      title: Text(
                        user.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      
                      onTap: () async {
                        final chatExist = await _databaseService.checkChatExists(
                            _authServices.user()!.uid, user.uid!);
                        if (!chatExist) {
                          await _databaseService.createNewChat(
                              _authServices.user()!.uid, user.uid!);
                        }
                        _navigationService.push(MaterialPageRoute(
                            builder: (context) => ChatPage(chatuser: user)));
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

