import 'dart:convert';
import 'package:smart/API/Tarjetas/TarjetasAPI.dart';
import 'package:smart/Widgets/InputText2.dart';
import 'package:smart/services/InputText5.dart';
import 'package:smart/services/InputTextDescripcion.dart';
import 'package:smart/services/InputTextForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class NuevaTarjetaPage extends StatefulWidget {
  @override
  _NuevaTarjetaPageState createState() => _NuevaTarjetaPageState();
}

final storage = FlutterSecureStorage();

class _NuevaTarjetaPageState extends State<NuevaTarjetaPage> {
  String cardNumber = '';
  String UAT = 'abcdefg';
  String expiryDate = '';
  String cardHolderName = 'Nombre Apellido';
  String cvvCode = '';
  bool buttons = true;
  bool Scan = false;
  bool Form = true;
  DateTime? _chosenDateTime;
  DateTime? _chosenDateTime2;
  final TitularController = TextEditingController();
  final NumController = TextEditingController();
  final VenController = TextEditingController();
  bool isCvvFocused = false;
  dynamic Usuario = null;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showDatePicker(context) {
    // showCupertinoModalPopup(
    //     context: _scaffoldKey.currentContext,
    //     useRootNavigator: false,
    //     builder: (_) => Container(
    //       height: 250,
    //       color: Color.fromARGB(255, 255, 255, 255),
    //       child: Column(
    //         children: [
    //           Container(
    //             height: 160,
    //             child: CupertinoDatePicker(
    //                 initialDateTime: DateTime.now(),
    //                 mode: CupertinoDatePickerMode.date,
    //                 onDateTimeChanged: (val) {
    //                   setState(() {
    //                     _chosenDateTime = val;
    //                   });
    //                 }),
    //           ),
    //
    //           // Close the modal
    //           CupertinoButton(
    //             child: Text('Confirmar'),
    //             onPressed: () => Navigator.pop(context),
    //           )
    //         ],
    //       ),
    //     ));
  }

  String MIN_DATETIME = '2020-00-00';
  String MAX_DATETIME = '2050-11-00';
  ConfirmarTarjeta() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Tarjetas tarjetasclases = Tarjetas();
    await tarjetasclases.AltaTarjeta(context, Usuario['UAT'],
        TitularController.text, NumController.text, VenController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chosenDateTime = DateTime.now();
    VenController.text = '';
    NumController.text = '';
    TitularController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff3375bb),
          title: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Text(
                  'Agregar Tarjeta',
                  style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/Images/logo_vertical.png')),
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomInset: true,
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
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 15, left: 15, top: 20, bottom: 20),
                        child: Container(),
                        // child: CreditCardWidget(
                        //   textStyle: GoogleFonts.abel(
                        //       color: Colors.white,
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.w300),
                        //   cardNumber: NumController.text,
                        //   expiryDate:
                        //       convertirFecha(_chosenDateTime.toString()),
                        //   cardHolderName: TitularController.text == ''
                        //       ? 'Titular de la Tarjeta'
                        //       : TitularController.text,
                        //   cvvCode: cvvCode,
                        //   showBackView: isCvvFocused,
                        //   obscureCardNumber: true,
                        //   obscureCardCvv: true,
                        //   onCreditCardWidgetChange: (CreditCardBrand) {},
                        // ),
                      ),
                      buttons
                          ? Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 20,
                                  ),
                                  Text(
                                    '¿Como deseas Ingresar los datos?',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.black87),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20, top: 25),
                                    child: GestureDetector(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 5, top: 5, right: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xff3375bb),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Escanear Tarjeta',
                                                style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17),
                                              )
                                            ],
                                          )),
                                      onTap: () async {},
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20, top: 15),
                                    child: GestureDetector(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 5, top: 5, right: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xff3375bb),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.keyboard,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Ingreso Manual',
                                                style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17),
                                              )
                                            ],
                                          )),
                                      onTap: () {
                                        setState(() {
                                          Form = false;
                                          buttons = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Form
                          ? Container()
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25.0, left: 25, bottom: 15),
                                      child: TextInput3(
                                        label: 'Numero de Tarjeta',
                                        Controller: NumController,
                                        inputType: TextInputType.number,
                                        inputIcon: Icon(
                                          Icons.credit_card_outlined,
                                          color: Colors.black54,
                                        ),
                                        inputStyle:
                                            TextStyle(color: Colors.black54),
                                        onChanged: (String value) {
                                          setState(() {
                                            value = cardNumber;
                                          });
                                        },
                                        validator: (String text) {
                                          if (text.isEmpty) {
                                            return 'Por favor completar el campo';
                                          }
                                          cardNumber = text;
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25.0, left: 25, bottom: 15),
                                      child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                          ),
                                          child: ListTile(
                                            onTap: () =>
                                                _showDatePicker(context),
                                            leading: Icon(Icons.calendar_today,
                                                color: Colors.black54),
                                            title: Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      -20, 0.0, 0.0),
                                              child: Text(
                                                _chosenDateTime != null
                                                    ? convertirFecha(
                                                        _chosenDateTime
                                                            .toString())
                                                    : 'Fecha de Nacimiento',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25.0, left: 25),
                                      child: TextInput8(
                                        label: 'Titular',
                                        Controller: TitularController,
                                        inputType: TextInputType.text,
                                        inputIcon: Icon(
                                          Icons.person,
                                          color: Colors.black54,
                                        ),
                                        inputStyle:
                                            TextStyle(color: Colors.black54),
                                        onChanged: (String value) {
                                          setState(() {
                                            value = cardHolderName;
                                          });
                                        },
                                        validator: (String text) {
                                          if (text.isEmpty) {
                                            return 'Por favor completar el campo';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 18.0, left: 18, top: 25),
                                      child: GestureDetector(
                                        child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(
                                                left: 5, top: 5, right: 5),
                                            decoration: BoxDecoration(
                                                color: Color(0xff3375bb),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Agregar Tarjeta',
                                                  style: GoogleFonts.raleway(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17),
                                                )
                                              ],
                                            )),
                                        onTap: () {
                                          setState(() {
                                            _loading = true;
                                          });
                                          ConfirmarTarjeta();
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Form
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.black54,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    Form = true;
                                                    buttons = true;
                                                  });
                                                },
                                              ),
                                              CupertinoButton(
                                                  padding: EdgeInsets.only(
                                                      right: 25),
                                                  child: Text(
                                                    'Volver',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.raleway(
                                                        color: Colors.black54,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      Form = true;
                                                      buttons = true;
                                                    });
                                                  })
                                            ],
                                          )
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ));
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(5, 7) + "/" + Fecha.substring(2, 4);
}
