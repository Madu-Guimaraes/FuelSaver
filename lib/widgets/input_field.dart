import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool filled;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool borderBottom;
  final Function(String)? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;

  const InputField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.filled = true,
    this.readOnly = false,
    this.onTap,
    this.borderBottom = true,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        prefixIcon: Icon(icon, color: const Color(0xFFB0B0B0)),
        suffixIcon: suffixIcon,
        border: borderBottom ? _buildBorder() : InputBorder.none,
        enabledBorder: borderBottom ? _buildBorder() : InputBorder.none,
        focusedBorder: borderBottom
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              )
            : InputBorder.none,
        filled: filled,
        fillColor: filled ? const Color(0xFFFEFEFE) : Colors.transparent,
      ),
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
    );
  }

  UnderlineInputBorder _buildBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }
}