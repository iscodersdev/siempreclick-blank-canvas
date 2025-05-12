import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart/API/Prestamos/PrestamosApi.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

final storage = FlutterSecureStorage();
String? NombreLiquidacion;

class VerLegajoPage extends StatefulWidget {
  @override
  _VerLegajoPageState createState() => _VerLegajoPageState();
}

class _VerLegajoPageState extends State<VerLegajoPage> {
  String? documentPath;
  String? UAT;
  String? Id;
  String? Tipo;
  String? UrlAfip;
  String? Descripcion;
  bool _loading = true;
  dynamic Usuario = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAfipDocumento();
    setState(() {
      _loading = false;
    });
  }

  getAfipDocumento() async {
    Id = await storage.read(key: "PrestamoID");
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    String UAT = Usuario['UAT'];
    Prestamos documentoAfipClases = Prestamos();
    await documentoAfipClases.getLegajo(context, Usuario["UAT"], Id!);
    var dir = await getTemporaryDirectory();
    String? jason2 = await storage.read(key: "Binario");
    dynamic _decodedJson = jsonDecode(jason2!);
    Uint8List Binario = base64Decode(_decodedJson["LegajoElectronico"]
        .replaceFirst('data:application/pdf;base64,', ''));
    documentPath = "${dir.path}/Binario.pdf";
    final file = new File(documentPath!);
    file.writeAsBytes(Binario, flush: true);
    UrlAfip =
        "http://portalsmartclick.com.ar/api/mprestamos/DescargaLegajoElectronico?uat=$UAT&PrestamoId=$Id";
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: SizedBox(
                    child: documentPath != null
                        ? PDFView(
                            filePath: documentPath,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: true,
                            pageSnap: true,
                            fitPolicy: FitPolicy.BOTH,
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.cloud_download),
        label: Text("Descargar"),
        backgroundColor: Colors.blue,
        onPressed: () => launch(UrlAfip!),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void goBack(context) {
    Navigator.pop(context);
  }
}
