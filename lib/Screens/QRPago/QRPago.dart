import 'dart:convert';

import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:smart/API/Servicios/ServiciosAPI.dart';
import 'package:smart/API/Tarjetas/TarjetasAPI.dart';
import 'package:smart/Models/BilleterasModel/BilleteraModel.dart';
import 'package:smart/Models/TarjetasModel/TarjetasModel.dart';
import 'package:smart/services/alert.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final storage = FlutterSecureStorage();

class QRPagoPage extends StatefulWidget {
  const QRPagoPage({Key? key}) : super(key: key);

  @override
  _QRPagoPageState createState() => _QRPagoPageState();
}

class _QRPagoPageState extends State<QRPagoPage> {
  final _controller = TextEditingController();
  static const _locale = 'en';
  ScanResult? qrScan;
  bool Pago = false;
  BilleteraModel? selectedBilletera;
  bool loading = false;
  String CVU = 'xxxx';
  String Titular = 'Nombre';
  int _currentIndex = 0;
  dynamic Usuario = null;
  dynamic cvuScanned = null;
  dynamic Saldo = null;
  double? MontoBarcode = null;
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  List<BilleteraModel>? _billeteras;
  List<MediosDePagoModel>? _tarjetas;
  bool _loading = true;
  bool Monto = false;
  String Barcode = '123';
  bool Menu = true;
  bool Bar = false;
  ScanResult? barcodeScan;
  dynamic barcodeScanned = null;
  final formatCurrency = new NumberFormat.simpleCurrency();
  var barcodeoptions = ScanOptions(
      restrictFormat: <BarcodeFormat>[BarcodeFormat.interleaved2of5]);
  Future _scanBarcode() async {
    barcodeScan = await BarcodeScanner.scan(
      options: barcodeoptions,
    );
    String barcodeResult = barcodeScan!.rawContent.toString();
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetDetalleServicio(context, Usuario["UAT"], barcodeResult);
    String? detalle = await storage.read(key: 'ServicioDetalle');
    barcodeScanned = jsonDecode(detalle!);
    if (barcodeScanned['Status'] == 200) {
      Titular = barcodeScanned['NombreServicio'];
      MontoBarcode = barcodeScanned['Monto'];
      CVU = barcodeResult;
      await GetMedioDePago();
      setState(() {
        Pago = true;
        Bar = true;
        _loading = false;
      });
    } else {
      await GetMedioDePago();
      setState(() {
        Pago = true;
        Bar = true;
        _loading = false;
      });
    }
  }

