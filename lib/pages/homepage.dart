import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages",
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout_outlined),
            color: const Color.fromARGB(255, 125, 31, 24),
          )
        ],
      ),
    );
  }
}
