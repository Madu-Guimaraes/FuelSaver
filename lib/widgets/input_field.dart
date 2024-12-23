import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const InputField({
    Key? key,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFFB0B0B0)), //cor do placeholder
        prefixIcon: Icon(icon, color: Color(0xFFB0B0B0),), //cor do icon
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Bordas arredondadas
          borderSide: BorderSide.none,
        ),
        filled: true, // Fundo preenchido
        fillColor: Color(0xFFFEFEFE), // Cor de fundo
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
