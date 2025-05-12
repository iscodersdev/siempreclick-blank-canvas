import 'dart:convert';
import 'dart:typed_data';

import 'package:smart/Screens/Login/Login.dart';
import 'package:smart/Screens/Mis%20Datos/MisDatos.dart';
import 'package:smart/Screens/MisCompras/MisComprasPage.dart';
import 'package:smart/Screens/Movimientos/Movimientos.dart';
import 'package:smart/Screens/Prestamos/Prestamos.dart';
import 'package:smart/Screens/Proveedores/Proveedores.dart';
import 'package:smart/Screens/Tarjetas/Tarjetas.dart';
import 'package:smart/Screens/noticia/Noticias.dart';
import 'package:smart/Sidebar/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MasPage extends StatefulWidget {
  @override
  _MasPageState createState() => _MasPageState();
}

final storage = FlutterSecureStorage();

class _MasPageState extends State<MasPage> {
  dynamic Usuario = null;
  bool _loading = true;
  dynamic _decodedJson = null;
  String? UAT;
  Uint8List? Foto;
  bool Guardia = false;
  bool DarkMode = false;
  String Nombre = '';

  GetUser() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Nombre = Usuario['Nombres'];
    List<String> wordList = Nombre.split(" ");
    if (wordList.isNotEmpty) {
      Nombre = wordList[0];
    }
    print(User);
    Foto = Usuario['Foto'];
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40,right: 20,left: 20,bottom: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFF39a67b),
                    borderRadius: BorderRadius.circular(10)

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            padding: EdgeInsets.all(10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Foto == null
                                    ? Image.asset(
                                  'assets/Images/DefaultUserDarkMode.png',
                                  fit: BoxFit.cover,
                                )
                                    : Image.memory(
                                  Foto!,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Container(
                            width: 20,
                          ),
                          _loading
                              ? Container()
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                                SizedBox(
                                                  child: Text(
                                                    Usuario['Apellido'] + ', ',
                                                    style: GoogleFonts.raleway(
                                                        fontSize: 19,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: Text(
                                                    Nombre,
                                                    style: GoogleFonts.raleway(
                                                        fontSize: 19,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                        ],
                                      ),
                                  ),

                                ],
                              ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          child: Icon(
                            Icons.exit_to_app, color: Colors.white,
                          ),
                          onTap: (){
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: LoginPage(),
                              withNavBar: false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation: PageTransitionAnimation.slideUp,
                            );
                        },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              MenuItemss(
                icon: Icons.account_balance_wallet,
                title: "Billetera",
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: WalletPage(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              Container(
                height: 5,
              ),
              MenuItemss(
                icon: Icons.monetization_on_outlined,
                title: "Prestamos",
                onTap: () {
                  storage.write(key: 'routePrestamos', value: '1');
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PrestamosPage(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              Container(
                height: 5,
              ),
              MenuItemss(
                icon: Icons.compare_arrows,
                title: "Ultimos Movimientos",
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: MovimientosPage(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              Container(
                height: 5,
              ),
              // MenuItem(
              //   icon: Icons.not_listed_location_outlined,
              //   title: "Servicios",
              //   onTap: () {
              //
              //   },
              // ),
              Container(
                height: 5,
              ),
              MenuItemss(
                icon: MdiIcons.shopping,
                title: "Mis Compras",
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: MisComprasPage(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),


              Container(
                height: 5,
              ),
              MenuItemss(
                icon: Icons.new_releases_sharp,
                title: "Novedades",
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: NoticiasPage(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25,bottom: 15 ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
              ),
              MenuItemss(
                icon: Icons.settings,
                title: "Configuracion",
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: MisDatosPage(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              MenuItemss(
                icon: Icons.exit_to_app,
                title: "Cerrar Sesion",
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: LoginPage(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
