import 'package:flutter/material.dart';

class TypeFuelScreen extends StatelessWidget {
  const TypeFuelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de tipos de combustíveis e seus ícones
    final List<Map<String, dynamic>> fuelTypes = [
      {'name': 'Gasolina Comum', 'icon': Icons.local_gas_station},
      {'name': 'Gasolina Aditivada', 'icon': Icons.local_gas_station},
      {'name': 'Etanol', 'icon': Icons.local_gas_station},
      {'name': 'Diesel', 'icon': Icons.local_gas_station},
      {'name': 'GNV', 'icon': Icons.ev_station},
      {'name': 'GLP', 'icon': Icons.local_fire_department},
      {'name': 'Biodiesel', 'icon': Icons.energy_savings_leaf},
      {'name': 'Eletricidade', 'icon': Icons.electric_car},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione o Combustível"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retorna sem selecionar nada
          },
        ),
      ),
      body: ListView.separated(
        itemCount: fuelTypes.length,
        separatorBuilder: (context, index) => const Divider(), // Linha separadora
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(fuelTypes[index]['icon'], color: Colors.blue), // Ícone à esquerda
            title: Text(fuelTypes[index]['name']),
            onTap: () {
              // Retorna o tipo de combustível selecionado
              Navigator.pop(context, fuelTypes[index]['name']);
            },
          );
        },
      ),
    );
  }
}