import 'dart:async';
import 'dart:convert';
import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

final storage = FlutterSecureStorage();

class RecibirDineroPage extends StatefulWidget {
  @override
  _RecibirDineroPageState createState() => _RecibirDineroPageState();
}

class _RecibirDineroPageState extends State<RecibirDineroPage> {
  bool loading = true;
  final _controller = TextEditingController();
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  dynamic Usuario = null;
  dynamic CVU = null;
  bool QR = false;
  getCVU() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetCVU(context, Usuario['UAT']);
    String? jason = await storage.read(key: 'CVU');
    CVU = jsonDecode(jason!);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCVU();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xfff68712),
        toolbarHeight: MediaQuery.of(context).size.height / 4,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Column(
          children: [
            // Container(
            //   height: 75,
            //   width: 250,
            //   decoration: BoxDecoration(
            //       image: DecorationImage(
            //     image: AssetImage("assets/Images/logo1.png"),
            //   )),
            // ),
            Text(
              'Recibir Dinero',
              style: GoogleFonts.raleway(fontSize: 35, color: Colors.white),
            ),
          ],
        ),
        leading: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )),
      ),
      body: loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(children: <Widget>[
                  QR
                      ? Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              'Codigo QR generado con exito! ',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, color: Colors.black54),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              'Seleccione el metodo de pago: ',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, color: Colors.black54),
                            ),
                          ),
                        ),
                  ////////////////////////////////////////////////BLOQUE
                  QR
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 40),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color(0xffe3e8ff),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.7,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(17.0),
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: QrImageView(
                                        data: CVU['CVU'],
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    'CVU: ' + CVU['CVU'],
                                    style: GoogleFonts.roboto(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            ////////////////////////////////////////////////////////////////////////END QR BLOCK////////////////////////////////////////////////////////////
                          ))
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 40),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color(0xffe3e8ff),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              MdiIcons.qrcode,
                                              color: Color(0xff3375bb),
                                              size: 50,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                loading = true;
                                                QR = true;
                                              });
                                              Timer(Duration(seconds: 2), () {
                                                setState(() {
                                                  loading = false;
                                                });
                                              });
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Generar QR',
                                            style: GoogleFonts.raleway(
                                                color: Colors.black54,
                                                fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),

                                    ////////////////////////////////////////////////////////////////////////////////////////////////Primer bloque
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.link,
                                              color: Color(0xff3375bb),
                                              size: 50,
                                            ),
                                            onPressed: () {
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Link de Pago',
                                            style: GoogleFonts.raleway(
                                                color: Colors.black54,
                                                fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ]),
              ),
            ),
    );
  }
}
