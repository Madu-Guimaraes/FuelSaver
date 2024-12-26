import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool filled; // Define se o fundo será preenchido
  final bool readOnly; // Define se o campo é apenas leitura
  final VoidCallback? onTap; // Define a ação ao clicar no campo
  final bool borderBottom; // Controla a borda inferior
  final Function(String)? onChanged;

  const InputField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.filled = true, // Fundo preenchido por padrão
    this.readOnly = false, // Campo editável por padrão
    this.onTap,
    this.borderBottom = true, // Borda inferior ativada por padrão
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            const TextStyle(color: Color(0xFFB0B0B0)), // Cor do placeholder
        prefixIcon:
            Icon(icon, color: const Color(0xFFB0B0B0)), // Ícone do campo
        border: borderBottom
            ? const UnderlineInputBorder(
                // Borda inferior padrão
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ))
            : InputBorder.none, // Sem borda
        enabledBorder: borderBottom
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ))
            : InputBorder.none,
        focusedBorder: borderBottom
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ))
            : InputBorder.none,
        filled: filled, // Fundo preenchido
        fillColor: filled
            ? const Color(0xFFFEFEFE)
            : Colors.transparent, // Cor do fundo
      ),
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly, // Campo somente leitura
      onTap: onTap,
    );
  }
}
