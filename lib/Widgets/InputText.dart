import 'package:flutter/material.dart';

class TextInput2 extends StatefulWidget {
  final String? label;
  final String? value;
  final bool? password;
  final TextInputType? inputType;
  final validator;
  final Icon? inputIcon;
  final TextStyle? inputStyle;
  final Controller;
  const TextInput2(
      {Key? key,
      this.Controller,
      this.value,
      this.label,
      this.password = false,
      this.inputType,
      this.validator,
      this.inputIcon,
      this.inputStyle =
          const TextStyle(color: Color.fromARGB(100, 200, 201, 241))})
      : super(key: key);

  @override
  _TextInput2State createState() => _TextInput2State();
}

class _TextInput2State extends State<TextInput2> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.grey[100]),
        child: TextFormField(
          initialValue: widget.value,
          style: widget.inputStyle,
          textInputAction:
              widget.password! ? TextInputAction.done : TextInputAction.next,
          keyboardType: widget.inputType,
          obscureText: widget.password!,
          validator: widget.validator!,
          controller: widget.Controller,
          decoration: InputDecoration(
            prefixIcon: widget.inputIcon != null ? widget.inputIcon : null,
            errorStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            hintStyle: TextStyle(color: Colors.black54),
            labelText: widget.label,
            labelStyle: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
