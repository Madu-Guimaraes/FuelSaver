import 'package:flutter/material.dart';
import 'package:fuel_saver/controllers/reports_controller.dart';
import 'package:fuel_saver/widgets/calendar_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String selectedReport = "Selecione um Relatório";

  final ReportsController reportsController = ReportsController([
  {'date': DateTime(2025, 1, 1), 'odometer': 1000, 'liters': 50, 'fuelType': 'Gasolina', 'pricePerLiter': 5.0, 'totalCost': 250.0},
  {'date': DateTime(2024, 1, 5), 'odometer': 1050, 'liters': 40, 'fuelType': 'Etanol', 'pricePerLiter': 5.2, 'totalCost': 40 * 5.2},  // Corrigido
]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatórios"),
        backgroundColor: const Color(0XFFDCEDFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Selecionar Datas"),
                  onPressed: () async {
                    final dates = await showCalendarWidget(context);
                    if (dates.isNotEmpty) {
                      setState(() {
                        startDate = dates[0];
                        endDate = dates.length > 1 ? dates[1] : null;
                      });
                    }
                  },
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          endDate == null
                              ? startDate != null
                                  ? _formatDate(startDate!)
                                  : "Nenhuma data selecionada"
                              : "${_formatDate(startDate!)} - ${_formatDate(endDate!)}",
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            startDate = null;
                            endDate = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedReport,
              items: [
                "Selecione um Relatório",
                "Resumo",
                "Economia Correspondente (km/l)",
                "Combustível mais Econômico",
                "Gastos Mensais",
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReport = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildReport(),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildReport() {
  // final data = reportsController.calculateEconomy(startDate, endDate);

  if (selectedReport == "Selecione um Relatório") {
    return const Center(child: Text("Por favor, selecione um relatório."));
  }

  switch (selectedReport) {
    case "Resumo":
      return ListView.builder(
        itemCount: reportsController.fuelRecords.length,
        itemBuilder: (context, index) {
          final record = reportsController.fuelRecords[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("Data: ${_formatDate(record['date'])}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Odômetro: ${record['odometer']} km"),
                  Text("Combustível: ${record['fuelType']}"),
                  Text("Preço/L: R\$ ${record['pricePerLiter'].toStringAsFixed(2)}"),
                  Text("Valor Abastecido: R\$ ${record['totalCost'] != null ? record['totalCost'].toStringAsFixed(2) : '0.00'}"),
                  Text("Litros: ${record['liters'].toStringAsFixed(2)} L"),
                ],
              ),
            ),
          );
        },
      );

    case "Economia Correspondente (km/l)":
      final economyData = reportsController.calculateEconomy(startDate, endDate);
      return ListView.builder(
        itemCount: economyData.length,
        itemBuilder: (context, index) {
          final item = economyData[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("Abastecimento: ${_formatDate(item.date)}"),
              subtitle: Text("Economia: ${item.economy.toStringAsFixed(2)} km/l"),
            ),
          );
        },
      );

    case "Combustível mais Econômico":
      final savingsData = reportsController.calculateEconomyPerFuel(null, null);

      String? mostEconomicFuel;
      double highestEconomy = 0.0;

      savingsData.forEach((fuelType, data) {
        final averageEconomy = data['averageEconomy'] ?? 0.0;
        if (averageEconomy > highestEconomy) {
          highestEconomy = averageEconomy;
          mostEconomicFuel = fuelType;
        }
      });

      if (mostEconomicFuel != null) {
        final data = savingsData[mostEconomicFuel];
        return SizedBox(
          height: 2,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    "Combustível mais Econômico: $mostEconomicFuel",
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Economia Média: ${data?['averageEconomy']?.toStringAsFixed(2)} km/l",
                      ),
                      Text(
                        "Litros Abastecidos: ${data?['totalLiters']?.toStringAsFixed(2)} L",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const Center(child: Text("Nenhum dado de combustível disponível."));
    }
    case "Gastos Mensais":
      final monthlyExpenses = reportsController.calculateMonthlyExpenses(startDate, endDate);
      return ListView(
        children: monthlyExpenses.entries.map((entry) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("Mês: ${entry.key}"),
              subtitle: Text("Gasto Total: R\$ ${entry.value.toStringAsFixed(2)}"),
            ),
          );
        }).toList(),
      );

    default:
      return const Center(child: Text("Nenhum relatório disponível."));
  }
}

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Future<List<DateTime>> showCalendarWidget(BuildContext context) async {
  final selectedDates = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const CalendarScreen(),
    ),
  );
  return selectedDates ?? [];
  }
}