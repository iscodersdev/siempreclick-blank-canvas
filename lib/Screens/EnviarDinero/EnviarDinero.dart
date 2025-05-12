import 'dart:convert';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:smart/API/Tarjetas/TarjetasAPI.dart';
import 'package:smart/Models/BilleterasModel/BilleteraModel.dart';
import 'package:smart/Models/TarjetasModel/TarjetasModel.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EnviarDineroPage extends StatefulWidget {
  @override
  _EnviarDineroPageState createState() => _EnviarDineroPageState();
}

final storage = FlutterSecureStorage();

class _EnviarDineroPageState extends State<EnviarDineroPage> {
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
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  List<BilleteraModel>? _billeteras;
  List<MediosDePagoModel>? _tarjetas;
  bool _loading = true;
  final formatCurrency = new NumberFormat.simpleCurrency();

  GetSaldo() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetSaldoBilletera(context, Usuario['UAT']);
    String? jason = await storage.read(key: 'Saldo');
    Saldo = jsonDecode(jason!);
  }

  GetMedioDePago(int enter) async {
    if (enter == 1) {
      Navigator.pop(context);
      await GetSaldo();
      String? User = await storage.read(key: 'USER');
      Usuario = jsonDecode(User!);
      Tarjetas tarjetasClases = Tarjetas();
      _tarjetas =
          (await tarjetasClases.getMediosDePago(context, Usuario['UAT'], 0));
      //_tarjetas.removeWhere((element) => )
      setState(() {
        Pago = true;
        _loading = false;
      });
    } else {
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
    String? qrResult = qrScan!.rawContent.toString();
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetCVUScanned(context, Usuario["UAT"], qrResult);
    String? cvu = await storage.read(key: 'CVU');
    cvuScanned = jsonDecode(cvu!);
    if (cvuScanned['Status'] == 200) {
      Titular = cvuScanned['Nombre'];
      CVU = qrResult;
      await GetMedioDePago(0);
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

  EnviarDinero() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await EnvioBilletera(context, Usuario['UAT'], _controller.text, CVU);
  }

  var options =
      const ScanOptions(restrictFormat: <BarcodeFormat>[BarcodeFormat.qr]);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetBilleteras();
  }

  FocusNode focusNode = new FocusNode();
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
              Pago
                  ? Text(
                      'Enviar Dinero',
                      style: GoogleFonts.raleway(
                          fontSize: 20, color: Colors.white),
                    )
                  : Text(
                      'Enviar Dinero',
                      style: GoogleFonts.raleway(
                          fontSize: 35, color: Colors.white),
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
                      children: [
                        Pago
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Text(
                                    'Monto a Enviar: ',
                                    style: GoogleFonts.raleway(
                                        fontSize: 20, color: Colors.black54),
                                  ),
                                ),
                              ),
                        Pago
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 50, right: 50, top: 5),
                                child: TextField(
                                  controller: _controller,
                                  focusNode: focusNode,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(fontSize: 30),
                                  decoration: InputDecoration(
                                    prefixText: _currency,
                                  ),
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
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
                              ),
                        Pago
                            ? Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Color(0xfff68712),
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
                                          Text(
                                            String.fromCharCodes(
                                                    new Runes('\u0024')) +
                                                _controller.text,
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
                                    left: 15, right: 15, top: 80),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Color(0xffffe7d9),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: loading
                                      ? Container(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                '¿ A quien le desea enviar?',
                                                style: GoogleFonts.raleway(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                          child: IconButton(
                                                            onPressed: () {
                                                              if (_controller
                                                                      .text !=
                                                                  '') {
                                                                setState(() {
                                                                  _loading =
                                                                      true;
                                                                });
                                                                _scanQR();
                                                              } else {
                                                                AlertPop.alert(
                                                                    context,
                                                                    body: Text(
                                                                        '¡Primero Ingresa un Monto!'));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              MdiIcons.qrcode,
                                                              color: Color(
                                                                  0xfff68712),
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'Pago con QR',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  //////////////////////////////////////////////////////////////////// END PAGO QR//////
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                          child: IconButton(
                                                            onPressed: () {
                                                              if (_controller
                                                                      .text !=
                                                                  '') {
                                                                if (_billeteras!
                                                                        .length !=
                                                                    0) {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Dialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            elevation:
                                                                                0,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Container(
                                                                                        padding: EdgeInsets.all(10),
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        decoration: BoxDecoration(
                                                                                            color: Color(0xfff68712),
                                                                                            borderRadius: BorderRadius.only(
                                                                                              topLeft: Radius.circular(15),
                                                                                              topRight: Radius.circular(15),
                                                                                            )),
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          'Contactos',
                                                                                          style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                        ))),
                                                                                    Container(
                                                                                      height: 150,
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      decoration: BoxDecoration(
                                                                                          color: Colors.white,
                                                                                          borderRadius: BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(15),
                                                                                            bottomRight: Radius.circular(15),
                                                                                          )),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                                                                                            child: Container(
                                                                                              padding: EdgeInsets.all(2),
                                                                                              decoration: BoxDecoration(
                                                                                                  color: Colors.white,
                                                                                                  boxShadow: [
                                                                                                    BoxShadow(
                                                                                                      color: Colors.black12,
                                                                                                      spreadRadius: 3,
                                                                                                      blurRadius: 10,
                                                                                                      offset: Offset(0, 5), // changes position of shadow
                                                                                                    ),
                                                                                                  ],
                                                                                                  borderRadius: BorderRadius.circular(10)),
                                                                                              alignment: Alignment.center,
                                                                                              child: DropdownButtonFormField<BilleteraModel>(
                                                                                                decoration: InputDecoration(enabledBorder: InputBorder.none, contentPadding: EdgeInsets.only(right: 10)),
                                                                                                hint: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 12, right: 15),
                                                                                                      child: Icon(
                                                                                                        Icons.person,
                                                                                                        color: Colors.black54,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Center(
                                                                                                        child: Text(
                                                                                                      "Lista de Contactos",
                                                                                                      style: GoogleFonts.roboto(
                                                                                                        fontSize: 15,
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        color: Colors.black54,
                                                                                                      ),
                                                                                                      textAlign: TextAlign.center,
                                                                                                    )),
                                                                                                  ],
                                                                                                ),
                                                                                                isExpanded: true,
                                                                                                value: selectedBilletera,
                                                                                                icon: Icon(
                                                                                                  Icons.arrow_drop_down,
                                                                                                  color: Colors.black54,
                                                                                                ),
                                                                                                onChanged: (BilleteraModel? newValueServicio) {
                                                                                                  setState(() {
                                                                                                    selectedBilletera = newValueServicio;
                                                                                                  });
                                                                                                },
                                                                                                items: _billeteras!.map((BilleteraModel servicio) {
                                                                                                  return DropdownMenuItem<BilleteraModel>(
                                                                                                    value: servicio,
                                                                                                    child: Container(
                                                                                                      padding: EdgeInsets.only(right: 10),
                                                                                                      child: Center(
                                                                                                        child: Text(
                                                                                                          servicio.Titular!,
                                                                                                          style: GoogleFonts.roboto(
                                                                                                            fontSize: 15,
                                                                                                            fontWeight: FontWeight.w400,
                                                                                                            color: Colors.black87,
                                                                                                          ),
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                }).toList(),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: MediaQuery.of(context).size.width,
                                                                                            padding: EdgeInsets.only(right: 30, left: 30),
                                                                                            child: GestureDetector(
                                                                                                onTap: () {
                                                                                                  setState(() {
                                                                                                    _loading = true;
                                                                                                    Titular = selectedBilletera!.Titular!;
                                                                                                    CVU = selectedBilletera!.CVU!;
                                                                                                  });
                                                                                                  GetMedioDePago(1);
                                                                                                },
                                                                                                child: Text(
                                                                                                  'Continuar',
                                                                                                  style: GoogleFonts.raleway(color: Colors.white, fontSize: 14),
                                                                                                ),
                                                                                               ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ));
                                                                      });
                                                                } else {
                                                                  AlertPop.alert(
                                                                      context,
                                                                      body: Text(
                                                                          '¡No posee Contactos!'));
                                                                }
                                                              } else {
                                                                AlertPop.alert(
                                                                    context,
                                                                    body: Text(
                                                                        '¡Primero Ingresa un Monto!'));
                                                              }
                                                              /////////////////////////////////////////////////////////////////////CONTACTOS POPUP
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .import_contacts_rounded,
                                                              color: Color(
                                                                  0xfff68712),
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'Contactos',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 17),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                          child: IconButton(
                                                            onPressed: () {
                                                              if (_controller
                                                                      .text !=
                                                                  '') {
                                                              } else {
                                                                AlertPop.alert(
                                                                    context,
                                                                    body: Text(
                                                                        '¡Primero Ingresa un Monto!'));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              CupertinoIcons
                                                                  .person_2,
                                                              color: Color(
                                                                  0xfff68712),
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'Recientes',
                                                            style: GoogleFonts
                                                                .raleway(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
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
                                                  //   cardHolderName: '',
                                                  //   cvvCode: '112',
                                                  //   showBackView: false,
                                                  //   height: 160,
                                                  //   width:
                                                  //       MediaQuery.of(context)
                                                  //           .size
                                                  //           .width,
                                                  //   obscureCardCvv: true,
                                                  //   animationDuration:
                                                  //       const Duration(
                                                  //           milliseconds: 1000),
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
                                                          const Color(
                                                              0xfff68712)
                                                              .withOpacity(1),
                                                          const Color(
                                                              0xfff68712)
                                                              .withOpacity(
                                                                  0.97),
                                                          const Color(
                                                              0xfff68712)
                                                              .withOpacity(
                                                                  0.90),
                                                          const Color(
                                                              0xfff68712)
                                                              .withOpacity(
                                                                  0.86),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
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
                                                                    const BoxDecoration(
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentIndex == index
                                            ? const Color.fromRGBO(0, 0, 0, 0.5)
                                            : const Color.fromRGBO(
                                                0, 0, 0, 0.3),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : Container(),
                        Pago
                            ? Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Color(0xfff68712),
                                ),
                                height: 52,
                                width: 300,
                                child: CupertinoButton(
                                  onPressed: () {
                                    EnviarDinero();
                                  },
                                  child: const Text(
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
                ),
              ));
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(8, 10) +
      "/" +
      Fecha.substring(5, 7) +
      "/" +
      Fecha.substring(0, 4);
}

String convertirFecha2(String Fecha) {
  return Fecha.substring(0, 2) + "/" + Fecha.substring(3, 5);
}
