import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:smart/API/Tarjetas/TarjetasAPI.dart';
import 'package:smart/Models/BilleterasModel/BilleteraModel.dart';
import 'package:smart/Models/TarjetasModel/TarjetasModel.dart';
import 'package:smart/services/InputText.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TransferirDineroPage extends StatefulWidget {
  @override
  _TransferirDineroPageState createState() => _TransferirDineroPageState();
}

class _TransferirDineroPageState extends State<TransferirDineroPage> {
  final _controller = TextEditingController();
  List<BilleteraModel>? _billeteras;
  List<BilleteraTercerosModel>? _billeterasTerceros;
  dynamic Usuario = null;
  BilleteraModel? selectedBilletera;
  BilleteraTercerosModel? selectedBilleteraTerceros;
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  final formatCurrency = new NumberFormat.simpleCurrency();
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  bool _loading = true;
  bool Contacto = false;
  bool Pago = false;
  String Destino = '';
  List<MediosDePagoModel>? _tarjetas;
  String CVU = '';
  int _currentIndex = 0;
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

  dynamic Saldo = null;
  GetSaldo() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetSaldoBilletera(context, Usuario['UAT']);
    String? jason = await storage.read(key: 'Saldo');
    Saldo = jsonDecode(jason!);
  }

  GetMedioDePago() async {
    Navigator.pop(context);
    await GetSaldo();
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Tarjetas tarjetasClases = Tarjetas();
    _tarjetas =
        (await tarjetasClases.getMediosDePago(context, Usuario['UAT'], 0));
    setState(() {
      Pago = true;
      _loading = false;
    });
  }

  GetBilleterasTerceros() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Billetera billeterasClases = Billetera();
    _billeterasTerceros =
        (await billeterasClases.getBilleterasTerceros(context, Usuario['UAT']));
    GetBilleteras();
  }

  EnviarDinero() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await EnvioBilletera(context, Usuario['UAT'], _controller.text, CVU);
  }

  TransferirDinero() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await TransferirBilletera(
        context,
        Usuario['UAT'],
        _controller.text,
        _tarjetas![_currentIndex].Id!,
        _tarjetas![_currentIndex].TipoMedioPago!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetBilleterasTerceros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff3375bb),
        toolbarHeight: MediaQuery.of(context).size.height / 4,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Column(
          children: [
            Container(
              height: 75,
              width: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/Images/logo1.png"),
              )),
            ),
            Text(
              'Transferir Dinero',
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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Pago
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              'Monto a Transferir: ',
                              style: GoogleFonts.raleway(
                                  fontSize: 20, color: Colors.black54),
                            ),
                          ),
                        ),
                  Pago
                      ? Container()
                      : Padding(
                          /////////////////////////////////////////////////////////////////////////////////////////////////Inicio Bloque Eleccion
                          padding: const EdgeInsets.only(
                              left: 50, right: 50, top: 5),
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(fontSize: 30),
                            decoration: InputDecoration(
                              prefixText: _currency,
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
                        ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          'assets/Images/TransferirIconWhite.png'),
                                    )),
                                  ),
                                  //Icon(CupertinoIcons.person_alt_circle, color: Colors.white, size: 70,),
                                  Container(
                                    height: 5,
                                  ),
                                  Text(
                                    Destino,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 50.0, right: 50, bottom: 2),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 0.5,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                              left: 20, right: 20, top: 25),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Color(0xffe3e8ff),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      '¿Donde Desea Transferir el Dinero?',
                                      style: GoogleFonts.raleway(
                                          color: Colors.black54,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                if (_controller.text != '') {
                                                  if (_billeteras!.length !=
                                                      0) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              elevation: 0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                          padding: EdgeInsets.all(
                                                                              10),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          decoration: BoxDecoration(
                                                                              color: Color(0xff3375bb),
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(15),
                                                                                topRight: Radius.circular(15),
                                                                              )),
                                                                          child: Center(
                                                                              child: Text(
                                                                            'Contactos',
                                                                            style: GoogleFonts.roboto(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16),
                                                                          ))),
                                                                      Container(
                                                                        height:
                                                                            150,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(15),
                                                                              bottomRight: Radius.circular(15),
                                                                            )),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
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
                                                                                  items: _billeteras!.map((BilleteraModel? servicio) {
                                                                                    return new DropdownMenuItem<BilleteraModel>(
                                                                                      value: servicio,
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.only(right: 10),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            servicio!.Titular!,
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
                                                                                      Pago = true;
                                                                                      Contacto = true;
                                                                                      _loading = true;
                                                                                      Destino = selectedBilletera!.Titular!;
                                                                                      CVU = selectedBilletera!.CVU!;
                                                                                    });
                                                                                    GetMedioDePago();
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
                                                    AlertPop.alert(context,
                                                        body: Text(
                                                            '¡No posee Contactos!'));
                                                  }
                                                } else {
                                                  AlertPop.alert(context,
                                                      body: Text(
                                                          '¡Primero Ingresa un Monto!'));
                                                }
                                                /////////////////////////////////////////////////////////////////////CONTACTOS POPUP
                                              },
                                              icon: Icon(
                                                MdiIcons.account,
                                                color: Color(0xff3375bb),
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Contactos',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                  color: Colors.black54,
                                                  fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),
                                      //////////////////////////////////////////////////////////////////////////////////////////SEGUNDO BLOQUE
                                      Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                if (_controller.text != '') {
                                                  if (_billeterasTerceros!
                                                          .length !=
                                                      0) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              elevation: 0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                          padding: EdgeInsets.all(
                                                                              10),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          decoration: BoxDecoration(
                                                                              color: Color(0xff3375bb),
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(15),
                                                                                topRight: Radius.circular(15),
                                                                              )),
                                                                          child: Center(
                                                                              child: Text(
                                                                            'Cuentas',
                                                                            style: GoogleFonts.roboto(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16),
                                                                          ))),
                                                                      Container(
                                                                        height:
                                                                            150,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(15),
                                                                              bottomRight: Radius.circular(15),
                                                                            )),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
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
                                                                                child: DropdownButtonFormField<BilleteraTercerosModel>(
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
                                                                                        "Cuentas de Terceros",
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
                                                                                  value: selectedBilleteraTerceros,
                                                                                  icon: Icon(
                                                                                    Icons.arrow_drop_down,
                                                                                    color: Colors.black54,
                                                                                  ),
                                                                                  onChanged: (BilleteraTercerosModel? newValueServicio) {
                                                                                    setState(() {
                                                                                      selectedBilleteraTerceros = newValueServicio;
                                                                                    });
                                                                                  },
                                                                                  items: _billeterasTerceros!.map((BilleteraTercerosModel servicio) {
                                                                                    return new DropdownMenuItem<BilleteraTercerosModel>(
                                                                                      value: servicio,
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.only(right: 10),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            servicio.CBU! + '\n' + servicio.Descripcion!,
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
                                                                                      Pago = true;
                                                                                      _loading = true;
                                                                                      Destino = selectedBilleteraTerceros!.Descripcion!;
                                                                                    });
                                                                                    GetMedioDePago();
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
                                                    AlertPop.alert(context,
                                                        body: Text(
                                                            '¡No posee Cuentas de Terceros!'));
                                                  }
                                                } else {
                                                  AlertPop.alert(context,
                                                      body: Text(
                                                          '¡Primero Ingresa un Monto!'));
                                                }
                                                /////////////////////////////////////////////////////////////////////CONTACTOS TERCEROS POPUP
                                              },
                                              icon: Icon(
                                                Icons.group,
                                                color: Color(0xff3375bb),
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Cuentas de \nTerceros',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                  color: Colors.black54,
                                                  fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ),
                  Pago
                      ? _tarjetas!.length == 0
                          ? Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
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
                                            //   animationDuration:
                                            //       Duration(milliseconds: 1000),
                                            //   onCreditCardWidgetChange:
                                            //       (CreditCardBrand) {},
                                            // ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(15.0),
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                          style: GoogleFonts
                                                              .raleway(
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
                                                        const EdgeInsets.only(
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
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        Text(
                                                          '${formatCurrency.format(Saldo['Saldo'])}',
                                                          style: GoogleFonts
                                                              .roboto(
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
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Color(0xff3375bb),
                          ),
                          height: 52,
                          width: 300,
                          child: CupertinoButton(
                            onPressed: () {
                              Contacto ? EnviarDinero() : TransferirDinero();
                            },
                            child: Text(
                              "Transferir Dinero",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      : Container(),
                ],
              )),
            ),
    );
  }
}
