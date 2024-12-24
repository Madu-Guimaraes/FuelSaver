class UserController {
  String? userName;
  String? email;

  Future<void> login(String email, String password) async {
    // Simular uma autenticação
    print("Usuário logado: $email");
  }

  Future<void> logout() async {
    // Simular logout
    print("Usuário deslogado");
  }

  Future<Map<String, String>> getUserData() async {
    return {
      "name": "João Silva",
      "email": "joao.silva@example.com",
    };
  }
}
