import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:smart/API/Usuario/UsuarioApi.dart';
import 'package:smart/services/InputTextForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final storage = FlutterSecureStorage();

class MisDatosPage extends StatefulWidget {
  @override
  _MisDatosPageState createState() => _MisDatosPageState();
}

class _MisDatosPageState extends State<MisDatosPage> {
  bool _loading = true;
  DateTime? _chosenDateTime;
  dynamic Usuario = null;
  dynamic _decodedJson = null;
  final _formKey = GlobalKey<FormState>();
  final MailController = TextEditingController();
  final DomicilioController = TextEditingController();
  final CelularController = TextEditingController();
  final PasswordController = TextEditingController();
  final Password2Controller = TextEditingController();
  bool showPassword = true;
  bool Egreso = false;
  String? Password;
  bool Finaliza = false;
  String? Grabado = null;
  bool Ingreso = false;
  String? UAT;
  File? _image;
  Uint8List? result = null;
  final picker = ImagePicker();
  dynamic _decodedJson2 = null;
  String? Estado = null;
  Uint8List? Foto;
  bool Guardia = false;
  bool _inProcess = false;

  getImage(ImageSource source) async {
    final _picker = ImagePicker();
    this.setState(() {
      _inProcess = true;
    });
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File? cropped = (await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.blue,
            toolbarTitle: "Recortar",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.blue.shade900,
            backgroundColor: Colors.white,
          )
          )) ;
      String? jason = await storage.read(key: "USER");
      _decodedJson = jsonDecode(jason!);
      _image = File(cropped!.path);
      Uint8List Foto = _image!.readAsBytesSync();
      GrabaDatos grabaDatosClases = GrabaDatos();
      await grabaDatosClases.GrabaFoto(context, _decodedJson['UAT'], Foto);
      setState(() {
        _loading = true;
        result = Foto;
        getUsuario();
      });
    }
  }

  _submit() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    GrabaDatos grabaDatosClases = GrabaDatos();
    await grabaDatosClases.GrabaDatosUsuarioInicio(
        context,
        Usuario["UAT"],
        CelularController.text,
        MailController.text,
        _chosenDateTime!,
        PasswordController.text,
        Password2Controller.text,
        DomicilioController.text);
    setState(() {
      getUsuario();
      _loading = false;
    });
  }

  getUsuario() async {
    String? jason = await storage.read(key: "USER");
    _decodedJson2 = jsonDecode(jason!);
    UAT = _decodedJson2["UAT"];
    if (_decodedJson2['DarkMode'] != null) {
      isSwitched = _decodedJson2['DarkMode'];
    }

    GrabaDatos grabaDatosClases = GrabaDatos();
    await grabaDatosClases.TraeDatosUsuario(context, UAT!);
    String? jason2 = await storage.read(key: "UsuarioDatos");
    _decodedJson = jsonDecode(jason2!);

    Foto = (_decodedJson['Foto'] != null && _decodedJson['Foto'].length > 23)
        ? base64Decode(
            _decodedJson['Foto'].replaceFirst('data:image/jpeg;base64,', ''))
        : null;
    if (_decodedJson['Celular'] != null) {
      CelularController.text = _decodedJson['Celular'];
    }
    if (_decodedJson['Mail'] != null) {
      MailController.text = _decodedJson['Mail'];
    }
    if (_decodedJson['Domicilio'] != null) {
      DomicilioController.text = _decodedJson['Domicilio'];
    }
    if (_decodedJson['FechaNacimiento'] != null) {
      setState(() {
        _chosenDateTime = DateTime.now();
      });
    } else {
      setState(() {
        _chosenDateTime = DateTime.parse(_decodedJson['FechaNacimiento']);
      });
    }
    setState(() {
      _loading = false;
    });
  }

  grabaUsuario() async {
    GrabaDatos grabaDatosClases = GrabaDatos();
    await grabaDatosClases.GrabaDatosUsuario(context, UAT!, _decodedJson);
    setState(() {
      getUsuario();
    });
  }

  bool isSwitched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chosenDateTime = null;
    getUsuario();
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 250,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 160,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: isSwitched ? Colors.black : Colors.grey[200],
          extendBodyBehindAppBar: true,
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
                    child: Center(
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 30,
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 6,
                                      color: const Color(0xfff68712),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 10))
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: const Color(0xfff68712),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                        color: Colors.white,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                elevation: 16,
                                                child: Container(
                                                  width: 200,
                                                  height: 150,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      DialogButton(
                                                        height: 45,
                                                        width: 250,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          _loading = true;
                                                          getImage(ImageSource
                                                              .gallery);
                                                        },
                                                        child: const Text(
                                                            "Seleccionar de Galeria",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                            )),
                                                      ),
                                                      DialogButton(
                                                        height: 45,
                                                        width: 250,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          _loading = true;
                                                          getImage(ImageSource
                                                              .camera);
                                                        },
                                                        child: const Text(
                                                            "Tomar nueva Foto",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              _decodedJson['Apellido'] +
                                  " " +
                                  _decodedJson['Nombres'],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSwitched ? Colors.white : Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 300,
                                minWidth: 100,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextInput3(
                                      label: 'Correo Electronico',
                                      Controller: MailController,
                                      inputIcon: const Icon(
                                        Icons.mail_outline,
                                        color: Colors.black54,
                                      ),
                                      inputStyle: const TextStyle(color: Colors.black54),
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
                                    TextInput3(
                                      label: 'Celular',
                                      inputType: TextInputType.number,
                                      Controller: CelularController,
                                      inputIcon: const Icon(
                                        Icons.phone,
                                        color: Colors.black54,
                                      ),
                                      inputStyle:
                                          TextStyle(color: Colors.black54),
                                      validator: (String? text) {
                                        return null;
                                      },
                                    ),
                                    const  SizedBox(
                                      height: 20,
                                    ),
                                    TextInput3(
                                      label: 'Domicilio',
                                      Controller: DomicilioController,
                                      inputIcon: const Icon(
                                        Icons.home_outlined,
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          shape: BoxShape.rectangle,
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () => _showDatePicker(context),
                                          leading: const Icon(Icons.calendar_today,
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
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextInput3(
                                      label: 'Contraseña',
                                      password: true,
                                      Controller: PasswordController,
                                      inputIcon: const Icon(
                                        Icons.lock,
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextInput3(
                                      label: 'Repetir Contraseña',
                                      Controller: Password2Controller,
                                      password: true,
                                      inputIcon: Icon(
                                        Icons.lock,
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
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: 350, minWidth: 300),
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 48,
                                    width: 300,
                                    child: CupertinoButton(
                                      child: Text("Guardar Cambios",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                              fontSize: 16)),
                                      color: Color(0xfff68712),
                                      onPressed: () {
                                        setState(() {
                                          _loading = true;
                                        });
                                        _submit();
                                      },
                                    ),
                                  ),
                                ],
                              )),
                            ),
                            Container(
                              height: 40,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, String Tag) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: isSwitched ? Colors.white : Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: isSwitched ? Colors.white : Colors.grey),
            ),
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(Icons.remove_red_eye,
                        color: isSwitched ? Colors.white : Colors.grey),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            labelStyle:
                TextStyle(color: isSwitched ? Colors.white : Colors.grey),
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isSwitched ? Colors.white : Colors.black,
            )),
        onChanged: (text) {
          _decodedJson[Tag] = text;
        },
      ),
    );
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(8, 10) +
      "/" +
      Fecha.substring(5, 7) +
      "/" +
      Fecha.substring(0, 4);
}
