import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fuel_saver/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_screen.dart'; // Supondo que a tela de login esteja nesse arquivo

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final UserController userController;
  Map<String, String>? userData;
  bool isNameEditable = false;
  bool isEmailEditable = false;

  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vehiclesController = TextEditingController();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    userController = UserController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await userController.getUserData();
    final vehicles = await userController.getTotalVehicles();
    setState(() {
      userData = data;
      _nameController.text = data['name'] ?? ''; // Nome vazio até o usuário preencher
      _emailController.text = data['email']!; // Email será o mesmo de login
      _vehiclesController.text = vehicles.toString();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _updateUserData() {
    setState(() {
      userData = {
        "name": _nameController.text,
        "email": _emailController.text,
      };
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Informações atualizadas com sucesso!")),
    );
  }

Future<void> _deleteAccount() async {
  await userController.deleteUserAccount();  // Corrigir o nome do método aqui
  await _storage.deleteAll(); // Limpa o armazenamento seguro (incluindo senha e e-mail)

  // Redireciona para a tela de login após a exclusão da conta
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

  Future<void> _logout() async {
    try {
      await _storage.deleteAll();
      print("Dados apagados com sucesso.");
    } catch (e) {
      print("Erro ao apagar os dados: $e");
    }


    // Redireciona para a tela de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          enabled: isNameEditable,
                          decoration: const InputDecoration(
                            labelText: "Nome",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(isNameEditable ? Icons.check : Icons.edit),
                        onPressed: () {
                          setState(() {
                            isNameEditable = !isNameEditable;
                          });
                          if (!isNameEditable) {
                            _updateUserData();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          enabled: isEmailEditable,
                          decoration: const InputDecoration(
                            labelText: "E-mail",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(isEmailEditable ? Icons.check : Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEmailEditable = !isEmailEditable;
                          });
                          if (!isEmailEditable) {
                            _updateUserData();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _vehiclesController,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Total de Automóveis Cadastrados",
                      prefixIcon: Icon(Icons.directions_car),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _deleteAccount,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Excluir Conta", style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: _logout,
                        child: const Text("Sair"),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}