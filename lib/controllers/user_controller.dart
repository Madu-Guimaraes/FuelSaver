import 'package:fuel_saver/controllers/vehicle_controller.dart';

class UserController {
  String? userName;
  String? email;
  final VehicleController _vehicleController = VehicleController();

  Future<void> login(String email, String password) async {
    // Simular uma autenticação
    print("Usuário logado: $email");
  }

  Future<void> logout() async {
    // Simular logout
    print("Usuário deslogado");
  }

  Future<Map<String, String>> getUserData() async {
    // Simular a recuperação de dados do usuário
    return {
      "name": "João Silva",
      "email": "joao.silva@example.com",
    };
  }

  Future<int> getTotalVehicles() async {
    // Retorna a quantidade de veículos cadastrados
    return _vehicleController.getVehicles().length;
  }

  Future<void> deleteUserAccount() async {
    // Simular exclusão de conta
    print("Conta do usuário excluída.");
  }

  Future<List<Map<String, String>>> getUserVehicles() async {
  // Recupera os veículos e converte os valores para String
  final vehicles = _vehicleController.getVehicles();
  return vehicles.map((vehicle) {
    return vehicle.map((key, value) => MapEntry(key, value.toString()));
  }).toList();
  }
}