import 'package:flutter/material.dart';
import 'package:fuel_saver/widgets/vehicle_card.dart';
import 'package:fuel_saver/controllers/refuel_controller.dart'; 

class HomeScreen extends StatelessWidget {
  final RefuelController refuelController = RefuelController(); // Instância do RefuelController

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 8),
            _buildCarImage(),
            _buildCarModel(),
            _buildCarInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCarImage() {
    return Center(
      child: Image.asset('assets/img/carro.png', height: 260),
    );
  }

  Widget _buildCarModel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Text(
            "Nome/Modelo do Carro",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            "Gol Quadrado - 1.6",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCarInfoSection() {
    // Obtendo os dados do último abastecimento e do próximo abastecimento
    final lastRefuel = refuelController.getLastRefuel();
    final nextRefuelDate = refuelController.estimateNextRefuelDate(30); // Distância diária média (exemplo: 30 km/dia)

    if (lastRefuel == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: const Text(
                'Nenhum abastecimento registrado.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: const Text(
                'Por favor, registre um abastecimento clicando no ícone "+"',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    final lastDate = lastRefuel['date'];
    final totalCost = lastRefuel['totalCost'];
    final liters = lastRefuel['liters'];
    final distanceTraveled = lastRefuel['odometer'] - lastRefuel['previousOdometer']; // Distância percorrida

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Car Informations",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              InfoCard(
                title: "Último Abastecimento",
                data: lastDate,
                valor: totalCost,
                total: liters,
                icon: Icons.local_gas_station,
                backgroundColor: Colors.indigo,
              ),
              const SizedBox(height: 12),
              InfoCard(
                title: "Distância Percorrida",
                km: distanceTraveled,
                icon: Icons.speed,
                backgroundColor: Color(0xFF3381DE),
              ),
              const SizedBox(height: 12),
              InfoCard(
                title: "Próximo Abastecimento",
                data: nextRefuelDate ?? "Indeterminado",
                icon: Icons.calendar_today,
                backgroundColor: Color(0xFF3381DE),
              ),
            ],
          ),
        ),
      ),
    );
  }
}