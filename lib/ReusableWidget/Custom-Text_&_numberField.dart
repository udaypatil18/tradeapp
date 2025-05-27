import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  //final TextEditingController controller;
  final bool obscureText;
  final IconButton? suffixIcon; // For the visibility toggle
  final TextInputType inputType; // To specify input type
  final int? maxLength; // To limit input length

  const CustomTextField({
    required this.label,
    //this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.inputType = TextInputType.text, // Default input type is text
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      //controller: controller,
      obscureText: obscureText,
      keyboardType: inputType, // Set keyboard type
      maxLength: maxLength, // Set max length if provided
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon, // Add the suffix icon if provided
      ),
    );
  }
}

class CustomNumberField extends StatelessWidget {
  final String label;
  //final TextEditingController controller;

  const CustomNumberField({
    required this.label,
    //required this.controller,
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      //controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allow digits
        LengthLimitingTextInputFormatter(10), // Limit to 10 digits
      ],
      decoration: InputDecoration(
        //hintText: label,
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
