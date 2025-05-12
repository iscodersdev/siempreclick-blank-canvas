import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/API/Prestamos/PrestamosApi.dart';
import 'package:smart/Models/Prestamos/PrestamosModel.dart';
import 'package:smart/Screens/Prestamos/NuevoPrestamo.dart';
import 'package:smart/Screens/Prestamos/VerPrestamo.dart';
import 'package:smart/services/alert.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

final storage = FlutterSecureStorage();
final formatCurrency = new NumberFormat.simpleCurrency();

class PrestamosPage extends StatefulWidget {
  @override
  _PrestamosPageState createState() => _PrestamosPageState();
}

class _PrestamosPageState extends State<PrestamosPage> {
  bool _loading = true;
  dynamic Usuario = null;
  dynamic _decodedJson = null;
  bool route = false;
  dynamic _decodedJson2 = null;
  String? UAT;
  List<PrestamosModel> prestamos = [];
  String ColorTheme = '0xff064838';
  String ColorTheme2 = 'Colors.blue';
  String NombreMutual = '';
  dynamic prelogin = "";
  Uint8List? Foto;
  String? _route = '0';

  Future<void> getPrestamos() async {
    _route = await storage.read(key: 'routePrestamos');
    print("ESTE ES EL ROUTE ****************" + _route!);
    if( _route == null)
    {
      setState(() {
        route = false;
      });
    } else if(_route != '0')
    {
      setState(() {
        route = true;
      });
    }
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    Prestamos prestamosClases = Prestamos();
    prestamos = await prestamosClases.getPrestamos(context, Usuario["UAT"]);
    //AlertPop.alert(context, body: Text(prestamos.length.toString()));
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPrestamos();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color(0XFF39a67b),
          elevation: 0,
          toolbarHeight: 60,
          leading: IconButton(
            onPressed: () {
              storage.delete(key: 'routePrestamos');
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded),
          ) ,
          //leading:  route ? IconButton(
          //  onPressed: () {
          //    storage.delete(key: 'routePrestamos');
          //    Navigator.of(context).pop();
          //    },
          //  icon: Icon(Icons.arrow_back_rounded),
          //) : Image.asset('assets/Images/smart_logo.png'),
          title: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Text(
                  'Mis Prestamos',
                  style: GoogleFonts.raleway(
                      //color: Color(0xfff68712),
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                });
                getPrestamos();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.refresh,
                    //color: Color(0xfff68712),
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(" Actualizar",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          //color: Color(0xfff68712)
                          color: Colors.white
                         ))
                ],
              ),
            ),
          ],
        ),
        body: _loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Container(
                      height: 15,
                    ),
                    Text(
                      'Aguarde un instante por favor...',
                      style: GoogleFonts.roboto(color: Colors.black54),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        //PARTE BLANCA DE LA PANTALLA -----------------------------------------------------------------------------------------------------------------------------
                        RefreshIndicator(
                          onRefresh: getPrestamos,
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 10),
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Color(0XFF39a67b),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: EdgeInsets.all(15),
                                    child: GestureDetector(
                                      onTap: () {
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: NuevoPrestamoPage(),
                                          withNavBar:
                                              false, // OPTIONAL VALUE. True by default.
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        )
                                        .then((value) => setState(() {
                                              setState(() {
                                                _loading = true;
                                              });
                                              getPrestamos();
                                            }));
                                      },
                                      child: Center(
                                        child: Text(
                                          'Solicitar Prestamo',
                                          style: GoogleFonts.raleway(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                prestamos.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(height: 40),
                                               Icon(
                                                MdiIcons.alertCircle,
                                                color: Colors.black54,
                                                size: 35,
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              const Text(
                                                "No se encontraron Prestamos",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        child: ListView.builder(
                                            addAutomaticKeepAlives: false,
                                            cacheExtent: 100.0,
                                            itemCount: prestamos.length,
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 20),
                                                child: InkWell(
                                                  onTap: () =>
                                                      IrAPrestamo(index),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 5,
                                                        color: Colors.white,
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[600],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          9),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          9)),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 15),
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  prestamos[
                                                                          index]
                                                                      .Estado!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .roboto(
                                                                          color:
                                                                              Colors.white),
                                                                ),
                                                                Container(
                                                                  width: 10,
                                                                ),
                                                                const Icon(
                                                                  CupertinoIcons
                                                                      .arrow_down_right_circle,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 18,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius: 2,
                                                                blurRadius: 7,
                                                                offset: Offset(
                                                                    0,
                                                                    3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        convertirFecha(prestamos[index]
                                                                            .Fecha!),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.black54)),
                                                                    Container(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          210,
                                                                      child: Text(
                                                                          prestamos[index]
                                                                              .Producto!,
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style: GoogleFonts.roboto(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black87)),
                                                                    ),

                                                                    //
                                                                  ],
                                                                ),
                                                                Divider(),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      'Ver Más',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                    Text(
                                                                      '${formatCurrency.format(prestamos[index].Saldo)}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize:
                                                                              18,
                                                                          color: Color(
                                                                              0xffFF5E00),
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                    ),
                                                                    Container(
                                                                      height: 5,
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                          'CFT Regulado: ',
                                                                          style:
                                                                              GoogleFonts.raleway(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          '% ' +
                                                                              prestamos[index].CFT.toString(),
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                      Container(
                                                        height: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Color(
                                                              int.parse(
                                                                  prestamos[
                                                                          index]
                                                                      .Color!)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void IrAPrestamo(int index) async {
    storage.write(key: "PrestamoID", value: prestamos[index].Id.toString());
    storage.write(key: "ProductoPrestamo", value: prestamos[index].Producto);
    storage.write(key: "FechaPrestamo", value: prestamos[index].Fecha);
    storage.write(
        key: "SaldoPrestamo", value: prestamos[index].Saldo.toString());
    storage.write(
        key: "AnulablePrestamo", value: prestamos[index].Anulable.toString());
    storage.write(
        key: "ConfirmablePrestamo",
        value: prestamos[index].Confirmable.toString());
    storage.write(
        key: "TransferidoPrestamo",
        value: prestamos[index].Transferido.toString());
    storage.write(key: "EstadoPrestamo", value: prestamos[index].Estado);
    storage.write(key: "ColorPrestamo", value: prestamos[index].Color);
    storage.write(
        key: "CantidadCuotasPrestamo",
        value: prestamos[index].CantidadCuotas.toString());
    storage.write(
        key: "MontoCuotaPrestamo",
        value: prestamos[index].MontoCuota.toString());
    storage.write(
        key: "MontoCuotaPrestamoAmpliado",
        value: prestamos[index].MontoCuotaAmpliado.toString());
    storage.write(key: "CFT", value: prestamos[index].CFT.toString());
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: VerPrestamos(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    ).then((value) => setState(() {
          getPrestamos();
        }));
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(8, 10) +
      "/" +
      Fecha.substring(5, 7) +
      "/" +
      Fecha.substring(0, 4);
}
