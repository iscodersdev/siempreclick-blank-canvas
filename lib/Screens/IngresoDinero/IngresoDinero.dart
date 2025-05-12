import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart/API/IngresoDinero/IngresoDineroAPI.dart';
import 'package:smart/API/Tarjetas/TarjetasAPI.dart';
import 'package:smart/Models/TarjetasModel/TarjetasModel.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class IngresoDineroPage extends StatefulWidget {
  @override
  _IngresoDineroPageState createState() => _IngresoDineroPageState();
}

final storage = FlutterSecureStorage();

class _IngresoDineroPageState extends State<IngresoDineroPage> {
  final _controller = TextEditingController();
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  bool IngresoTarjeta = false;
  bool IngresoCuenta = false;
  int _currentIndex = 0;
  bool Seleccion = true;
  dynamic Usuario = null;
  bool loading = true;
  List<MediosDePagoModel>? _tarjetas;
  bool _loading = true;
  GetMedioDePago() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Tarjetas tarjetasClases = Tarjetas();
    _tarjetas =
        (await tarjetasClases.getMediosDePago(context, Usuario['UAT'], 1));
    _tarjetas!.removeAt(0);
    setState(() {
      loading = false;
      IngresoTarjeta = true;
    });
  }

  IngresarDinero(int MetodoPago, int TipoMedioPago) async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await IngresoDinero(context, Usuario['UAT'], double.parse(_controller.text),
        MetodoPago, TipoMedioPago);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetMedioDePago();
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
              'Ingresar Dinero',
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
          ? Center(
              child: SpinKitWanderingCubes(
                size: 30,
                color: Color(0xff3375bb),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'Monto a Ingresar: ',
                        style: GoogleFonts.raleway(
                            fontSize: 20, color: Colors.black54),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 5),
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(fontSize: 30),
                      decoration: InputDecoration(
                        prefixText: _currency,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (string) {
                        string = '${_formatNumber(string.replaceAll(',', ''))}';
                        _controller.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 50),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xffe3e8ff),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '¿Como desea Ingresar el dinero?',
                                style: GoogleFonts.raleway(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            /////////////////////////////////////////////////////////////////////////////////////////////////INICIO INGRESO TARJETA//////////////////////////////////////////////////////
                            CarouselSlider(
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                                autoPlay: false,
                                height: 190,
                                enlargeCenterPage: true,
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
                                  .map((item) => _tarjetas![_currentIndex]
                                              .TipoMedioPago! ==
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
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.account_balance,
                                                    color: Colors.white,
                                                    size: 50,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    _tarjetas![_currentIndex]
                                                        .Descripcion!,
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    _tarjetas![_currentIndex]
                                                        .DetalleAdicional!,
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                          )))
                                  .toList(),
                            ),
                            Padding(
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
                                          : const Color.fromRGBO(0, 0, 0, 0.3),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.blue,
                      ),
                      height: 52,
                      width: 300,
                      child: CupertinoButton(
                        onPressed: () {
                          if (_controller.text == '') {
                            return AlertPop.alert(context,
                                body: Text('¡Primero Ingresa un Monto!'));
                          } else {
                            setState(() {
                              loading = true;
                            });
                            IngresarDinero(_tarjetas![_currentIndex].Id!,
                                _tarjetas![_currentIndex].TipoMedioPago!);
                          }
                        },
                        child: const Text(
                          "Ingresar Dinero",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
