import 'package:intl/intl.dart';

class RefuelController {
  final List<Map<String, dynamic>> _refuels = [];

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
    refuelData['date'] = DateFormat('dd/MM/yyyy').format(DateTime.now()); // Salvando a data
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

  // Obter o último abastecimento
  Map<String, dynamic>? getLastRefuel() {
    if (_refuels.isEmpty) return null;
    return _refuels.last;
  }

  // Calcular a próxima data estimada de abastecimento
  String? estimateNextRefuelDate(double dailyDistance) {
    if (_refuels.length < 2) return null;
    
    final lastRefuel = _refuels.last;
    final previousRefuel = _refuels[_refuels.length - 2];

    double lastOdometer = lastRefuel['odometer'];
    double prevOdometer = previousRefuel['odometer'];
    double liters = lastRefuel['liters'];

    double distanceTraveled = lastOdometer - prevOdometer;
    if (distanceTraveled <= 0 || liters <= 0) return null;

    // Calcular o consumo médio (km/L)
    double consumption = distanceTraveled / liters;

    // Estimativa de autonomia restante
    double remainingAutonomy = consumption * liters;

    // Estimativa de dias para o próximo abastecimento com base na distância diária
    int estimatedDays = (remainingAutonomy / dailyDistance).round();
    DateTime nextRefuelDate = DateTime.now().add(Duration(days: estimatedDays));

    return DateFormat('dd/MM/yyyy').format(nextRefuelDate);
  }
}