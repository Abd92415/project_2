import 'package:flutter/material.dart';

class TextFieldUseAll extends StatelessWidget {
  const TextFieldUseAll(
      {super.key,
      required this.hint,
      required this.iconuse,
      required this.type,
      required this.controller});
  final TextInputType type;
  final IconData iconuse;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextField(
            controller: controller,
            keyboardType: type,
            style: const TextStyle(color: Colors.black),
            obscureText: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                iconuse,
                color: Colors.deepPurple,
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.deepPurple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
