import '../../../services/language/generated/key_lang.dart';
import 'package:flutter/material.dart';

class TextFieldPassword extends StatefulWidget {
  const TextFieldPassword(String password, this.controller, {super.key});

  final TextEditingController controller;
  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool _passwordVisiable = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextField(
            controller: widget.controller,
            style: const TextStyle(color: Colors.black),
            obscureText: !_passwordVisiable,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.lock_open,
                color: Colors.deepPurple,
              ),
              border: InputBorder.none,
              hintText: KeyLang.password,
              hintStyle: const TextStyle(
                color: Colors.deepPurple,
              ),
              suffixIcon: IconButton(
                icon: Icon(_passwordVisiable
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _passwordVisiable = !_passwordVisiable;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
