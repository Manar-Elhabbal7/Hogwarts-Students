import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

class PassTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final int? maxLength;

  const PassTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    this.validator,
    this.maxLength,
  });

  @override
  State<PassTextField> createState() => _PassCustomTextFieldState();
}

class _PassCustomTextFieldState extends State<PassTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          maxLength: widget.maxLength,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            counterText: widget.maxLength != null ? "" : null,
            suffixIcon: IconButton(
              icon: Icon(
                widget.obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: widget.onToggleVisibility,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}