import 'dart:convert';
import 'dart:typed_data';
import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:smart/API/Prestamos/PrestamosApi.dart';
import 'package:smart/Models/Prestamos/PrestamosModel.dart';
import 'package:smart/Screens/Proveedores/CompraCuotas.dart';
import 'package:smart/Widgets/MyImagen.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class VerCompra extends StatefulWidget {
  @override
  _VerCompraState createState() => _VerCompraState();
}

final storage = FlutterSecureStorage();

class _VerCompraState extends State<VerCompra> {
  String? Nombre;
  String? Desc;
  String? FotoS;
  String? Precio;
  bool _loading = true;
  Uint8List? Foto;
  dynamic Usuario = null;
  String Montosdisp = '1';
  String ProdId = '';
  String ProdEstado = '';
  String ProdFechaCompra = '';
  List<PlanesDisponibles> montos = [];
  getProducto() async {
    Nombre = await storage.read(key: 'ProdNombre');
    Desc = await storage.read(key: 'ProdDetail');
    FotoS = await storage.read(key: 'ProdFoto');
    Precio = await storage.read(key: 'ProdPrecio');
    ProdId = (await storage.read(key: 'ProdID'))!;
    ProdEstado = (await storage.read(key: 'ProdEstado'))!;
    ProdFechaCompra = (await storage.read(key: 'ProdFechaCompra'))!;
    GetSaldo();
  }

  String Saldo = '';
  bool Billetera = true;
  GetSaldo() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetSaldoBilletera(context, Usuario['UAT']);
    Saldo = (await storage.read(key: 'Saldo'))!;
    String? billetera = await storage.read(key: 'Billetera');
    if (billetera == 'false') {
      Billetera = false;
    }
    setState(() {
      _loading = false;
    });
  }

  ComprarProducto() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    Prestamos Class = Prestamos();
    //await Class.ComprarConFondos(context, Usuario["UAT"], int.parse(ProdId));
    setState(() {
      _loading = false;
    });
  }

  final formatCurrency = new NumberFormat.simpleCurrency();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      child: ClipRRect(
                        child: MyImage(
                          imageBytes: Uint8List.fromList(FotoS!.codeUnits),
                          boxFit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 30.0, left: 30,top: 10,bottom: 10),
                            child: Text(
                              Nombre!,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600, fontSize: 25),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 10, bottom: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Estado de Compra: ',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color(0XFF39a67b),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            ProdEstado,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ))),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, top: 10, bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Comprado el ' +
                                      convertirFecha(ProdFechaCompra),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                )),
                          ),
                          Container(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 30.0, left: 30),
                            child: Divider(
                              thickness: 1.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, top: 10, bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Detalles:',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.raleway(),
                                )),
                          ),
                          Desc != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 10, bottom: 10),
                                  child: Container(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            Desc!,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(),
                                          ))),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 10, bottom: 10),
                                  child: Container(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Producto sin Descripcion ampliada',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(),
                                          ))),
                                ),
                          Container(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String convertirFecha(String Fecha) {
    return Fecha.substring(8, 10) +
        "/" +
        Fecha.substring(5, 7) +
        "/" +
        Fecha.substring(0, 4);
  }
}
