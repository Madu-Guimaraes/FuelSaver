import 'package:intl/intl.dart';

class RefuelController {
  // Lista para armazenar os dados de abastecimento
  final List<Map<String, dynamic>> _refuels = [];

  // Função para calcular o custo total
  double calculateTotalCost(double liters, double pricePerLiter) {
    return liters * pricePerLiter;
  }

  // Função para calcular os litros com base no valor total abastecido
  double calculateLiters(double totalCost, double pricePerLiter) {
    if (pricePerLiter <= 0) {
      throw ArgumentError("O preço por litro deve ser maior que zero.");
    }
    return totalCost / pricePerLiter;
  }

  // Função para validar os dados de abastecimento
  bool validateRefuelData({
    required double odometer,
    required String fuelType,
    required double pricePerLiter,
    required double totalCost,
  }) {
    if (odometer <= 0 || pricePerLiter <= 0 || totalCost <= 0 || fuelType.isEmpty) {
      return false;
    }
    return true;
  }

  // Função para salvar os dados de abastecimento
  Future<void> saveRefuelData(Map<String, dynamic> refuelData) async {
    // Aqui você pode salvar os dados no banco de dados ou em uma API
    _refuels.add(refuelData);  // Adiciona o novo abastecimento à lista
    print("Dados de abastecimento salvos: $refuelData");
  }

  // Método para obter os dados de abastecimento
  List<Map<String, dynamic>> getRefuels() {
    return _refuels;
  }

  // Função para filtrar os dados de abastecimento por intervalo de datas e tipo de combustível
  List<Map<String, dynamic>> filterRefuels({
    DateTime? startDate,
    DateTime? endDate,
    String? fuelType,
  }) {
    return _refuels.where((entry) {
      final entryDate = DateFormat('dd/MM/yyyy').parse(entry['date']);
      final isWithinDateRange = startDate != null &&
          endDate != null &&
          entryDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(endDate.add(const Duration(days: 1)));
      final isFuelTypeMatch = fuelType == null || entry['fuelType'] == fuelType;
      return isWithinDateRange && isFuelTypeMatch;
    }).toList();
  }
}