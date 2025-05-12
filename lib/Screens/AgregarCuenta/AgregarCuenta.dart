import 'dart:convert';

import 'package:smart/API/AgregarCuenta/AgregarCuentaAPI.dart';
import 'package:smart/Widgets/InputText.dart';
import 'package:smart/services/InputTextForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class AgregarCuentaPage extends StatefulWidget {
  const AgregarCuentaPage({Key? key}) : super(key: key);

  @override
  _AgregarCuentaPageState createState() => _AgregarCuentaPageState();
}

final storage = FlutterSecureStorage();

class _AgregarCuentaPageState extends State<AgregarCuentaPage> {
  final _formKey = GlobalKey<FormState>();
  final NumeroController = TextEditingController();
  final TitularController = TextEditingController();
  final CBUController = TextEditingController();
  final AliasControler = TextEditingController();
  bool Terceros = false;
  dynamic Usuario = null;
  bool loading = false;

  ActivarCuenta() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await AltaCuenta(
        context,
        Usuario['UAT'],
        NumeroController.text,
        TitularController.text,
        CBUController.text,
        AliasControler.text,
        Terceros);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff3375bb),
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'Nueva Cuenta',
            style: GoogleFonts.raleway(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_add,
              color: Colors.white,
              size: 25,
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: loading
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
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/Images/AgregarCuenta.png'),
                                    scale: 10,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 90,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      'Completa los campos a continuacion Para Activar una Cuenta!',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30, top: 10, bottom: 10),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 300, minWidth: 100),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextInput2(
                                label: 'Numero de Cuenta',
                                Controller: NumeroController,
                                inputType: TextInputType.numberWithOptions(),
                                inputIcon: Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: Colors.black54,
                                ),
                                inputStyle: TextStyle(color: Colors.black54),
                                validator: (String text) {
                                  if (text.isEmpty) {
                                    return 'Por favor completar el campo';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextInput2(
                                label: 'Nombre del Titular',
                                Controller: TitularController,
                                inputType: TextInputType.text,
                                inputIcon: Icon(
                                  Icons.person,
                                  color: Colors.black54,
                                ),
                                inputStyle: TextStyle(color: Colors.black54),
                                validator: (String text) {
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextInput2(
                                label: 'CBU',
                                Controller: CBUController,
                                inputType: TextInputType.numberWithOptions(),
                                inputIcon: Icon(
                                  Icons.account_balance,
                                  color: Colors.black54,
                                ),
                                inputStyle: TextStyle(color: Colors.black54),
                                validator: (String text) {
                                  if (text.isEmpty) {
                                    return 'Por favor completar el campo';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextInput2(
                                label: 'Alias',
                                Controller: AliasControler,
                                inputType: TextInputType.text,
                                inputIcon: Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.black54,
                                ),
                                inputStyle: TextStyle(color: Colors.black54),
                                validator: (String text) {
                                  if (text.isEmpty) {
                                    return 'Por favor completar el campo';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Theme(
                                    child: Checkbox(
                                        checkColor:
                                            Colors.white, // color of tick Mark
                                        activeColor: Color(0xff3375bb),
                                        value: Terceros,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            Terceros = value!;
                                          });
                                        }),
                                    data: ThemeData(
                                        scaffoldBackgroundColor: Colors.black54,
                                        primarySwatch: Colors.blue,
                                        unselectedWidgetColor: Colors.black54,
                                        disabledColor:
                                            Color(0xff3375bb) // Your color
                                        ),
                                  ),
                                  CupertinoButton(
                                      padding: EdgeInsets.only(left: 2),
                                      child: Text("Terceros",
                                          style: GoogleFonts.raleway(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54)),
                                      onPressed: () {
                                        Terceros = true;
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 25.0, left: 25, top: 25),
                        child: GestureDetector(
                          child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.3,
                              margin:
                                  EdgeInsets.only(left: 5, top: 5, right: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xff3375bb),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Agregar Cuenta',
                                    style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  )
                                ],
                              )),
                          onTap: () {
                            setState(() {
                              loading = true;
                            });
                            ActivarCuenta();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
