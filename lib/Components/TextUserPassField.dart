import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextUserPassField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool passObscure;

  const TextUserPassField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.passObscure,
  });

  @override
  State<TextUserPassField> createState() => _TextFieldUserPassState();
}

class _TextFieldUserPassState extends State<TextUserPassField> {
  late bool obscurePass;

  @override
  void initState() {
    super.initState();
    obscurePass = widget.passObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: widget.controller,
        obscureText: obscurePass,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: widget.hintText,
          suffixIcon: widget.passObscure
              ? IconButton(
            icon: Icon(
              obscurePass ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                obscurePass = !obscurePass;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
