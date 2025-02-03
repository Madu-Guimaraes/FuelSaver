import 'package:flutter/material.dart';
import 'package:fuel_saver/screens/loading_screen.dart';
import 'package:fuel_saver/theme.dart'; // Arquivo de tema separado

void main() {
  runApp(const FuelSaverApp());
}

class FuelSaverApp extends StatelessWidget {
  const FuelSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelSaver',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: LoadingScreen(),
    );
  }
}