//mantem o seue stado
import 'package:flutter/material.dart';
import 'package:fuel_saver/screens/home_screen.dart';
import 'package:fuel_saver/screens/register_fueling.dart';
import 'package:fuel_saver/screens/user_screen.dart';
import 'package:fuel_saver/screens/vehicle_screen.dart';
import 'package:fuel_saver/screens/reports_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  //criando a instancia do estado que controla a navegação da tela
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;

  // Lista de telas para navegação
  final List<Widget> _screens = [
    HomeScreen(),
    VehicleScreen(),
    RegisterFueling(),
    ReportScreen(),
    UserScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Altera a tela conforme o índice
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/img/logo.png',
          height: 70, //altura da logo  
          fit: BoxFit.contain, //ajusta a logo ao tamanho especificado
        ),
        backgroundColor: Color(0xFF96C0E2),
      ),
      body: _screens[_selectedIndex], // Exibe a tela selecionada
      //barra de navegação
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // Exibe labels somente no item selecionado
        backgroundColor: Color(0xFF96C0E2), // Cor de fundo fixa da barra
        selectedItemColor: Colors.white, // Cor dos itens selecionados
        unselectedItemColor:
            Color(0xFF00344E), // Cor dos itens não selecionados
        showSelectedLabels: true, // Mostra a label do item selecionado
        showUnselectedLabels: false,
        currentIndex:
            _selectedIndex, //Define o índice do item atualmente selecionado
        onTap: _onItemTapped,
        iconSize: 30.00,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Veículos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _selectedIndex == 2 ? Colors.white : Color(0xFF3381DE),
              size: 45.00,
            ),
            label: 'Abastecimento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
