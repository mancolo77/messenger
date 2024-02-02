import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText ? _obscureText : false,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(6),
        ),
        fillColor: Colors.grey.withOpacity(.2),
        filled: true,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 97, 97, 97)),
        suffixIcon: widget.obscureText
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? Icon(
                        Icons.visibility_off,
                        color: _obscureText == false
                            ? Colors.black
                            : Colors.grey,
                      )
                    : Icon(
                        Icons.visibility,
                        color: _obscureText == false
                            ? Colors.black
                            : Colors.grey,
                      ),
              )
            : null, 
      ),
    );
  }
}
