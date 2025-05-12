import 'dart:convert';
import 'package:smart/Screens/BottomBar/BottomBar.dart';
import 'package:smart/Screens/HomeScreen/Home.dart';
import 'package:smart/Screens/Mis%20Datos/MisDatos.dart';
import 'package:smart/Screens/Second/Second.dart';
import 'package:smart/Sidebar/DrawerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

final storage = FlutterSecureStorage();

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String AppbarTitle = "HomIT 2.0";
  IconData TrailingIcon = Icons.menu;

  @override
  initState() {
    super.initState();
    DarkMode();
  }

  bool Darkmode = false;
  DarkMode() async {
    String? dark = await storage.read(key: "DarkMode");
    if (dark == "true") {
      setState(() {
        Darkmode = true;
      });
    } else {
      setState(() {
        Darkmode = false;
      });
    }
  }

  getUsuario() async {
    String? jason = await storage.read(key: "UsuarioBody");
    dynamic _decodedJson = jsonDecode(jason!);
    Darkmode = _decodedJson['DarkMode'];
  }

  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      menu: Menu(),
      screenSelectedBuilder: (position, controller) {
        Widget screenCurrent;
        switch (position) {
          case 0:
            screenCurrent = HomePage();
            AppbarTitle = "Home";
            break;
          case 1:
            screenCurrent = SecondPage();
            AppbarTitle = "Second";
            break;
          case 4:
            screenCurrent = MisDatosPage();
            AppbarTitle = "Mis Datos";
            break;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 70,
            backgroundColor: Color(0xff3375bb),
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () async {
                  controller.toggle();
                }),
          ),
        );
      },
    );
  }
}
