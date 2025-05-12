import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:lottie/lottie.dart';
import 'package:smart/API/Register/RegisterApi.dart';
import 'package:smart/Models/RegisterModel/RegisterModel.dart';
import 'package:smart/Widgets/InputText.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart/API/Register/RegisterApi.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Login/FadeAnimation2.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  List<OrganismosModel>? org = [];
  final DNIController = TextEditingController();
  final NombreController = TextEditingController();
  final ApellidoController = TextEditingController();
  final CorreoControler = TextEditingController();
  final TelefonoControler = TextEditingController();
  final ContrasenaControler = TextEditingController();
  final Contrasena2Controler = TextEditingController();
  final ReferidoControler = TextEditingController();
  final TokenControler = TextEditingController();
  bool Seleccionado = false;
  OrganismosModel? selectedOrganismo;
  TipoPersonaModel? selectedTipoPersona;
  DateTime? SelectedFecha;
  final format = DateFormat("dd-MM-yyyy");
  bool loading = true;
  int IdOrg = 0;
  bool Organismo = false;
  String Referido = '0';
  bool sended = false;
  bool success = false;
  dynamic? Pre = null;
  String? _status;
  String? _mensaje;
  dynamic? TipoPersonas = null;
  List<OrganismosModel>? Organismos = [];
  List<dynamic>? tiposPersona = [];
  bool seleccion = false;
  Register() async {

      await RegistraPersona(
          context,
          16,
          DNIController.text,
          NombreController.text,
          ApellidoController.text,
          SelectedFecha!,
          CorreoControler.text,
          TelefonoControler.text,
          ContrasenaControler.text,
          Contrasena2Controler.text,
          ReferidoControler.text,
          TokenControler.text);

      _status = await storage.read(key: 'RegistroStatus');
      _mensaje = await storage.read(key: 'RegistroMensaje');
      if(_status == '200'){
        setState(() {
          sended = true;
          success = true;
          loading = false;
        });
      }else{
        setState(() {
          sended = true;
          success = false;
          loading = false;
        });
      }
   }


  GetOrg() async {
    organismos registerClases = organismos();
    org = await registerClases.GetOrganismos(context);
    //print(org);
    setState(() {
      Organismo = true;
      loading = false;
    });
  }

  PreReg() async {
    print(org![0].Id!);
    await PreRegister(context, CorreoControler.text, org![0].Id!);
    String? PreReg = await storage.read(key: 'PreRegister');
    print(PreReg);
    //Aler?tPop.alert(context, body: Text(PreReg));
    Pre = jsonDecode(PreReg!);
    //TipoPersonas = jsonDecode(Pre['TipoPersonas']);
    if (Pre['Status'] == 200) {

      setState(() {
        Organismo = false;
        loading = false;
        Seleccionado = true;
      });
    } else {
      if (Pre['Mensaje'] ==
          'Socio Ya Ingresado, debera recuperar contraseña') {
        setState(() {
          loading = false;
        });
        _mostrarSnackBar(context, Pre['Mensaje'], 500);

      } else {
        setState(() {
          Organismo = true;
          loading = false;
          Seleccionado = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetOrg();
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap:() => Navigator.pushNamed(context, '/')
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.7)),
      ),
      backgroundColor: Colors.white,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :  sended?
      //manda si el registro se completo correctamente
      success?Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 100,
                child: Lottie.asset('assets/gifs/success.json',fit: BoxFit.contain,repeat: false)),
            Padding(
              padding: const EdgeInsets.only(top: 20,bottom:10),
              child: Text(
                '¡Gracias por registrarte en nuestra App!',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10,top: 10),
              child: Text(
                'Revisa tu casilla de correo para ver los datos del registro.\nPresiona el boton debajo para continuar a la app',
                style: GoogleFonts.raleway(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10),
              child: Align(
                alignment: Alignment.center,
                child: CupertinoButton(
                  child: Container(
                    padding:
                    const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 30,
                        right: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF5E00),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continuar a la app',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight:
                              FontWeight.w500,
                              letterSpacing: 0.3,
                              color: Colors.white),
                        ),
                        const Icon(Icons.play_arrow_outlined,color: Colors.white,)
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ):Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              height: 100,
              child: Lottie.asset('assets/gifs/fail.json',fit: BoxFit.contain,repeat: false)),
          Padding(
            padding: const EdgeInsets.only(top: 20,bottom:10),
            child: Text(
              'Ups! parece que hubo un error...',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 10),
            child: Text(
              _mensaje!,
              style: GoogleFonts.raleway(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 10),
            child: Align(
              alignment: Alignment.center,
              child: CupertinoButton(
                child: Container(
                  padding:
                  const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 30,
                      right: 30),
                  color: const Color(0xffFF5E00),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Volver',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                            fontWeight:
                            FontWeight.w500,
                            letterSpacing: 0.3,
                            color: Colors.white),
                      ),
                      const Icon(Icons.play_arrow_outlined,color: Colors.white,)
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ):GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Stack(
                children: [
                  FadeAnimation2(0.5, Container(
                    // height: MediaQuery.of(context).size.height,
                    // width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/Images/bgR.jpg'))
                    ),
                  ),
                  ),
                  SingleChildScrollView(
                    child: seleccion
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                              ),
                              Image.asset(
                                'assets/Images/logo3.png',
                                scale: 2.5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  'Completa los siguientes campos \npara finalizar el registro',
                                  style: GoogleFonts.raleway(
                                      color: Colors.black, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 30,
                              ),
                              Text(
                                'Ingresa el Token Recibido en tu Correo Electronico',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 40.0, right: 40, top: 20),
                                child: TextInput2(
                                  label: 'Token',
                                  Controller: TokenControler,
                                  inputType: TextInputType.number,
                                  inputIcon: const Icon(
                                    Icons.account_circle_outlined,
                                    color: Colors.black54,
                                  ),
                                  inputStyle:
                                      GoogleFonts.poppins(color: Colors.black54),
                                  validator: (String? text) {
                                    if (text!.isEmpty) {
                                      return 'Por favor completar el campo';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 40.0,
                                  right: 40,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                      border: Border.all(color: const Color(0xffFF5E00))),
                                  width: MediaQuery.of(context).size.width,
                                  child: CupertinoButton(
                                    onPressed: () {
                                      setState(() {
                                        loading = true;
                                      });
                                      if(TokenControler.text.isEmpty){
                                        _mostrarSnackBar(context, 'Ingresa un token para Continuar', 500);
                                      }else{
                                        if (Organismo == true) {
                                          IdOrg = org![0].Id!;
                                          Register();
                                        } else {
                                          Register();
                                        }
                                      }

                                    },
                                    child: const Text(
                                      "Registrarse",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffFF5E00)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            child: Seleccionado
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 80,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Informacion Personal',
                                            style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w700,
                                                color: Colors.black, fontSize: 19),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 30,
                                      ),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxWidth: 300, minWidth: 100),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: <Widget>[

                                              TextInput2(
                                                label: 'DNI',
                                                Controller: DNIController,
                                                inputType: const TextInputType
                                                    .numberWithOptions(),
                                                inputIcon: Icon(
                                                  Icons.credit_card_outlined,
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
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextInput2(
                                                label: 'Nombres',
                                                Controller: NombreController,
                                                inputType: TextInputType.text,
                                                inputIcon: Icon(
                                                  Icons.person,
                                                  color: Colors.black54,
                                                ),
                                                inputStyle: TextStyle(
                                                    color: Colors.black54),
                                                validator: (String? text) {
                                                  return null;
                                                },
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextInput2(
                                                label: 'Apellido',
                                                Controller: ApellidoController,
                                                inputType: TextInputType.text,
                                                inputIcon:  Icon(
                                                  Icons.person,
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
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextInput2(
                                                label: 'Numero Telefonico',
                                                Controller: TelefonoControler,
                                                inputType: TextInputType
                                                    .numberWithOptions(),
                                                inputIcon: Icon(
                                                  Icons.phone,
                                                  color: Colors.black54,
                                                ),
                                                inputStyle: TextStyle(
                                                    color: Colors.black54),
                                                validator: (String? text) {
                                                  return null;
                                                },
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(10.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(left: 10),
                                                    child: DateTimeField(
                                                      cursorColor: Colors.black54,
                                                      format: format,
                                                      decoration: InputDecoration(
                                                        hoverColor: Colors.black54,
                                                        fillColor: Colors.black54,
                                                        icon: Icon(
                                                            Icons.calendar_today),
                                                        labelText:
                                                            'Fecha de Nacimiento',
                                                      ),
                                                      onChanged: (currentValue) {
                                                        setState(() {
                                                          SelectedFecha =
                                                              currentValue;
                                                        });
                                                      },
                                                      onShowPicker:
                                                          (context, currentValue) {
                                                        return showDatePicker(
                                                            helpText:
                                                                "Selecciona Fecha de Nacimiento ",
                                                            context: context,
                                                            firstDate:
                                                                DateTime(1900),
                                                            initialDate:
                                                                currentValue ??
                                                                    DateTime.now(),
                                                            lastDate:
                                                                DateTime(2100));
                                                      },
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextInput2(
                                                label: 'Contraseña',
                                                password: true,
                                                Controller: ContrasenaControler,
                                                inputType: TextInputType.text,
                                                inputIcon: Icon(
                                                  Icons.lock,
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
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextInput2(
                                                label: 'Confirmar Contraseña',
                                                password: true,
                                                Controller: Contrasena2Controler,
                                                inputType: TextInputType.text,
                                                inputIcon: Icon(
                                                  Icons.lock,
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
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 40,
                                          left: 40,
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: CupertinoButton(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 30,
                                                  right: 30),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          const Color(0xffFF5E00)),
                                                  borderRadius:
                                                      BorderRadius.circular(40)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Continuar     ',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      fontWeight: FontWeight.w600,
                                                        color: const Color(0xffFF5E00)
                                                    ),
                                                 ),
                                                  const Icon(
                                                    Icons.arrow_circle_right_outlined,
                                                    color: Color(0xfff68712),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onPressed: () {
                                              if (DNIController.text.isEmpty) {
                                                _mostrarSnackBar(context, 'Debe completar todos los campos para continuar', 500);
                                              } else {
                                                if (NombreController.text.isEmpty) {
                                                  _mostrarSnackBar(context, 'Debe completar todos los campos para continuar', 500);
                                                } else {
                                                  if (ApellidoController
                                                      .text.isEmpty) {
                                                    _mostrarSnackBar(context, 'Debe completar todos los campos para continuar', 500);
                                                  } else {
                                                    if (TelefonoControler
                                                        .text.isEmpty) {
                                                      _mostrarSnackBar(context, 'Debe completar todos los campos para continuar', 500);
                                                    } else {
                                                      if (Contrasena2Controler
                                                          .text.isEmpty) {
                                                        _mostrarSnackBar(context, 'Debe completar todos los campos para continuar', 500);
                                                      } else {
                                                        setState(() {
                                                          seleccion = true;
                                                        });
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 25,
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height / 6,
                                      ),
                                      Container(
                                        child: Image.asset(
                                          'assets/Images/logo3.png',
                                          scale: 2.5,
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          'Completa los siguientes campos \npara realizar el registro',
                                          style: GoogleFonts.raleway(
                                              color: Color(0xfff68712),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 35.0, left: 35),
                                        child: Text(
                                          'Para Comenzar, Ingresa tu Correo Electrónico',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.w700,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 40, left: 40, top: 30),
                                        child: TextInput2(
                                          label: 'Correo Electronico',
                                          Controller: CorreoControler,
                                          inputType: TextInputType.emailAddress,
                                          inputIcon: Icon(
                                            Icons.mail,
                                            color: Colors.black54,
                                          ),
                                          inputStyle:
                                              TextStyle(color: Colors.black54),
                                          validator: (String? text) {
                                            if (text!.isEmpty) {
                                              return 'Por favor completar el campo';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),

                                      SizedBox(
                                        height: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 40,
                                          left: 40,
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 30,
                                                  right: 30),
                                              width: fullWidth,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          const Color(0xfff68712)),
                                                  borderRadius:
                                                      BorderRadius.circular(40)),
                                              child:  Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Continuar',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                        color: const Color(0xfff68712),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  const Icon(
                                                    Icons.arrow_circle_right_outlined,
                                                    color: Color(0xfff68712),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              if (CorreoControler.text == '') {
                                                _mostrarSnackBar(context, 'Ingrese un Correo para continuar', 500);
                                              } else {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  PreReg();
                                                }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                  ),
                ],
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