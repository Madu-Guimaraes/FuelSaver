import 'package:flutter/material.dart';
import 'package:fuel_saver/widgets/input_field.dart';
import 'package:fuel_saver/widgets/custom_button.dart';
import 'package:fuel_saver/screens/register_screen.dart';
import 'package:fuel_saver/screens/bottom_navigator_bar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Simulando contas registradas em um mapa (pode ser substituído por uma API ou banco de dados)
  final Map<String, String> registeredUsers = {
    'user@gmail.com': '123',  // Exemplo de usuário cadastrado
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCarImage(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputField(
                    label: "Email",
                    icon: Icons.email,
                    borderBottom: false,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    label: "Senha",
                    icon: Icons.lock,
                    borderBottom: false,
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: CustomButton(
                      label: 'Entrar',
                      color: const Color(0xFF2236BD),
                      textColor: Colors.white,
                      onPressed: () {
                        _login(context);
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: const Text("Não tem uma conta? Cadastre-se"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarImage() {
    return Image.asset(
      'assets/img/carro_logo.png',
      height: 280,
      width: 290,
      fit: BoxFit.cover,
    );
  }

void _login(BuildContext context) {
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    _showMessage(context, "Por favor, preencha todos os campos!");
    return;
  }

  if (!email.contains('@gmail.com')) {
    _showMessage(context, 'Insira um e-mail válido');
    return;
  }

  if (registeredUsers.containsKey(email) && registeredUsers[email] == password) {
    _showMessage(context, 'Login bem-sucedido');

    // Limpar os campos após login
    _emailController.clear();
    _passwordController.clear();

    // Redirecionar para o BottomNavBarScreen (tela com BottomNavigationBar)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBarScreen()),
    );
  } else {
    _showMessage(context, 'Email ou senha incorretos');
  }
}

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}