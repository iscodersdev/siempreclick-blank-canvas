import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput3 extends StatefulWidget {
  final String? label;
  final bool? password;
  final TextInputType? inputType;
  final validator;
  final Icon? inputIcon;
  final TextStyle? inputStyle;
  final Controller;
  final MaxLenght;
  final String? initial;
  final onChanged;

  const TextInput3(
      {Key? key,
      this.MaxLenght,
      this.onChanged,
      this.initial,
      this.Controller,
      this.label,
      this.password = false,
      this.inputType,
      this.validator,
      this.inputIcon,
      this.inputStyle =
          const TextStyle(color: Color.fromARGB(100, 200, 201, 241))})
      : super(key: key);

  @override
  _TextInput3State createState() => _TextInput3State();
}

class _TextInput3State extends State<TextInput3> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(16),
          ],
          onChanged: widget.onChanged,
          controller: widget.Controller,
          style: widget.inputStyle,
          textInputAction:
              widget.password! ? TextInputAction.done : TextInputAction.next,
          keyboardType: widget.inputType,
          obscureText: widget.password!,
          validator: widget.validator,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: widget.inputIcon != null ? widget.inputIcon : null,
            errorStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            hintStyle: TextStyle(color: Colors.black54),
            labelText: widget.label,
            hintText: widget.initial,
            labelStyle: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
