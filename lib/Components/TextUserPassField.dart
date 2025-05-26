import 'package:flutter/material.dart';

class TextUserPassField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool passObscure;
  final String? errorText;

  const TextUserPassField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.passObscure,
    this.errorText,
  }) : super(key: key);

  @override
  _TextUserPassFieldState createState() => _TextUserPassFieldState();
}

class _TextUserPassFieldState extends State<TextUserPassField> {
  late bool _obscureText; // This will handle the visibility of the password

  @override
  void initState() {
    super.initState();
    _obscureText = widget.passObscure; // Initialize with the passed value
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            obscureText: _obscureText, // Use the dynamic _obscureText value
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
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Toggle the visibility
                  });
                },
              )
                  : null,
            ),
          ),
          // Display error message if exists
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                widget.errorText!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
