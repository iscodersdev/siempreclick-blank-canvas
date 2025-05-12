import 'package:flutter/material.dart';

class TextInput6 extends StatefulWidget {
  final String? label;
  final String? value;
  final bool? password;
  final TextInputType? inputType;
  final validator;
  final onChanged;
  final Icon? inputIcon;
  final TextStyle? inputStyle;
  final Controller;
  const TextInput6(
      {Key? key,
      this.Controller,
      this.onChanged,
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
  _TextInput6State createState() => _TextInput6State();
}

class _TextInput6State extends State<TextInput6> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: 50,
        decoration:
            BoxDecoration(shape: BoxShape.rectangle, color: Colors.grey[200]),
        child: TextFormField(
          onChanged: widget.onChanged,
          initialValue: widget.value,
          style: widget.inputStyle,
          textInputAction:
              widget.password! ? TextInputAction.done : TextInputAction.next,
          keyboardType: widget.inputType,
          obscureText: widget.password!,
          validator: widget.validator!,
          controller: widget.Controller!,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: widget.inputIcon != null ? widget.inputIcon : null,
            errorStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
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
