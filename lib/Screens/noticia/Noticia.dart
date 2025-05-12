import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart/Widgets/MyImagen.dart';

final storage = FlutterSecureStorage();

class NoticiaPage extends StatefulWidget {
  @override
  _NoticiaPageState createState() => _NoticiaPageState();
}

class _NoticiaPageState extends State<NoticiaPage> {
  String? Titulo;
  String? Texto;
  String? Fecha;
  int Id = 0;
  Uint8List? Imagen;
  bool noImage = false;
  String? nonull;
  bool _loading = true;

  @override
  initState() {
    super.initState();
    getNoticia();
  }

  getNoticia() async {
    String? id_string = await storage.read(key: "Id");
    String? imagen_string = await storage.read(key: "Imagen");
    Titulo = await storage.read(key: "Titulo");
    Texto = await storage.read(key: "Texto");
    Fecha = await storage.read(key: "Fecha");
    Id = int.parse(id_string!);
    Imagen = base64Decode(imagen_string!);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _loading
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                )
              : CustomScrollView(
                  slivers: <Widget>[
                    _crearAppbar(),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Publicada el " + convertirFecha(Fecha!),
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                Titulo!,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6.0),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(Texto!)
                            ],
                          ),
                        )
                      ]),
                    )
                  ],
                )),
    );
  }

  Widget _crearAppbar() {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = _width * 9 / 16;
    return SliverAppBar(
      elevation: 2.0,
      iconTheme: IconThemeData(color: Colors.white),
      expandedHeight: MediaQuery.of(context).size.height / 4,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Hero(
                tag: Id,
                child: Container(
                  width: _width,
                  height: MediaQuery.of(context).size.height / 4,
                  child: MyImage(imageBytes: Imagen,boxFit: BoxFit.scaleDown),
                )),
            Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                    Colors.black26,
                    Colors.transparent,
                  ])),
            )
          ],
        ),
      ),
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    htmlText = htmlText.replaceAll('&aacute;', 'á');
    htmlText = htmlText.replaceAll('&eacute;', 'é');
    htmlText = htmlText.replaceAll('&iacute;', 'í');
    htmlText = htmlText.replaceAll('&oacute;', 'ó');
    htmlText = htmlText.replaceAll('&uacute;', 'ú');
    htmlText = htmlText.replaceAll('&nacute;', 'ñ');
    htmlText = htmlText.replaceAll('&Aacute;', 'Á');
    htmlText = htmlText.replaceAll('&Eacute;', 'É');
    htmlText = htmlText.replaceAll('&Iacute;', 'Í');
    htmlText = htmlText.replaceAll('&Oacute;', 'Ó');
    htmlText = htmlText.replaceAll('&Uacute;', 'Ú');
    htmlText = htmlText.replaceAll('&Nacute;', 'Ñ');

    return htmlText.replaceAll(exp, '');
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
  //return Fecha;
}
