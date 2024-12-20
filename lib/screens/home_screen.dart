import 'package:flutter/material.dart';
import 'package:fuel_saver/widgets/vehicle_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
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
      child: Image.asset('assets/img/carro.png', height: 220),
    );
  }

  Widget _buildCarModel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            children: const [
              Text(
                "Car Informations",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              InfoCard(
                title: "Último Abastecimento",
                data: "10/10/2022",
                valor: 10.00,
                total: 100.00,
                icon: Icons.local_gas_station,
                backgroundColor: Colors.indigo,
              ),
              SizedBox(height: 12),
              InfoCard(
                title: "Distância Percorrida",
                km: 1000.000,
                icon: Icons.speed,
                backgroundColor: Color(0xFF3381DE),
              ),
              SizedBox(height: 12),
              InfoCard(
                title: "Próximo Abastecimento",
                data: "22/12/2024",
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