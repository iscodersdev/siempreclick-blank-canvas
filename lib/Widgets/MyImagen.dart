import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String? imageBase64;
  final Uint8List? imageBytes;
  final BoxFit? boxFit;
  final bool? placeholder;

  const MyImage({
    Key? key,
    this.imageBase64,
    this.imageBytes,
    this.boxFit = BoxFit.fill,
    this.placeholder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      if (imageBase64 != null && imageBase64!.isNotEmpty) {
        return Image.memory(
          base64Decode(imageBase64!),
          fit: boxFit,
        );
      } else if (imageBytes != null && imageBytes!.isNotEmpty) {
        return Image.memory(
          imageBytes!,
          fit: boxFit,
        );
      }
    } catch (e) {
      print(e.toString());
    }
    if (placeholder!)
      return Image(image: AssetImage('assets/images/perfil_placeholder.png'));
    else
      return Container();
  }
}
