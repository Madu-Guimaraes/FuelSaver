class VehicleController {
  List<Map<String, dynamic>> vehicles = [];

  void addVehicle(Map<String, dynamic> vehicleData) {
    vehicles.add(vehicleData);
    print("Veículo adicionado: $vehicleData");
  }

  void updateVehicle(int index, Map<String, dynamic> updatedData) {
    if (index >= 0 && index < vehicles.length) {
      vehicles[index] = updatedData;
      print("Veículo atualizado: $updatedData");
    }
  }

  List<Map<String, dynamic>> getVehicles() {
    return vehicles;
  }
}
