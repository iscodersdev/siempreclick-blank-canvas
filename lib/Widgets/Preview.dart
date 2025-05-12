import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart/Models/noticia/Noticia.dart';
import 'package:smart/Screens/noticia/Noticia.dart';
import 'package:smart/Widgets/MyImagen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
final storage = FlutterSecureStorage();

class NoticiaPreview extends StatelessWidget {
  final NoticiaModel? noticia;

  NoticiaPreview({
    this.noticia,
  });

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = _width * 9 / 16;
    return GestureDetector(
      onTap: () {
        IrANoticia(context, noticia!.Id!.toString(), noticia!.Titulo!,
            noticia!.Texto!, noticia!.Fecha!.toString(), noticia!.Imagen!);

      },
      child: Card(
        elevation: 8,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: _width,
              height: MediaQuery.of(context).size.height / 3.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                child: MyImage(imageBytes: noticia!.Imagen),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Publicada el " + convertirFecha(noticia!.Fecha!.toString()),
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    noticia!.Titulo!,
                    style:
                    const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Tiempo estimado de lectura ${noticia!.calcularTiempoLectura()}",
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  SizedBox(child: Text(noticia!.resumen()!))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(8, 10) +
      "/" +
      Fecha.substring(5, 7) +
      "/" +
      Fecha.substring(0, 4) +
      " " +
      Fecha.substring(11, 16);
}

void IrANoticia(context, String Id, String Titulo, String Texto, String Fecha,
    Uint8List Imagen) {
  storage.write(key: "Titulo", value: Titulo);
  storage.write(key: "Texto", value: Texto);
  storage.write(key: "Fecha", value: Fecha);
  Imagen == null
      ? storage.write(key: "null", value: "null")
      : storage.write(key: "Imagen", value: base64Encode(Imagen));
  storage.write(key: "Id", value: Id);
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: NoticiaPage(),
    withNavBar: false, // OPTIONAL VALUE. True by default.
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}
