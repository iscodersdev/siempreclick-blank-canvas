import 'dart:convert';

import 'package:smart/API/AgregarCuenta/AgregarCuentaAPI.dart';
import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:smart/API/Tarjetas/TarjetasAPI.dart';
import 'package:smart/API/Tarjetas/TarjetasAPI.dart';
import 'package:smart/Models/CuentasModel/CuentasModel.dart';
import 'package:smart/Models/TarjetasModel/TarjetasModel.dart';
import 'package:smart/Screens/AgregarCuenta/AgregarCuenta.dart';
import 'package:smart/Screens/EnviarDinero/EnviarDinero.dart';
import 'package:smart/Screens/IngresoDinero/IngresoDinero.dart';
import 'package:smart/Screens/Servicios/ServiciosPage.dart';
import 'package:smart/Screens/Tarjetas/NuevaTarjeta.dart';
import 'package:smart/Screens/TransferirDinero/TransferirDinero.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../Movimientos/Movimientos.dart';
import '../Receta/Receta.dart';
import '../RecibirDinero/RecibirDinero.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

final storage = FlutterSecureStorage();
final formatCurrency = new NumberFormat.currency(locale: 'id', symbol: "\$");

class _WalletPageState extends State<WalletPage> {
  bool _loading = true;
  String UAT = 'abcdefg';
  String Saldo = '0';
  dynamic CVU = null;
  dynamic Usuario = null;
  List<TarjetasModel>? _tarjetas;
  List<CuentasModel>? _cuentas;
  bool Billetera = true;
  String Nombre = '.';
  GetCuentas() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Cuentas cuentasClases = Cuentas();
    _cuentas = (await cuentasClases.getCuentas(context, Usuario['UAT']));
    setState(() {
      _loading = false;
    });
  }

  GetTarjetas() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Tarjetas tarjetasClases = Tarjetas();
    _tarjetas = (await tarjetasClases.getTarjetas(context, Usuario['UAT']));
    GetCuentas();
  }

  GetSaldo() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetSaldoBilletera(context, Usuario['UAT']);
    Nombre = Usuario['Nombres'];

    List<String> wordList = Nombre.split(" ");
    if (wordList.isNotEmpty) {
      Nombre = wordList[0];
    }
    Saldo = (await storage.read(key: 'Saldo'))!;
    String? billetera = await storage.read(key: 'Billetera');
    if (billetera == 'false') {
      Billetera = false;
      setState(() {
        _loading = false;
      });
    } else {
      getCVU();
    }
  }

  getCVU() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    await GetCVU(context, Usuario['UAT']);
    String? jason = await storage.read(key: 'CVU');
    CVU = jsonDecode(jason!);
    GetTarjetas();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _loading?AppBar(elevation: 0,backgroundColor: Colors.white,):AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0XFF39a67b),
          elevation: 0,
          actions: [
            CupertinoButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                });
                GetSaldo();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(" Actualizar",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.white))
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: _loading
              ? const SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xfff68712),),
                  ),
                )
              : SingleChildScrollView(
                  child: SizedBox(
                    child: Column(
                      children: [
                        Stack(
                          children: [

                            Container(
                              decoration: const BoxDecoration(
                                  color: Color(0XFF39a67b),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30)
                                  )
                              ),
                              child: SizedBox(child:Padding(
                                padding: const EdgeInsets.only(
                                   right: 10,),
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: 20,right: 60),

                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 2, ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'Mi Billetera',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 23,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6,bottom: 6 ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'Su Balance total es: ',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 5,
                                                ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${formatCurrency.format(double.parse(Saldo))}',
                                                        style: GoogleFonts.roboto(
                                                            fontSize: 30,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w800),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          //'assets/Images/logo2w.png',
                                          'assets/Images/smart_logo.png',
                                          scale: 3.5,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              ),
                            ),
                            Positioned(top: 0,right: 30,left:0,child: Image.asset('assets/Images/bubbles.png',scale: 10,)),
                          ],
                        ),
                        Container(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    GestureDetector(
                                      onTap: () {
                                        if(Billetera){
                                          PersistentNavBarNavigator.pushNewScreen(
                                            context,
                                            screen: EnviarDineroPage(),
                                            withNavBar: false, // OPTIONAL VALUE. True by default.
                                            pageTransitionAnimation: PageTransitionAnimation.slideUp,
                                          );
                                        }else{
                                          _mostrarSnackBar(context, 'Billetera no disponible actualmente',500);
                                        }

                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(color: const Color(0xfff68712))
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.arrow_upward,
                                                size: 20.0,
                                                color: Color(0xfff68712)
                                            ),
                                            Text(
                                              '  Enviar Dinero ',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                  color: const Color(0xfff68712),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if(Billetera){
                                          PersistentNavBarNavigator.pushNewScreen(
                                            context,
                                            screen: RecibirDineroPage(),
                                            withNavBar:
                                            false, // OPTIONAL VALUE. True by default.
                                            pageTransitionAnimation:
                                            PageTransitionAnimation.slideUp,
                                          );
                                        }else{
                                          _mostrarSnackBar(context, 'Billetera no disponible actualmente',500);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(color: Color(0xfff68712))
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.arrow_downward,
                                                size: 20.0,
                                                color: Color(0xfff68712)
                                            ),
                                            Text(
                                              '  Recibir Dinero',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                  color: const Color(0xfff68712),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                            Container(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if(Billetera){
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: ServiciosPage(),
                                        withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                        PageTransitionAnimation
                                            .slideUp,
                                      );
                                    }else{
                                      _mostrarSnackBar(context, 'Billetera no disponible actualmente',500);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),

                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(color: Color(0xfff68712))
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.not_listed_location_outlined,
                                            size: 20.0,
                                            color: Color(0xfff68712)
                                        ),
                                        Text(
                                          '  Pagar Mis Servicios   ',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                              color: const Color(0xfff68712),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(Billetera){
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: MovimientosPage(),
                                        withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                        PageTransitionAnimation
                                            .slideUp,
                                      );
                                    }else{
                                      _mostrarSnackBar(context, 'Billetera no disponible actualmente',500);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),

                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(color: const Color(0xfff68712))
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.compare_arrows,
                                            size: 20.0,
                                            color: Color(0xfff68712)
                                        ),
                                        Text(
                                          '  Últimos Movimientos',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                              color: const Color(0xfff68712),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),


                        DefaultTabController(
                          length: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top:25,),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2.5,
                              child: Column(
                                children: <Widget>[
                                  TabBar(
                                    labelColor: const Color(0xfff68712),
                                    indicatorColor: const Color(0xfff68712),
                                    unselectedLabelColor: Colors.black54,
                                    tabs: <Widget>[
                                      Tab(
                                        icon: Icon(
                                          MdiIcons.creditCard,
                                          color: Colors.black54,
                                        ),
                                        text: "Tarjetas",
                                      ),
                                      Tab(
                                        icon: Icon(
                                          MdiIcons.bank,
                                          color: Colors.black54,
                                        ),
                                        text: "Cuentas",
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: TabBarView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        children: <Widget>[
                                          _tarjetas == null
                                              ? Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 40.0),
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
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          _tarjetas!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.2,
                                                          color: Colors.blue,
                                                          // child: CreditCardWidget(
                                                          //   textStyle:
                                                          //       GoogleFonts.abel(
                                                          //           color: Colors.white,
                                                          //           fontSize: 18),
                                                          //   cardNumber:
                                                          //       _tarjetas![index].Numero!,
                                                          //   expiryDate:
                                                          //       convertirFecha(_tarjetas![index].Vencimiento!),
                                                          //   cardHolderName: _tarjetas![index].Titular!,
                                                          //   cvvCode: '112',
                                                          //   showBackView: false,
                                                          //   height: 160,
                                                          //   width: MediaQuery.of(context).size.width,
                                                          //   obscureCardCvv: true,
                                                          //   animationDuration:
                                                          //   const Duration(milliseconds: 1000),
                                                          //   onCreditCardWidgetChange:
                                                          //       (CreditCardBrand) {},
                                                          // ),
                                                        );
                                                      })),
                                          _cuentas == null
                                              ? SizedBox(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                             EdgeInsets.only(top: 40.0),
                                                        child: Icon(
                                                          Icons.account_circle_outlined,
                                                          size: 35,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'No se encontraron Cuentas',
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors.black54,
                                                                fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: _cuentas!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 15,
                                                                  top: 30,
                                                                  bottom: 30),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(context).size.width / 1.2,
                                                            height: MediaQuery.of(context).size.height / 6,
                                                            child: Card(
                                                              elevation: 2,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                                .all(
                                                                            15.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          'CBU: ',
                                                                          style: GoogleFonts.raleway(
                                                                              color:
                                                                                  Colors.black87,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        Text(
                                                                          _cuentas![index]
                                                                              .CBU!,
                                                                          style: GoogleFonts.roboto(
                                                                              color:
                                                                                  Colors.black87,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right: 15,
                                                                        left: 15),
                                                                    child:
                                                                        Divider(
                                                                      thickness:
                                                                          0.3,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                                .all(
                                                                            15.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          'Alias: ',
                                                                          style: GoogleFonts.raleway(
                                                                              color:
                                                                                  Colors.black87,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        Text(
                                                                          _cuentas![index]
                                                                              .Descripcion!,
                                                                          style: GoogleFonts.roboto(
                                                                              color:
                                                                                  Colors.black87,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      })),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(5, 7) + "/" + Fecha.substring(2, 4);
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