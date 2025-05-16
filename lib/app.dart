import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Quotes App')),
        body: const Center(child: Text('Welcome to Quotes App!')),
      ),
    );
  }
}
