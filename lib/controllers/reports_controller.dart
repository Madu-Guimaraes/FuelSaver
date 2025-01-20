import 'package:fuel_saver/data/report_data.dart';

class ReportsController {
  final List<Map<String, dynamic>> fuelRecords;

  ReportsController(this.fuelRecords);

  List<ReportData> calculateEconomy(DateTime? startDate, DateTime? endDate) {
    final filteredRecords = _filterRecords(startDate, endDate);
    List<ReportData> results = [];

    for (int i = 0; i < filteredRecords.length; i++) {
      final current = filteredRecords[i];
      double? economy;
      double? expense;

      if (i > 0) {
        final previous = filteredRecords[i - 1];
        final distance = current['odometer'] - previous['odometer'];
        final liters = current['liters'];

        if (liters != null && liters > 0) {
          economy = distance / liters;
        }
      } else {
        economy = 0.0;  // Para o primeiro abastecimento, pode exibir 0 ou algum valor
      }

      expense = current['liters'] * current['pricePerLiter']; // Calculando o custo total
      results.add(ReportData(
        date: current['date'],
        economy: economy ?? 0.0,
        expense: expense ?? 0.0,
      ));
    }

    return results;
  }
  // Nova função: Economia por tipo de combustível
Map<String, Map<String, double>> calculateEconomyPerFuel(DateTime? startDate, DateTime? endDate) {
  final filteredRecords = startDate == null && endDate == null
      ? fuelRecords // Ignora filtro de datas se ambos forem nulos
      : _filterRecords(startDate, endDate);
  
  final Map<String, double> fuelEconomy = {};
  final Map<String, double> fuelLiters = {};
  final Map<String, int> fuelCount = {};

  for (int i = 1; i < filteredRecords.length; i++) {
    final current = filteredRecords[i];
    final previous = filteredRecords[i - 1];

    if (current['fuelType'] != null) {
      final distance = current['odometer'] - previous['odometer'];
      final liters = current['liters'];
      final fuelType = current['fuelType'];

      if (liters > 0) {
        final economy = distance / liters;
        fuelEconomy[fuelType] = (fuelEconomy[fuelType] ?? 0) + economy;
        fuelLiters[fuelType] = (fuelLiters[fuelType] ?? 0) + liters;
        fuelCount[fuelType] = (fuelCount[fuelType] ?? 0) + 1;
      }
    }
  }

  // Calcular média de economia por tipo de combustível
  final Map<String, Map<String, double>> result = {};
  fuelEconomy.forEach((fuelType, totalEconomy) {
    result[fuelType] = {
      'averageEconomy': totalEconomy / (fuelCount[fuelType] ?? 1),
      'totalLiters': fuelLiters[fuelType] ?? 0,
    };
  });

  return result;
}
  // Nova função: Gastos mensais
  Map<String, double> calculateMonthlyExpenses(DateTime? startDate, DateTime? endDate) {
    final filteredRecords = _filterRecords(startDate, endDate);
    final Map<String, double> monthlyExpenses = {};

    for (var record in filteredRecords) {
      final date = record['date'];
      final liters = record['liters'];
      final pricePerLiter = record['pricePerLiter'];

      if (date != null && liters != null && pricePerLiter != null) {
        final month = "${date.year}-${date.month.toString().padLeft(2, '0')}";
        monthlyExpenses[month] = (monthlyExpenses[month] ?? 0) + (liters * pricePerLiter);
      }
    }

    return monthlyExpenses;
  }

  // Função auxiliar: Filtrar registros por data
  List<Map<String, dynamic>> _filterRecords(DateTime? startDate, DateTime? endDate) {
    return fuelRecords.where((record) {
      final date = record['date'];
      return (startDate == null || !date.isBefore(startDate)) &&
          (endDate == null || !date.isAfter(endDate));
    }).toList();
  }
}