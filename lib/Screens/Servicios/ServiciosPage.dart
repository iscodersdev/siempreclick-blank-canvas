import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:smart/API/Servicios/ServiciosAPI.dart';
import 'package:smart/API/Tarjetas/TarjetasAPI.dart';
import 'package:smart/Models/TarjetasModel/TarjetasModel.dart';
import 'package:smart/Widgets/InputText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ServiciosPage extends StatefulWidget {
  @override
  _ServiciosPageState createState() => _ServiciosPageState();
}

final storage = FlutterSecureStorage();

class _ServiciosPageState extends State<ServiciosPage> {
  bool Pago = false;
  String Servicio = 'nombre';
  String Barcode = '123';
  double? Monto;
  bool IngresoManual = false;
  dynamic Usuario = null;
  dynamic barcodeScanned = null;
  dynamic Saldo = null;
  int _currentIndex = 0;
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  List<MediosDePagoModel>? _tarjetas;
  bool _loading = false;
  final formatCurrency = new NumberFormat.simpleCurrency();
  ScanResult? barcodeScan;
  final BarController = TextEditingController();
  var options = ScanOptions(
      restrictFormat: <BarcodeFormat>[BarcodeFormat.interleaved2of5]);
  Future _scanBarcode() async {
    barcodeScan = await BarcodeScanner.scan(
      options: options,
    );
    String barcodeResult = barcodeScan!.rawContent.toString();
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetDetalleServicio(context, Usuario["UAT"], barcodeResult);
    String? detalle = await storage.read(key: 'ServicioDetalle');
    barcodeScanned = jsonDecode(detalle!);
    if (barcodeScanned['Status'] == 200) {
      Servicio = barcodeScanned['NombreServicio'];
      Monto = barcodeScanned['Monto'];
      Barcode = barcodeResult;
      await GetMedioDePago();
      setState(() {
        Pago = true;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  _IngresoManualInput() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetDetalleServicio(context, Usuario["UAT"], BarController.text);
    String? detalle = await storage.read(key: 'ServicioDetalle');
    barcodeScanned = jsonDecode(detalle!);
    if (barcodeScanned['Status'] == 200) {
      Servicio = barcodeScanned['NombreServicio'];
      Monto = barcodeScanned['Monto'];
      Barcode = BarController.text;
      await GetMedioDePago();
      setState(() {
        Pago = true;
        _loading = false;
      });
    } else {
      setState(() {
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
        (await tarjetasClases.getMediosDePago(context, Usuario['UAT'], 1));
    setState(() {
      Pago = true;
    });
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
              'Pagar Servicios',
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
      body: _loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Pago
                            ? Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Color(0xff3375bb),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(50),
                                        bottomRight: Radius.circular(50))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          Servicio,
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
                                            //    Text(Barcode, style: GoogleFonts.roboto(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, right: 30),
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 0.5,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 33.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Total a pagar:   ',
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            String.fromCharCodes(
                                                    new Runes('\u0024')) +
                                                Monto.toString(),
                                            style: GoogleFonts.roboto(
                                                fontSize: 19,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 25),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: Color(0xffe3e8ff),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            '¿Como desea pagar su Factura?',
                                            style: GoogleFonts.raleway(
                                                color: Colors.black54,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        IngresoManual
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: TextInput2(
                                                  label: 'Codigo de Factura',
                                                  Controller: BarController,
                                                  inputType:
                                                      TextInputType.number,
                                                  inputIcon: Icon(
                                                    Icons.keyboard,
                                                    color: Colors.black54,
                                                  ),
                                                  inputStyle: TextStyle(
                                                      color: Colors.black54),
                                                  validator: (String? text) {
                                                    if (text!.isEmpty) {
                                                      return 'Por favor completar el campo';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _loading = true;
                                                            });
                                                            _scanBarcode();
                                                          },
                                                          icon: Icon(
                                                            MdiIcons.barcode,
                                                            color: Color(
                                                                0xff3375bb),
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Codigo de Barras',
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 14),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  ///////////////////////////////////////////////END ICONO BARCODESCAN/////////////////////////////////////
                                                  Column(
                                                    children: [
                                                      Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              IngresoManual =
                                                                  true;
                                                            });
                                                          },
                                                          icon: Icon(
                                                            MdiIcons.keyboard,
                                                            color: Color(
                                                                0xff3375bb),
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Ingreso Manual',
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 14),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                                ////////////////////////////////////////////////////////////////////////////////////////////////Primer bloque
                                              ),
                                        IngresoManual
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  color: Colors.blue,
                                                ),
                                                height: 52,
                                                width: 300,
                                                child: CupertinoButton(
                                                  onPressed: () {
                                                    _IngresoManualInput();
                                                  },
                                                  child: Text(
                                                    "Continuar",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )),
                              ),
                        Pago
                            ? _tarjetas!.length == 0
                                ? Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                  //   cardNumber: _tarjetas![
                                                  //           _currentIndex]
                                                  //       .Descripcion!,
                                                  //   expiryDate: _tarjetas![
                                                  //           _currentIndex]
                                                  //       .DetalleAdicional!,
                                                  //   cardHolderName: '‏‏‎ ‏‏‎ ‎',
                                                  //   cvvCode: '112',
                                                  //   showBackView: false,
                                                  //   height: 160,
                                                  //   width:
                                                  //       MediaQuery.of(context)
                                                  //           .size
                                                  //           .width,
                                                  //   obscureCardCvv: true,
                                                  //   animationDuration: Duration(
                                                  //       milliseconds: 1000),
                                                  //   onCreditCardWidgetChange:
                                                  //       (CreditCardBrand) {},
                                                  // ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Container(
                                                    height: 160,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.2,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        // Where the linear gradient begins and ends
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
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
                                                              .withOpacity(
                                                                  0.97),
                                                          Color(0xff1b447b)
                                                              .withOpacity(
                                                                  0.90),
                                                          Color(0xff1b447b)
                                                              .withOpacity(
                                                                  0.86),
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
                                                                  right: 20,
                                                                  top: 10),
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
                                                                width: 70,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        image:
                                                                            DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/Images/logo_vertical.png"),
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
                                                                    fontSize:
                                                                        17,
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
                                    setState(() {
                                      _loading = true;
                                    });
                                    EnviarDineroServicio();
                                  },
                                  child: Text(
                                    "Pagar Servicio",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(),
                        IngresoManual
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  onPressed: () {
                                    setState(() {
                                      IngresoManual = false;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: Colors.black54,
                                      ),
                                      Container(
                                        width: 5,
                                      ),
                                      Text(
                                        'Volver',
                                        style: GoogleFonts.raleway(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container()
                      ]),
                ),
              ),
            ),
    );
  }
}
