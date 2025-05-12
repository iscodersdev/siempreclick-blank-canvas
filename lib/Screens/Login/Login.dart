
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart/API/Login/LoginApi.dart';
import 'package:smart/Screens/Login/FadeAnimation.dart';
import 'package:smart/Widgets/InputText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/Widgets/MyImagen.dart';
import '../../services/alert.dart';
import 'FadeAnimation2.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var _username, _password;
  final DniController = TextEditingController();
  bool Recordar = false;
  final passController = TextEditingController();
  bool loading = false;
  bool eye = true;
  Login() async {
    await loginUser(context, DniController.text, passController.text);
    setState(() {
      loading = false;
    });
  }

  Future<Null> RecuperarContrasena() async {
    if (!loading) {
      _formKey.currentState!.validate();
      if (DniController.text.isEmpty) {
        _mostrarSnackBar(
            context,
            'Debe ingresar un Correo Electronico para Recuperar Contraseña',
            500);
      } else {
        await MaRecuperarClave(context, DniController.text);
      }
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.focused,
    };
    return Color(0xffFF5E00);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(3, 9, 23, 1),
            backgroundBlendMode: BlendMode.color,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
              child: loading
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Lottie.asset(
                                'assets/gifs/lottie_load.json', // Replace with the actual asset path
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text('Aguarde porfavor...',
                                style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500))
                          ]))
                  : Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Color(0XFF39a67b)),
                        ),
                        Positioned(
                          top: 50,
                          left: 0,
                          right: 40,
                          child: Container(
                            height:200 ,
                            width: 200,

                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/Images/siempreclickLogo.png'),

                              )
                          )),

                          //child: AssetImage(
                          //  'assets/Images/siempreclickLogo.png',
                          //  scale: 2.2,
                          //  width: MediaQuery.of(context).size.width / 2, height: null,
                          //),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Image.asset(
                                            //   'assets/Images/logo3.png',
                                            //   scale: 3,
                                            // ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            FadeAnimation(
                                              1.0,
                                              Text(
                                                'SOMOS SIEMPRECLICK',
                                                style: GoogleFonts.raleway(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black87,
                                                    fontSize: 17),
                                              ),
                                            ),

                                            FadeAnimation(
                                              2.0,
                                              Text(
                                                'Bienvenid@!',
                                                style: GoogleFonts.raleway(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black87,
                                                    fontSize: 33),
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 3,
                                            ),
                                            FadeAnimation(
                                              2.5,
                                              Text(
                                                'Ingresa tu usuario para entrar a la App',
                                                style: GoogleFonts.raleway(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            FadeAnimation2(
                                              3.0,
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: <Widget>[
                                                    TextFormField(
                                                      controller: DniController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Correo Electronico',
                                                        hintStyle:
                                                            GoogleFonts.raleway(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                        prefixIcon: const Icon(
                                                          Icons.mail_outline,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    Stack(
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              passController,
                                                          obscureText: eye,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Contraseña',
                                                            hintStyle: GoogleFonts
                                                                .raleway(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons
                                                                  .lock_outline,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 10,
                                                          top: 10,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (eye) {
                                                                setState(() {
                                                                  eye = false;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  eye = true;
                                                                });
                                                              }
                                                            },
                                                            child: Icon(
                                                              eye == false
                                                                  ? MdiIcons
                                                                      .eyeOffOutline
                                                                  : MdiIcons
                                                                      .eye,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Theme(
                                                        data: ThemeData(
                                                          primarySwatch:
                                                              Colors.blue,
                                                          unselectedWidgetColor:
                                                              Colors
                                                                  .black, // Your color
                                                        ),
                                                        child: Checkbox(
                                                            activeColor:
                                                                Colors.black,
                                                            checkColor:
                                                                Colors.white,
                                                            value: Recordar,
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                Recordar =
                                                                    value!;
                                                              });
                                                            }),
                                                      ),
                                                      CupertinoButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 2),
                                                          child: Text(
                                                              "Recordarme",
                                                              style: GoogleFonts.raleway(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black54)),
                                                          onPressed: () {
                                                            Recordar = true;
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  child: Text(
                                                      "Recuperar Contraseña",
                                                      style:
                                                          GoogleFonts.raleway(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 15)),
                                                  onTap: () {
                                                    // _controller.pause();
                                                    RecuperarContrasena();
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),

                                            FadeAnimation2(
                                              4.0,
                                              CupertinoButton(
                                                onPressed: () {
                                                  storage.write(
                                                      key: 'routePrestamos',
                                                      value: '0');
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  Login();
                                                },
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      // left: 10,
                                                      // right: 10
                                                    ),
                                                    // width: 140,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xfff68712)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Ingresar',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts.raleway(
                                                              color: const Color(
                                                                  0xfff68712),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        const SizedBox(width: 5)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),
                                            FadeAnimation2(
                                              3.5,
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'No tenes Usuario?',
                                                      style:
                                                          GoogleFonts.raleway(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black87),
                                                    ),
                                                    CupertinoButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/Register');
                                                      },
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4),
                                                      child: Text("Registrarme",
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black87)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 35,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

_mostrarSnackBar(BuildContext context, String _mensaje, int _status) {
  final snackBarER = SnackBar(
    elevation: 5.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    backgroundColor: _status == 200 ? Colors.green[400] : Colors.red,
    behavior: SnackBarBehavior.floating,
    content: Row(
      children: [
        Icon(_status == 200 ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white),
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: Text(_mensaje,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white)),
        ),
      ],
    ),
    action: SnackBarAction(
      label: 'Cerrar',
      textColor: Colors.white,
      onPressed: () {
        // Solo cierra el popup. no requiere acción
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBarER);
}