  EnviarDineroServicio() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await EnvioServicio(
        context,
        Usuario['UAT'],
        Barcode,
        _tarjetas![_currentIndex].Id!,
        _tarjetas![_currentIndex].TipoMedioPago!);
  }

  GetSaldo() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetSaldoBilletera(context, Usuario['UAT']);
    String? jason = await storage.read(key: 'Saldo');
    Saldo = jsonDecode(jason!);
  }

  GetMedioDePago() async {
    await GetSaldo();
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Tarjetas tarjetasClases = Tarjetas();
    _tarjetas =
        (await tarjetasClases.getMediosDePago(context, Usuario['UAT'], 0));
    setState(() {
      Pago = true;
    });
  }

  GetBilleteras() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Billetera billeterasClases = Billetera();
    _billeteras =
        (await billeterasClases.getBilleteras(context, Usuario['UAT']));
    setState(() {
      _loading = false;
    });
  }

  Future _scanQR() async {
    qrScan = await BarcodeScanner.scan(
      options: options,
    );
    String qrResult = qrScan!.rawContent.toString();
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetCVUScanned(context, Usuario["UAT"], qrResult);
    String? cvu = await storage.read(key: 'CVU');
    cvuScanned = jsonDecode(cvu!);
    if (cvuScanned['Status'] == 200) {
      Titular = cvuScanned['Nombre'];
      CVU = qrResult;
      await GetMedioDePago();
      setState(() {
        Monto = false;
        Pago = true;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  EnviarDinero() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await EnvioBilletera(context, Usuario['UAT'], _controller.text, CVU);
  }

  var options = ScanOptions(restrictFormat: <BarcodeFormat>[BarcodeFormat.qr]);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetBilleteras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Menu
            ? null
            : AppBar(
                elevation: 0,
                backgroundColor: Color(0xff3375bb),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      Monto = false;
                      Pago = false;
                      Menu = true;
                    });
                  },
                ),
              ),
        backgroundColor: Pago ? Colors.white : Color(0xff3375bb),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: Menu
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Monto
                          ? Padding(
                              padding: const EdgeInsets.only(top: 150),
                              child: Center(
                                child: Text(
                                  'Monto a Enviar: ',
                                  style: GoogleFonts.raleway(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            )
                          : Container(),
                      Monto
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 5),
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: _controller,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    fontSize: 30, color: Colors.white),
                                decoration: InputDecoration(
                                  prefixText: _currency,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (string) {
                                  string =
                                      '${_formatNumber(string.replaceAll(',', ''))}';
                                  _controller.value = TextEditingValue(
                                    text: string,
                                    selection: TextSelection.collapsed(
                                        offset: string.length),
                                  );
                                },
                              ),
                            )
                          : Container(),
                      Monto
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 30, top: 30),
                              child: CupertinoButton(
                                onPressed: () {
                                  if (_controller.text != '') {
                                    setState(() {
                                      Menu = false;
                                      _loading = true;
                                    });
                                    _scanQR();
                                  } else {
                                    AlertPop.alert(context,
                                        body:
                                            Text('¡Primero Ingresa un Monto!'));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Siguiente  ',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_sharp,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      Pago
                          ? Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Color(0xff3375bb),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 5,
                                      ),
                                      Icon(
                                        CupertinoIcons.person_alt_circle,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                      Container(
                                        height: 5,
                                      ),
                                      Text(
                                        Titular,
                                        style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'CVU: ',
                                            style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            CVU,
                                            style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30, bottom: 2),
                                    child: Divider(
                                      color: Colors.white,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total:   ',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Bar
                                            ? Text(
                                                String.fromCharCodes(
                                                        new Runes('\u0024')) +
                                                    MontoBarcode.toString(),
                                                style: GoogleFonts.roboto(
                                                    fontSize: 19,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            : Text(
                                                String.fromCharCodes(
                                                        new Runes('\u0024')) +
                                                    _controller.text,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 19,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Menu
                          ? Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                '¿ Donde vamos?',
                                style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                            )
                          : Container(),
                      Menu
                          ? Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      Monto = true;
                                      Bar = false;
                                      Menu = false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          MdiIcons.qrcode,
                                          color: Color(0xff3375bb),
                                        ),
                                        Text(
                                          '  Enviar Dinero',
                                          style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff3375bb),
                                              fontSize: 23),
                                        )
                                      ],
                                    ),
                                  )),
                            )
                          : Container(),
                      Menu
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 30),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _loading = true;
                                    });
                                    _scanBarcode();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          MdiIcons.barcode,
                                          color: Color(0xff3375bb),
                                        ),
                                        Text(
                                          '  Pagar Servicios',
                                          style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff3375bb),
                                              fontSize: 23),
                                        )
                                      ],
                                    ),
                                  )),
                            )
                          : Container(),
                      //////////////////////////////////////////////////////////////------PAGO QR ---------/////////////////////////////////////////////////////////////////////////////
                      Pago
                          ? _tarjetas!.length == 0
                              ? Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 40.0),
                                        child: Icon(
                                          MdiIcons.creditCardOff,
                                          size: 35,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      Text(
                                        'No se encontraron Tarjetas',
                                        style: GoogleFonts.raleway(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Container(
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                )
                              : CarouselSlider(
                                  options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    autoPlay: false,
                                    height: 190,
                                    enlargeCenterPage: false,
                                    // enlargeCenterPage: true,
                                    //scrollDirection: Axis.vertical,
                                    onPageChanged: (index, reason) {
                                      setState(
                                        () {
                                          _currentIndex = index;
                                        },
                                      );
                                    },
                                  ),
                                  items: _tarjetas!
                                      .map(
                                        (item) => _tarjetas![_currentIndex]
                                                    .TipoMedioPago ==
                                                2
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                color: Colors.blue,
                                                // child: CreditCardWidget(
                                                //   textStyle: GoogleFonts.abel(
                                                //       color: Colors.white,
                                                //       fontSize: 18),
                                                //   cardNumber:
                                                //       _tarjetas![_currentIndex]
                                                //           .Descripcion!,
                                                //   expiryDate:
                                                //       _tarjetas![_currentIndex]
                                                //           .DetalleAdicional!,
                                                //   cardHolderName: '‏‏‎ ‎',
                                                //   cvvCode: '112',
                                                //   showBackView: false,
                                                //   height: 160,
                                                //   width: MediaQuery.of(context)
                                                //       .size
                                                //       .width,
                                                //   obscureCardCvv: true,
                                                //   animationDuration: Duration(
                                                //       milliseconds: 1000),
                                                //   onCreditCardWidgetChange:
                                                //       (CreditCardBrand) {},
                                                // ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Container(
                                                  height: 160,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.2,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      // Where the linear gradient begins and ends
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      // Add one stop for each color. Stops should increase from 0 to 1
                                                      stops: const <double>[
                                                        0.1,
                                                        0.4,
                                                        0.7,
                                                        0.9
                                                      ],
                                                      colors: <Color>[
                                                        Color(0xff1b447b)
                                                            .withOpacity(1),
                                                        Color(0xff1b447b)
                                                            .withOpacity(0.97),
                                                        Color(0xff1b447b)
                                                            .withOpacity(0.90),
                                                        Color(0xff1b447b)
                                                            .withOpacity(0.86),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 25.0,
                                                                right: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Billetera',
                                                              style: GoogleFonts.raleway(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Container(
                                                              height: 70,
                                                              width: 130,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/Images/logo_horizontalFullWhite.png"),
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 25.0,
                                                                bottom: 20,
                                                                right: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              'Saldo Disponible:',
                                                              style: GoogleFonts.raleway(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Text(
                                                              '${formatCurrency.format(Saldo['Saldo'])}',
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      )
                                      .toList(),
                                )
                          : Container(),
                      Pago
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _tarjetas!.map((urlOfItem) {
                                  int index = _tarjetas!.indexOf(urlOfItem);
                                  return Container(
                                    width: 10.0,
                                    height: 10.0,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentIndex == index
                                          ? Color.fromRGBO(0, 0, 0, 0.5)
                                          : Color.fromRGBO(0, 0, 0, 0.3),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : Container(),
                      Pago
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.blue,
                              ),
                              height: 52,
                              width: 300,
                              child: CupertinoButton(
                                onPressed: () {
                                  Bar ? EnviarDineroServicio() : EnviarDinero();
                                },
                                child: Text(
                                  "Enviar Dinero",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ));
  }
}
