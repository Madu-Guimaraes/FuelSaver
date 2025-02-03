import 'package:fuel_saver/controllers/vehicle_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserController {
  String? userName;
  String? email;
  final VehicleController _vehicleController = VehicleController();
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Armazenamento seguro

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
    // Aqui você pode recuperar os dados do usuário do armazenamento seguro, se necessário
    return {
      "name": "João Silva",
      "email": "joao.silva@example.com",
    };
  }

  Future<int> getTotalVehicles() async {
    // Retorna a quantidade de veículos cadastrados
    return _vehicleController.getVehicles().length;
  }

  // Método para excluir a conta do usuário
  Future<void> deleteUserAccount() async {
    // Excluir os dados do usuário do armazenamento seguro
    await _storage.delete(key: 'email'); // Excluindo o e-mail armazenado
    await _storage.delete(key: 'password'); // Excluindo a senha armazenada
    
    // Se você armazenar o nome ou outros dados no armazenamento seguro, exclua-os também:
    await _storage.delete(key: 'userName'); // Excluindo o nome, se necessário

    // Simular exclusão de veículos (opcional, dependendo de como você armazena dados)
    // Aqui você pode adicionar código para excluir veículos se for o caso:
    // _vehicleController.deleteAllVehicles();

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