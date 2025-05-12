import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'menu_item.dart';

final storage = FlutterSecureStorage();

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  dynamic Usuario = null;
  bool _loading = false;
  dynamic _decodedJson = null;
  String? UAT;
  Uint8List? Foto;
  bool Guardia = false;
  SimpleHiddenDrawerController? controller;
  bool DarkMode = false;
  @override
  void didChangeDependencies() {
    controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
//    getUsuario();
  }
//  getUsuario() async {
//    String jason = await storage.read(key: "UsuarioBody");
//    _decodedJson = jsonDecode(jason);
//    UAT=_decodedJson["UAT"];
//    DarkMode = _decodedJson['DarkMode'];
//    Guardia = _decodedJson['EsGuardia'];
//    GrabaDatos grabaDatosClases = GrabaDatos();
//    await grabaDatosClases.TraeDatosUsuario(context, UAT);
//    String jason2 = await storage.read(key: "UsuarioDatos");
//    _decodedJson = jsonDecode(jason2);
//    Foto =  (_decodedJson['Foto'] != null &&
//        _decodedJson['Foto'].length > 23)
//        ? base64Decode(_decodedJson['Foto'].replaceFirst(
//        'data:image/jpeg;base64,', ''))
//        : null;
//    setState(() {
//      _loading = false;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            color: Color(0xff000033),
            padding: EdgeInsets.only(top: 70, bottom: 70, left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRect(
                      child: Foto == null
                          ? CircleAvatar()
                          : Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: MemoryImage(Foto!),
                                    fit: BoxFit.fill),
                              ),
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Franco Albarracin",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                decoration: TextDecoration.none),
                          ),
//                  Text(
//                    "Lote "+_decodedJson['NumeroLote'].toString(),
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                        fontFamily: 'Avenir',
//                        fontSize: 15,
//                        fontWeight: FontWeight.w400,
//                        color:  Colors.white,
//                        decoration: TextDecoration.none
//                    ),),
                        ]),
                  ],
                ),
                Column(
                  children: <Widget>[
                    MenuItemss(
                      icon: Icons.home,
                      title: "Inicio",
                      onTap: () {
                        controller!.setSelectedMenuPosition(0);
                      },
                    ),
                    Container(
                      height: 19,
                    ),
                    MenuItemss(
                        icon: Icons.chat,
                        title: "SecondPage",
                        onTap: () {
                          controller!.setSelectedMenuPosition(1);
                        }),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CupertinoButton(
                        padding: EdgeInsets.only(left: 4),
                        child: Text("Mis Datos",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                decoration: TextDecoration.none)),
                        onPressed: () {
                          storage.write(key: "appbar", value: "false");
                          controller!.setSelectedMenuPosition(4);
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CupertinoButton(
                        padding: EdgeInsets.only(left: 4),
                        child: Text("Cerrar Sesion",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                decoration: TextDecoration.none)),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/');
                        }),
                  ],
                )
              ],
            ),
          );
  }
}
