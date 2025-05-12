import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart/API/Prestamos/PrestamosApi.dart';
import 'package:smart/Models/Prestamos/PrestamosModel.dart';
import 'package:smart/Screens/Prestamos/VerLegajo.dart';
import 'package:smart/Widgets/InputText4.dart';
import 'package:smart/services/alert.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:signature/signature.dart';

final storage = FlutterSecureStorage();

class VerPrestamos extends StatefulWidget {
  @override
  _VerPrestamosState createState() => _VerPrestamosState();
}

class _VerPrestamosState extends State<VerPrestamos> {
  dynamic Usuario = null;
  dynamic _decodedJson = null;
  bool _loading = true;
  List<PrestamoRenglonModel> renglones = [];
  final formatCurrency = new NumberFormat.simpleCurrency();
  String ColorTheme = '0xff064838';
  SignatureController? controllerSignature;
  String ColorTheme2 = 'Colors.blue';



  @override
  void initState() {
    super.initState();
    controllerSignature = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black54,
    );
    getRenglones();
  }

  String Producto = "";
  String Saldo = "";
  String Fecha = "";
  String Anulable = '';
  String Confirmable = "";
  String Transferido = "";
  String Token = "0";
  String Estado = '';
  String MontoCuota = '';
  String MontoCuotaAmpliado = '';
  String CFT = '';
  String ColorEstado = '';
  String CantidadCuotas = '';
  final TokenController = TextEditingController();
  String MailOculto = '';
  getRenglones() async {
    String? jason = await storage.read(key: "USER");
    String? Id = await storage.read(key: "PrestamoID");
    Producto = (await storage.read(key: "ProductoPrestamo"))!;
    Fecha = (await storage.read(key: "FechaPrestamo"))!;
    Saldo = (await storage.read(key: "SaldoPrestamo"))!;
    Anulable = (await storage.read(key: "AnulablePrestamo"))!;
    Confirmable = (await storage.read(key: "ConfirmablePrestamo"))!;
    Transferido = (await storage.read(key: "TransferidoPrestamo"))!;
    Estado = (await storage.read(key: 'EstadoPrestamo'))!;
    MontoCuota = (await storage.read(key: 'MontoCuotaPrestamo'))!;
    MontoCuotaAmpliado =
        (await storage.read(key: 'MontoCuotaPrestamoAmpliado'))!;
    CantidadCuotas = (await storage.read(key: 'CantidadCuotasPrestamo'))!;
    ColorEstado = (await storage.read(key: 'ColorPrestamo'))!;
    CFT = (await storage.read(key: 'CFT'))!;
    Usuario = jsonDecode(jason!);
    MailOculto = Usuario['MailOculto'];
    Prestamos prestamosClases = Prestamos();
    renglones = await prestamosClases.getPrestamosRenglones(
        context, Usuario["UAT"], int.parse(Id!));
    //AlertPop.alert(context, body: Text(prestamos.length.toString()));
    setState(() {
      _loading = false;
    });
  }

  PedirToken() async {
    setState(() {
      _loading = true;
    });
    String? jason = await storage.read(key: "USER");
    String? Id = await storage.read(key: "PrestamoID");
    Usuario = jsonDecode(jason!);
    Prestamos reservasClases = Prestamos();
    await reservasClases.PedirToken(context, Usuario["UAT"], int.parse(Id!));
    Token = (await storage.read(key: "Token"))!;
    setState(() {
      _loading = false;
    });
  }

  ConfirmaPrestamo() async {
    setState(() {
      _loading = true;
    });
    String? jason = await storage.read(key: "USER");
    String? Id = await storage.read(key: "PrestamoID");
    Uint8List? Firma = await controllerSignature!.toPngBytes();
    Usuario = jsonDecode(jason!);
    Prestamos reservasClases = Prestamos();
    if (TokenController.text == null) {
      TokenController.text = '0';
    }
    await reservasClases.ConfirmaPrestamo(
        context, Usuario["UAT"], int.parse(Id!), TokenController.text, Firma!);
    setState(() {
      _loading = false;
    });
  }

  AnularPrestamo() async {
    setState(() {
      _loading = true;
    });
    String? Id = await storage.read(key: "PrestamoID");
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    Prestamos reservasClases = Prestamos();
    await reservasClases.anularPrestamo(
        context, Usuario["UAT"], int.parse(Id!));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          actions: [
            InkWell(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: VerLegajoPage(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                );
              },
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_right_outlined,
                      color: Colors.black54,
                    ),
                    Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          'Ver Legajo',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ))
                  ],
                ),
              ),
            )
          ],
          backgroundColor: Colors.grey[200],
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _loading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 15, top: 15),
                            decoration: BoxDecoration(
                                color: Color(0xffFF5E00),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                            child: Center(
                              child: Text(
                                Producto,
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Estado == 'Solicitado'
                                    ? Text(
                                        "Fecha Solicitado:",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54),
                                      )
                                    : Text(
                                        "Fecha de Inicio:",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54),
                                      ),
                                Text(convertirFecha(Fecha),
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54)),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Estado:",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffFF5E00),
                                  ),
                                ),
                                Text(Estado,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(int.parse(ColorEstado)))),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Estado == 'Solicitado'
                                    ? Text(
                                        "Monto Solicitado:",
                                        style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffFF5E00),
                                        ),
                                      )
                                    : Text(
                                        "Saldo del Prestamo:",
                                        style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffFF5E00),
                                        ),
                                      ),
                                Text(
                                    '${formatCurrency.format(double.parse(Saldo))}',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green)),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cantidad de Cuotas:",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffFF5E00),
                                  ),
                                ),
                                Text(CantidadCuotas,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Monto de Cuota:",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffFF5E00),
                                  ),
                                ),
                                Text(
                                    '${formatCurrency.format(double.parse(MontoCuota))}',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue)),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          MontoCuotaAmpliado == ''
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Monto de Cuota Ampliado:",
                                        style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffFF5E00),
                                        ),
                                      ),
                                      Text(
                                          '${formatCurrency.format(double.parse(MontoCuotaAmpliado))}',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.roboto(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue)),
                                    ],
                                  ),
                                ),
                          MontoCuotaAmpliado == ''
                              ? Container()
                              : Divider(
                                  thickness: 1,
                                ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "CFT Regulado:",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffFF5E00),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '%  ',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(CFT,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          renglones.length != 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 8, top: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xffFF5E00),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Eventos",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Confirmable == 'true'
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 8, top: 8),
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(bottom: 8, top: 8),
                                        decoration: BoxDecoration(
                                          color: Color(0xffFF5E00),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Firma debajo para confirmar el prestamo",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Divider(
                                      thickness: 1,
                                    ),
                          renglones.length != 0
                              ? Container(
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                            thickness: 1,
                                          ),
                                      physics: ClampingScrollPhysics(),
                                      itemCount: renglones.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                            leading:
                                                renglones[index].Credito! > 0.0
                                                    ? Icon(
                                                        CupertinoIcons
                                                            .money_dollar_circle,
                                                        color: Colors.green,
                                                        size: 38,
                                                      )
                                                    : Icon(
                                                        CupertinoIcons
                                                            .checkmark_alt,
                                                        color: Colors.blue,
                                                        size: 35,
                                                      ),
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  renglones[index].Concepto!,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 17,
                                                    color: Color(0xffFF5E00),
                                                  ),
                                                ),
                                                Text(
                                                  convertirFecha(Fecha),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            title: renglones[index].Credito! >
                                                    0.0
                                                ? Text(
                                                    "Credito",
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.green,
                                                        fontSize: 13),
                                                  )
                                                : Text("Debito",
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.blue,
                                                        fontSize: 13)),
                                            trailing: renglones[index]
                                                        .Credito! >
                                                    0.0
                                                ? Text(
                                                    '${formatCurrency.format(double.parse(renglones[index].Credito.toString()))}',
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.green,
                                                        fontSize: 16),
                                                  )
                                                : Text(
                                                    '${formatCurrency.format(double.parse(renglones[index].Debito.toString()))}',
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.blue,
                                                        fontSize: 16),
                                                  ));
                                      }))
                              : Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Transferido == 'true'
                                          ? Icon(
                                              Icons.file_download_done,
                                              size: 35,
                                              color: Colors.black54,
                                            )
                                          : Container(),
                                      Confirmable == 'true'
                                          ? Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15, left: 15),
                                                  child: Signature(
                                                    height: 200,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    controller:
                                                        controllerSignature!,
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0.0,
                                                  right: 0.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: IconButton(
                                                      onPressed: () =>
                                                          controllerSignature!
                                                              .clear(),
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      Estado == 'Solicitado'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                "assets/Images/PrestamosIcon.png",
                                                color: Colors.black54,
                                                scale: 17,
                                              ),
                                            )
                                          : Container(),
                                      Estado == 'Esperando Transferencia'
                                          ? Lottie.network("https://lottie.host/b7617c28-87e2-46d6-99f6-2b577330500e/1MH1teu5gF.json")
                                          : Container(),
                                      Container(
                                        height: 5,
                                      ),
                                      Estado == 'Anulado Por Causante'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                MdiIcons.cancel,
                                                color: Colors.black54,
                                                size: 33,
                                              ),
                                            )
                                          : Container(),
                                      Estado == 'Esperando Transferencia'
                                          ? Text('Esperando...',
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black54))
                                          : Container(),
                                      Container(
                                        height: 10,
                                      ),
                                      Confirmable == 'true'
                                          ? Divider(
                                              thickness: 1,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Confirmable == 'true'
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(right: 15, left: 15),
                          child: GestureDetector(
                            onTap: () async {
                              await PedirToken();
                              Token == '0'
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(
                                                                    0xffFF5E00),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          15),
                                                                )),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                'Autenticacion',
                                                                style: GoogleFonts.roboto(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                            )
                                                          ],
                                                        )),
                                                    Container(
                                                      height: 200,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                          )),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                'Para Confirmar este Prestamo ingrese el Token que acaba de recibir en su casilla de eMail: ' +
                                                                    MailOculto,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  color: Colors
                                                                      .black87,
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    right: 20,
                                                                    bottom: 5,
                                                                    top: 5),
                                                            child: TextInput6(
                                                              label: 'Token',
                                                              inputType:
                                                                  TextInputType
                                                                      .number,
                                                              Controller:
                                                                  TokenController,
                                                              inputIcon: Icon(
                                                                CupertinoIcons
                                                                    .person_alt_circle,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              inputStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                              validator: (String
                                                                  text) {
                                                                if (text
                                                                    .isEmpty) {
                                                                  return '!';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              ConfirmaPrestamo();
                                                            },
                                                            child: Text(
                                                              'Confirmar',
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ));
                                      });
                            },
                            child: Text(
                              'Confirmar Prestamo',
                              style: GoogleFonts.raleway(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        )
                      : Container(),
                  Anulable == 'false'
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(right: 15, left: 15),
                          child: GestureDetector(
                            onTap: () {
                              /////////////////////////////////////////////////////////////////////////////////////////////
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.all(10),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xffFF5E00),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15),
                                                        )),
                                                    child: Center(
                                                        child: Text(
                                                      'Confirmacion',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    ))),
                                                Container(
                                                  height: 130,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(15),
                                                      )),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Text(
                                                            'Esta seguro de anular este préstamo?',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 18,
                                                              color: Colors
                                                                  .black87,
                                                            )),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Container(
                                                            width: 100,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20),
                                                                color: Colors.grey.shade400
                                                            ),
                                                            child: Center(
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Cancelar',
                                                                  style: GoogleFonts.raleway(
                                                                      color: Colors.white,
                                                                          fontSize: 14,
                                                                            fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 100,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20),
                                                                color: const Color(0xffFF5E00)
                                                            ),
                                                            child: Center(
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  AnularPrestamo();
                                                                },
                                                                child: Text(
                                                                  'Anular',
                                                                  style: GoogleFonts
                                                                      .raleway(
                                                                          color: Colors.white,
                                                                          fontSize: 14,
                                                                      fontWeight: FontWeight.bold

                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ));
                                  });
                            },
                            child: Center(
                              child: Container(
                                width: 160,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xffFF5E00),
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                child: Center(
                                  child: Text(
                                    'Anular Prestamo',
                                    style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Transferido == 'true'
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(15),
                          child: GestureDetector(
                            onTap: () {
                              AnularPrestamo();
                            },
                            child: Text(
                              'Descargar Comprobante',
                              style: GoogleFonts.raleway(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        )
                      : Container(),
                ],
              )));
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(8, 10) +
      "/" +
      Fecha.substring(5, 7) +
      "/" +
      Fecha.substring(0, 4);
}
