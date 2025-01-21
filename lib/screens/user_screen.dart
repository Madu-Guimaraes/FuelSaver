import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fuel_saver/controllers/user_controller.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final UserController userController;
  Map<String, String>? userData;
  int? totalVehicles;
  File? _profileImage;
  bool isNameEditable = false;
  bool isEmailEditable = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
      totalVehicles = vehicles;
      _nameController.text = data['name']!;
      _emailController.text = data['email']!;
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

  void _confirmDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Conta"),
        content: const Text("Tem certeza de que deseja excluir sua conta? Esta ação é irreversível."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await userController.deleteUserAccount();
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userData == null || totalVehicles == null
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
                            : const AssetImage('assets/default_profile.png') as ImageProvider,
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          initialValue: totalVehicles.toString(),
                          decoration: const InputDecoration(
                            labelText: "Total de Automóveis Cadastrados",
                            prefixIcon: Icon(Icons.directions_car),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _updateUserData,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text("Salvar Alterações"),
                      ),
                      ElevatedButton(
                        onPressed: _confirmDeleteAccount,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Excluir Conta"),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}