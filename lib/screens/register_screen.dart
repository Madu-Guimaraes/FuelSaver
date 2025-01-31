import 'package:flutter/material.dart';
import 'package:fuel_saver/widgets/input_field.dart';
import 'package:fuel_saver/widgets/custom_button.dart';
import 'package:fuel_saver/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Simulando contas registradas em um mapa (pode ser substituído por um banco de dados real)
  final Map<String, String> registeredUsers = {};

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
                children: [
                  InputField(
                    label: "Email",
                    icon: Icons.email,
                    borderBottom: false,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    label: "Senha",
                    icon: Icons.lock,
                    borderBottom: false,
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
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
                  const SizedBox(height: 15),
                  InputField(
                    label: "Confirmar Senha",
                    icon: Icons.lock,
                    borderBottom: false,
                    obscureText: _obscureConfirmPassword,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: CustomButton(
                      label: 'Cadastrar',
                      color: const Color(0xFF2236BD),
                      textColor: Colors.white,
                      onPressed: () {
                        _register(context);
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                     Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text("Já tem uma conta? Faça login"),
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

  void _register(BuildContext context) {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(context, "Por favor, preencha todos os campos!");
      return;
    }
    
    // Verificar se o email contém "@gmail.com"
    if (!email.contains('@gmail.com')) {
      _showMessage(context, 'Insira um e-mail válido');
      return;
    }

    // Verificar se as senhas coincidem
    if (password != confirmPassword) {
      _showMessage(context, 'As senhas não coincidem');
      return;
    }

    // Simulando o cadastro do usuário
    registeredUsers[email] = password;

    //limpar os campos
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

    // Navegar para a tela de login e limpar os campos de login também
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  });
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