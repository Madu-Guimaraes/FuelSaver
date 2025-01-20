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
    {'date': DateTime(2025, 1, 1), 'odometer': 1000, 'liters': 50, 'fuelType': 'Gasolina', 'pricePerLiter': 5.0},
    {'date': DateTime(2024, 1, 5), 'odometer': 1050, 'liters': 40, 'fuelType': 'Etanol', 'pricePerLiter': 5.2},
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
                "Resumo em Lista",
                "Economia Correspondente (km/l)",
                "Economia por Combustível",
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
    final data = reportsController.calculateEconomy(startDate, endDate);

    if (selectedReport == "Selecione um Relatório") {
      return const Center(child: Text("Por favor, selecione um relatório."));
    }

    switch (selectedReport) {
      case "Resumo em Lista":
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              title: Text("Data: ${_formatDate(item.date)}"),
              subtitle: Text("Economia: ${item.economy.toStringAsFixed(2)} km/l"),
              trailing: Text("Gasto: R\$ ${item.expense.toStringAsFixed(2)}"),
            );
          },
        );

      case "Economia Correspondente (km/l)":
        final economyData = reportsController.calculateEconomy(startDate, endDate);
        return ListView.builder(
          itemCount: economyData.length,
          itemBuilder: (context, index) {
            final item = economyData[index];

            // Verifica se a economia é válida e exibe a data e economia
            return ListTile(
              title: Text("Abastecimento: ${_formatDate(item.date)}"),
              subtitle: Text("Economia: ${item.economy.toStringAsFixed(2)} km/l"),
            );
          },
        );

      case "Economia por Combustível":
        final savingsData = reportsController.calculateEconomyPerFuel(startDate, endDate);
        return ListView.builder(
          itemCount: savingsData.length,
          itemBuilder: (context, index) {
            final fuelType = savingsData.keys.elementAt(index);
            final data = savingsData[fuelType];
            final averageEconomy = data?['averageEconomy'] ?? 0.0;
            final totalLiters = data?['totalLiters'] ?? 0.0;

            return ListTile(
              title: Text("Combustível: $fuelType"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Economia Média: ${averageEconomy.toStringAsFixed(2)} km/l"),
                  Text("Litros Abastecidos: ${totalLiters.toStringAsFixed(2)} L"),
                ],
              ),
            );
          },
        );
      case "Gastos Mensais":
        final monthlyExpenses = reportsController.calculateMonthlyExpenses(startDate, endDate);
        return ListView(
          children: monthlyExpenses.entries.map((entry) {
            return ListTile(
              title: Text("Mês: ${entry.key}"),
              subtitle: Text("Gasto Total: R\$ ${entry.value.toStringAsFixed(2)}"),
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