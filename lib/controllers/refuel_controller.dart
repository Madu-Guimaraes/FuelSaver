class RefuelController {
  // Função para calcular o custo total
  double calculateTotalCost(double liters, double pricePerLiter) {
    return liters * pricePerLiter;
  }

  // Função para validar os dados de abastecimento
  bool validateRefuelData({
    required double odometer,
    required String fuelType,
    required double pricePerLiter,
    required double liters,
  }) {
    if (odometer <= 0 || pricePerLiter <= 0 || liters <= 0 || fuelType.isEmpty) {
      return false;
    }
    return true;
  }

  // Função para salvar os dados de abastecimento
  Future<void> saveRefuelData(Map<String, dynamic> refuelData) async {
    // Aqui você pode salvar os dados no banco de dados ou em uma API
    print("Dados de abastecimento salvos: $refuelData");
  }
}