import 'package:flutter/material.dart';

class TextUserPassField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool passObscure;
  final String? errorText;
  final Color? textColor;   // ✅ Added
  final Color? hintColor;   // ✅ Added

  const TextUserPassField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.passObscure,
    this.errorText,
    this.textColor,         // ✅ Added
    this.hintColor,         // ✅ Added
  }) : super(key: key);

  @override
  _TextUserPassFieldState createState() => _TextUserPassFieldState();
}

class _TextUserPassFieldState extends State<TextUserPassField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.passObscure;
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
            obscureText: _obscureText,
            style: TextStyle(
              color: widget.textColor ?? Colors.black, // ✅ Set text color
            ),
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
              hintStyle: TextStyle(
                color: widget.hintColor ?? Colors.grey, // ✅ Set hint color
              ),
              suffixIcon: widget.passObscure
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                widget.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
