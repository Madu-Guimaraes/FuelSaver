import 'package:flutter/material.dart';
import 'package:fuel_saver/screens/bottom_navigator_bar.dart';

void main() {
  runApp(const FuelSaverApp());
}

class FuelSaverApp extends StatelessWidget {
  const FuelSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelSaver',
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFDCEDFF), // Cor de fundo do Scaffold
      ),
      home: const BottomNavBarScreen(), // Tela principal com BottomNavigationBar
    );
  }
}
