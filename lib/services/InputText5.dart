import 'package:flutter/material.dart';

class TextInput5 extends StatefulWidget {
  final String? label;
  final bool? password;
  final Controller;
  final TextInputType? inputType;
  final validator;
  final Icon? inputIcon;
  final TextStyle? inputStyle;
  final onPresed;

  const TextInput5(
      {Key? key,
      this.onPresed,
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
  _TextInput5State createState() => _TextInput5State();
}

class _TextInput5State extends State<TextInput5> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 212,
            decoration:
                BoxDecoration(shape: BoxShape.rectangle, color: Colors.black54),
            child: TextFormField(
              style: widget.inputStyle,
              controller: widget.Controller,
              textInputAction: widget.password!
                  ? TextInputAction.done
                  : TextInputAction.next,
              keyboardType: widget.inputType,
              obscureText: widget.password!,
              validator: widget.validator,
              decoration: InputDecoration(
                prefixIcon: widget.inputIcon != null ? widget.inputIcon : null,
                errorStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                labelText: widget.label,
                labelStyle:
                    TextStyle(color: Color.fromARGB(100, 200, 201, 241)),
              ),
            ),
          ),
        ),
        GestureDetector(
            onTap: widget.onPresed,
            child: Container(
              width: 50,
              height: 50,
              child: Center(
                  child: Icon(
                Icons.search,
                color: Colors.white,
              )),
            )),
      ]),
    );
  }
}
