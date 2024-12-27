import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fuel_saver/controllers/vehicle_controller.dart';
import 'package:fuel_saver/controllers/refuel_controller.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final VehicleController _vehicleController = VehicleController();
  final RefuelController _refuelController = RefuelController();
  DateTime? _startDate;
  DateTime? _endDate;

  String? _selectedFilter;
  final List<String> _filters = [
    "Economia Correspondente (KM/L)",
    "Preço por Combustíveis Cadastrados",
    "Distância por Abastecimento",
    "Gastos Mensais Totais",
    "Gastos Semanais Totais",
  ];

  final List<Map<String, dynamic>> _reportData = [];

  // Função para aplicar o filtro e gerar os relatórios
  void _generateReport() {
    List<Map<String, dynamic>> filteredVehicles = _vehicleController.getVehicles();
    List<Map<String, dynamic>> filteredRefuels = _refuelController.getRefuels();

    // Validação de datas
    if (_startDate != null && _endDate != null && _startDate!.isAfter(_endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A data de início não pode ser posterior à data de fim.')),
      );
      return;
    }

    // Filtro por data
    if (_startDate != null && _endDate != null) {
      filteredRefuels = filteredRefuels.where((refuel) {
        DateTime refuelDate = DateTime.parse(refuel['date']);
        return refuelDate.isAfter(_startDate!) && refuelDate.isBefore(_endDate!);
      }).toList();
    }

    // Limpeza dos dados do relatório antes de gerar novo
    _reportData.clear();

    // Exemplo de como aplicar o filtro de "Economia Correspondente (KM/L)"
    if (_selectedFilter == "Economia Correspondente (KM/L)") {
      for (var vehicle in filteredVehicles) {
        double totalKm = 0;
        double totalLiters = 0;
        for (var refuel in filteredRefuels) {
          if (refuel['vehicleId'] == vehicle['id']) {
            totalKm += refuel['distance'];
            totalLiters += refuel['liters'];
          }
        }
        if (totalLiters > 0) {
          double economy = totalKm / totalLiters;
          _reportData.add({
            'vehicle': vehicle['name'],
            'economy': economy,
          });
        }
      }
    }

    // Exemplo de como aplicar o filtro de "Preço por Combustíveis Cadastrados"
    else if (_selectedFilter == "Preço por Combustíveis Cadastrados") {
      double totalCost = 0;
      for (var refuel in filteredRefuels) {
        totalCost += refuel['price'] * refuel['liters'];
      }
      _reportData.add({
        'totalCost': totalCost,
      });
    }

    // Exemplo de como aplicar o filtro de "Distância por Abastecimento"
    else if (_selectedFilter == "Distância por Abastecimento") {
      for (var refuel in filteredRefuels) {
        _reportData.add({
          'vehicleId': refuel['vehicleId'],
          'distance': refuel['distance'],
        });
      }
    }

    // Exemplo de como aplicar o filtro de "Gastos Mensais Totais"
    else if (_selectedFilter == "Gastos Mensais Totais") {
      double monthlyCost = 0;
      for (var refuel in filteredRefuels) {
        DateTime refuelDate = DateTime.parse(refuel['date']);
        if (refuelDate.month == DateTime.now().month) {
          monthlyCost += refuel['price'] * refuel['liters'];
        }
      }
      _reportData.add({
        'monthlyCost': monthlyCost,
      });
    }

    // Exemplo de como aplicar o filtro de "Gastos Semanais Totais"
    else if (_selectedFilter == "Gastos Semanais Totais") {
      double weeklyCost = 0;
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      for (var refuel in filteredRefuels) {
        DateTime refuelDate = DateTime.parse(refuel['date']);
        if (refuelDate.isAfter(startOfWeek) && refuelDate.isBefore(endOfWeek)) {
          weeklyCost += refuel['price'] * refuel['liters'];
        }
      }
      _reportData.add({
        'weeklyCost': weeklyCost,
      });
    }

    setState(() {});
  }

  // Função para selecionar as datas
  void _selectDateRange() async {
    final DateTime? pickedStart = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedStart != null) {
      final DateTime? pickedEnd = await showDatePicker(
        context: context,
        initialDate: _endDate ?? DateTime.now(),
        firstDate: pickedStart,
        lastDate: DateTime(2101),
      );

      if (pickedEnd != null) {
        setState(() {
          _startDate = pickedStart;
          _endDate = pickedEnd;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatório de Combustível"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selecione o filtro
            DropdownButton<String>(
              value: _selectedFilter,
              hint: const Text("Selecione o Filtro"),
              items: _filters.map((filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Selecione o intervalo de datas
            Row(
              children: [
                Text(_startDate != null
                    ? DateFormat('dd/MM/yyyy').format(_startDate!)
                    : 'Início'),
                const SizedBox(width: 8),
                Text('até'),
                const SizedBox(width: 8),
                Text(_endDate != null
                    ? DateFormat('dd/MM/yyyy').format(_endDate!)
                    : 'Fim'),
                const Spacer(),
                ElevatedButton(
                  onPressed: _selectDateRange,
                  child: const Text("Selecionar Data"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botão para gerar o relatório
            ElevatedButton(
              onPressed: _generateReport,
              child: const Text("Gerar Relatório"),
            ),

            const SizedBox(height: 20),

            // Exibir o relatório gerado (após aplicar os filtros)
            Expanded(
              child: ListView.builder(
                itemCount: _reportData.length, // Contando os itens filtrados
                itemBuilder: (context, index) {
                  var report = _reportData[index];
                  return ListTile(
                    title: Text(report.containsKey('vehicle')
                        ? 'Veículo: ${report['vehicle']}'
                        : report.containsKey('totalCost')
                            ? 'Custo Total: ${report['totalCost']}'
                            : report.containsKey('distance')
                                ? 'Distância: ${report['distance']} km'
                                : report.containsKey('monthlyCost')
                                    ? 'Gastos Mensais: ${report['monthlyCost']}'
                                    : 'Gastos Semanais: ${report['weeklyCost']}'),
                    subtitle: Text("Detalhes do relatório..."),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
