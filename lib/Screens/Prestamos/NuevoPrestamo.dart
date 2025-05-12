import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lottie/lottie.dart';
import 'package:smart/Widgets/InputText4.dart';
import 'package:smart/route/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smart/API/Prestamos/PrestamosApi.dart';
import 'package:smart/Models/Prestamos/PrestamosModel.dart';
import 'package:signature/signature.dart';

final storage = FlutterSecureStorage();

class NuevoPrestamoPage extends StatefulWidget implements NavigationStates {
  @override
  _NuevoPrestamoPageState createState() => _NuevoPrestamoPageState();
}

class _NuevoPrestamoPageState extends State<NuevoPrestamoPage> {
  bool _loading = true;
  final _controller = TextEditingController();
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  static const _locale = 'en';
  bool _loading2 = false;
  List<PrestamoLineasModel> actividades = [];
  List<PlanesDisponibles> montos = [];
  PrestamoLineasModel? selectedActividad;
  PlanesDisponibles? selecetedPlan;
  SignatureController? controller;
  dynamic Usuario = null;
  dynamic Lineas = null;
  final picker = ImagePicker();
  File? _imageFront;
  File? _imageRecibo;
  File? _imageCertificado;
  File? _imageBack;
  File? _imageHuman;
  int div = 0;
  bool SelecterPre = false;
  List<dynamic> PrecanceladosLista = [];
  String CFT = '';
  String CantCuotas = '';
  int MontoMax = 0;
  String MontCuotas = '1';
  int MontoMaximo = 0;
  int MontoMinimo = 0;
  int Intervalo = 0;
  Uint8List? resultFront = null;
  Uint8List? resultRecibo = null;
  FocusNode focusNode = new FocusNode();
  Uint8List? resultCertificado = null;
  bool Tipo = false;
  int cuotas = 0;
  double _currentSliderValue = 0;
  Uint8List? resultBack = null;
  String Montosdisp = '1';
  int TipoPersona = 0;
  Uint8List? resultHuman = null;
  final MontoController = TextEditingController();
  final formatCurrency = new NumberFormat.simpleCurrency();
  dynamic planesd = null;
  bool noMonto = false;
  bool disponible = false;
  String ColorTheme = '0xff064838';
  String ColorTheme2 = 'Colors.blue';
  dynamic prelogin = "";
  Uint8List? Foto;
  bool Press = false;
  bool foto1 = false;
  bool foto2 = false;
  bool foto3 = false;
  bool CheckBox = true;
  bool Ampliado = false;
  final ScrollController _scrollController = ScrollController();
  double MontoPrestado = 0;
  List<PreCancelaciones> precan = [];

  ////////////////////////////////////////////////////////////////METODOS/////////////////////////////////////////////////////////////

  getLineasDePrestamoExterno() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    TipoPersona = Usuario['TipoPersonaId'];
    Prestamos reservasClases = Prestamos();
    actividades = await reservasClases.getPrestamosLineas(
        context, Usuario["UAT"], Ampliado);
    String? lineas = await storage.read(key: 'lineas');
    Lineas = jsonDecode(lineas!);
    print(Lineas);
    if (Lineas['Status'] == 200) {
      MontoMaximo = actividades[0].MontoMaximo!.toInt();
      MontoMinimo = actividades[0].MontoMinimo!.toInt();
      Intervalo = actividades[0].Intervalo!.toInt() == 0
          ? 1000
          : actividades[0].Intervalo!.toInt();
      int div1 = MontoMaximo - MontoMinimo;
      setState(() {
        _currentSliderValue = actividades[0].MontoMinimo!;
        div = div1 ~/ Intervalo;
        _loading = false;
        Tipo = false;
      });
    } else {
      setState(() {
        disponible = true;
        _loading = false;
        Tipo = false;
      });
    }
  }

  SendMonto() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    Prestamos reservasClases = Prestamos();
    int montomensual = int.parse(_controller.value.text.replaceAll(',', ''));
    reservasClases.getMontoMax(context, Usuario["UAT"], montomensual);
    getLineasDePrestamoExterno();
  }

  getLineasDePrestamo() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    print(Usuario['UAT']);
    TipoPersona = Usuario['TipoPersonaId'];
    Prestamos reservasClases = Prestamos();
    actividades = await reservasClases.getPrestamosLineas(
        context, Usuario["UAT"], Ampliado);
    String? lineas = await storage.read(key: 'lineas');
    Lineas = jsonDecode(lineas!);
    if (Lineas['Status'] == 200) {
      selectedActividad = actividades[0];
      MontoMaximo = actividades[0].MontoMaximo!.toInt();
      MontoMinimo = actividades[0].MontoMinimo!.toInt();
      Intervalo = actividades[0].Intervalo!.toInt() == 0
          ? 1000
          : actividades[0].Intervalo!.toInt();
      int div1 = MontoMaximo - MontoMinimo;
      setState(() {
        _currentSliderValue = actividades[0].MontoMinimo!;
        div = div1 ~/ Intervalo;
        _loading = false;
      });
    } else {
      setState(() {
        disponible = true;
        _loading = false;
      });
    }
  }

  getMontosDePrestamo() async {
    String? jason = await storage.read(key: "USER");
    String? Lista = await storage.read(key: 'precancelados');
    if (Lista != null) {
      PrecanceladosLista = jsonDecode(Lista);
    } else {
      PrecanceladosLista.clear();
    }
    Usuario = jsonDecode(jason!);
    Prestamos reservasClases = Prestamos();
    if (Usuario['TipoPersonaId'] > 3) {
      montos = await reservasClases.getPlanesDisponiblesOrg(
          context,
          Usuario["UAT"],
          selectedActividad!.Id!,
          _currentSliderValue,
          Ampliado);
    } else {
      montos = await reservasClases.getPlanesDisponibles(
          context,
          Usuario["UAT"],
          selectedActividad!.Id!,
          _currentSliderValue,
          Ampliado);
    }
    Montosdisp = (await storage.read(key: 'montosdisp'))!;
    String? planes = await storage.read(key: 'planes');
    planesd = jsonDecode(planes!);
    if (planesd['Status'] != 200) {
      setState(() {
        noMonto = true;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  SolicitarPrestamo() async {
    setState(() {
      _loading = true;
    });
    String? Lista = await storage.read(key: 'precancelados');
    if (Lista != null) {
      PrecanceladosLista = jsonDecode(Lista);
    } else {
      PrecanceladosLista.clear();
    }
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    Prestamos reservasClases = Prestamos();
    Uint8List? Firma = await controller!.toPngBytes();
    String? Disponible = await storage.read(key: 'Disponible');
    if (TipoPersona > 3) {
      await reservasClases.solicitarPrestamo(
          context,
          Usuario["UAT"],
          PrecanceladosLista,
          selectedActividad!.Id!,
          resultFront!,
          resultBack!,
          resultHuman!,
          MontoPrestado,
          CantCuotas,
          double.parse(MontCuotas),
          TipoPersona,
          Firma!,
          resultRecibo!,
          resultCertificado!,
          Ampliado,
          Disponible!);
    } else {
      await reservasClases.solicitarPrestamo(
          context,
          Usuario["UAT"],
          PrecanceladosLista,
          selectedActividad!.Id!,
          resultFront!,
          resultBack!,
          resultHuman!,
          MontoPrestado,
          CantCuotas,
          double.parse(MontCuotas),
          TipoPersona,
          Firma!,
          resultRecibo!,
          resultCertificado!,
          Ampliado,
          Disponible!);
    }
    setState(() {
      _loading = false;
    });
  }

  getColor() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    print(Usuario['UAT']);
    TipoPersona = Usuario['TipoPersonaId'];
    if (TipoPersona > 3) {
      Tipo = true;
    }
    setState(() {
      _loading = false;
    });
  }

  Future getImageFront(ImageSource source) async {
    final _picker = ImagePicker();
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
          ))) ;
      _imageFront = File(cropped!.path);
      Uint8List FotoFornt = _imageFront!.readAsBytesSync();
      var result3 = await FlutterImageCompress.compressWithList(
        FotoFornt,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        foto1 = true;
        resultFront = result3;
        _loading = true;
      });
      setState(() {
        _loading = false;
      });
    }
  }

  Future getImageRecibo(ImageSource source) async {
    final _picker = ImagePicker();
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
          ))) ;
      _imageRecibo = File(cropped!.path);
      Uint8List? FotoRecibo = _imageRecibo!.readAsBytesSync();
      var result4 = await FlutterImageCompress.compressWithList(
        FotoRecibo,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        foto2 = true;
        resultRecibo = result4;
        _loading = true;
      });
      setState(() {
        _loading = false;
      });
    }
  }

  Future getImageCertificado(ImageSource source) async {
    final _picker = ImagePicker();
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
            statusBarColor: Color(0xffFF5E00),
            backgroundColor: Colors.white,
          ))) ;
      _imageCertificado = File(cropped!.path);
      Uint8List FotoCertificado = _imageCertificado!.readAsBytesSync();
      var result5 = await FlutterImageCompress.compressWithList(
        FotoCertificado,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        foto2 = true;
        resultCertificado = result5;
        _loading = true;
      });
      setState(() {
        _loading = false;
      });
    }
  }

  Future getImageBack(ImageSource source) async {
    final _picker = ImagePicker();
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
            statusBarColor: Color(0xffFF5E00),
            backgroundColor: Colors.white,
          ))) ;
      _imageBack = File(cropped!.path);
      Uint8List? FotoBack = _imageBack!.readAsBytesSync();
      var result2 = await FlutterImageCompress.compressWithList(
        FotoBack,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        foto2 = true;
        resultBack = result2;
        _loading = true;
      });
      setState(() {
        _loading = false;
      });
    }
  }

  Future getImageHuman(ImageSource source) async {
    final _picker = ImagePicker();
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
            statusBarColor: Color(0xffFF5E00),
            backgroundColor: Colors.white,
          )));
      _imageHuman = File(cropped!.path);
      Uint8List FotoHuman = _imageHuman!.readAsBytesSync();
      var result1 = await FlutterImageCompress.compressWithList(
        FotoHuman,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        foto3 = true;
        resultHuman = result1;
        _loading = true;
      });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black54,
    );
    getColor();
  }

  final KEY = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Tipo
          ? AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color(0XFF39a67b),
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text(
                      'Nuevo Préstamo',
                      style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ],
                ),
              ),
            )
          : null,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[100],
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                      color: Color(0xfff68712)
                  ),
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
              child: disponible
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    )
                  : Container(
                      child: Tipo
                          ? Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                          height: 100,
                                          width: 400,
                                          child: Image.asset(
                                              'assets/Images/logo3.png')),
                                    ),
                                    Text(
                                      'Ingrese el monto límite \nque figura en el certificado:',
                                      style: GoogleFonts.raleway(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50,
                                          right: 50,
                                          top: 35,
                                          bottom: 35),
                                      child: TextField(
                                        controller: _controller,
                                        focusNode: focusNode,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(fontSize: 30),
                                        decoration: InputDecoration(
                                          prefixText: _currency,
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(),
                                        onChanged: (string) {
                                          string =
                                              '${_formatNumber(string.replaceAll(',', ''))}';
                                          _controller.value = TextEditingValue(
                                            text: string,
                                            selection: TextSelection.collapsed(
                                                offset: string.length),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 75,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(
                                          left: 50,
                                          right: 50,
                                          top: 15,
                                          bottom: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_controller.text == '') {
                                            AlertPop.alert(context,
                                                body: Text(
                                                    'Debes completar el campo superior!'));
                                          } else {
                                            setState(() {
                                              _loading = true;
                                            });
                                            SendMonto();
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 30,
                                              right: 30),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                  const Color(0xfff68712)),
                                              borderRadius:
                                              BorderRadius.circular(40)),
                                          child: Text(
                                            'Continuar',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.raleway(
                                                color: const Color(0xfff68712),
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFF5E00),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_back,
                                                color: Colors.white),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Solicitud de Nuevo Prestamo',
                                            style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // CheckBox
                                //     ? Padding(
                                //         padding: const EdgeInsets.only(
                                //             right: 15, left: 15),
                                //         child: Container(
                                //           decoration: BoxDecoration(
                                //               color: Colors.white,
                                //               borderRadius: BorderRadius.only(
                                //                   bottomLeft:
                                //                       Radius.circular(10),
                                //                   bottomRight:
                                //                       Radius.circular(10))),
                                //           child: Center(
                                //             child: Column(
                                //               children: [
                                //                 Padding(
                                //                   padding:
                                //                       const EdgeInsets.only(
                                //                           top: 10),
                                //                   child: Row(
                                //                     mainAxisAlignment:
                                //                         MainAxisAlignment
                                //                             .spaceEvenly,
                                //                     children: [
                                //                       Padding(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                     .only(
                                //                                 left: 8.0),
                                //                         child: Text(
                                //                           'Ampliación por CBU',
                                //                           style: GoogleFonts
                                //                               .roboto(
                                //                                   fontSize: 17,
                                //                                   color: Colors
                                //                                       .black54,
                                //                                   fontWeight:
                                //                                       FontWeight
                                //                                           .w400),
                                //                         ),
                                //                       ),
                                //                       Checkbox(
                                //                         onChanged: (bool? v) {
                                //                           setState(() {
                                //                             Ampliado = v!;
                                //                           });
                                //                         },
                                //                         value: Ampliado,
                                //                         checkColor:
                                //                             Color(0xfff68712),
                                //
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //                 Padding(
                                //                   padding:
                                //                       const EdgeInsets.only(
                                //                           bottom: 8.0),
                                //                   child: OutlinedButton(
                                //                     onPressed: () {
                                //                       setState(() {
                                //                         _loading = true;
                                //                       });
                                //                       getLineasDePrestamo();
                                //                       setState(() {
                                //                         CheckBox = false;
                                //                       });
                                //                     },
                                //                     style: ButtonStyle(
                                //                       shape: MaterialStateProperty.all(
                                //                           RoundedRectangleBorder(
                                //                               borderRadius:
                                //                                   BorderRadius
                                //                                       .circular(
                                //                                           30.0))),
                                //                     ),
                                //                     child:
                                //                         const Text("Continuar"),
                                //                   ),
                                //                 )
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       )
                                //     :
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, left: 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 3,
                                                ),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: DropdownButtonFormField<
                                                            PrestamoLineasModel>(
                                                          decoration: InputDecoration(
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      right:
                                                                          10)),
                                                          hint: Center(
                                                              child: Text(
                                                            "  Seleccione tipo de Prestamo",
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                          isExpanded: true,
                                                          value: selectedActividad !=
                                                                  null
                                                              ? selectedActividad
                                                              : null,
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          onChanged:
                                                              (PrestamoLineasModel?
                                                                  newValueServicio) {
                                                            setState(() {
                                                              selectedActividad =
                                                                  newValueServicio;
                                                              _loading = true;
                                                            });
                                                            getMontosDePrestamo();
                                                          },
                                                          key: KEY,
                                                          items: actividades.map(
                                                              (PrestamoLineasModel?
                                                                  servicio) {
                                                            return new DropdownMenuItem<
                                                                PrestamoLineasModel>(
                                                              value: servicio,
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            10),
                                                                child: Center(
                                                                  child: Text(
                                                                    servicio!
                                                                        .Nombre!,
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                selectedActividad == null
                                                    ? Container(
                                                        height: 20,
                                                      )
                                                    : Column(
                                                        children: [
                                                          MontoMaximo == 0.0
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: Slider(
                                                                    activeColor:
                                                                        Colors.grey[
                                                                            200],
                                                                    onChanged:
                                                                        (double
                                                                            value) {},
                                                                    value: 0,
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: Slider(
                                                                    activeColor:
                                                                        Color(
                                                                            0xfff68712),
                                                                    inactiveColor:
                                                                        Colors.grey[
                                                                            300],
                                                                    value:
                                                                        _currentSliderValue,
                                                                    min: actividades[
                                                                            0]
                                                                        .MontoMinimo!,
                                                                    max: actividades[
                                                                            0]
                                                                        .MontoMaximo!,
                                                                    label:
                                                                        '${formatCurrency.format(_currentSliderValue)}',
                                                                    divisions:
                                                                        div,
                                                                    onChanged:
                                                                        (double
                                                                            value) async {
                                                                      setState(
                                                                          () {
                                                                        _loading2 =
                                                                            false;
                                                                        Press =
                                                                            false;
                                                                        _currentSliderValue =
                                                                            value;
                                                                        selecetedPlan =
                                                                            null;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                          Text(
                                                            'Monto del Prestamo:  ',
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              '${formatCurrency.format(_currentSliderValue)}',
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xfff68712),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          _loading2
                                                              ? Column(
                                                                  children: [
                                                                    Lottie.network("https://lottie.host/b7617c28-87e2-46d6-99f6-2b577330500e/1MH1teu5gF.json"),
                                                                    Text(
                                                                      'Calculando...',
                                                                      style: GoogleFonts
                                                                          .raleway(),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          10,
                                                                    )
                                                                  ],
                                                                )
                                                              : Press == false
                                                                  ? CupertinoButton(
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          _loading2 =
                                                                              true;
                                                                        });
                                                                        await getMontosDePrestamo();
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (context) =>
                                                                              Dialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                            child:
                                                                                Container(
                                                                              height: 380,
                                                                              child: Stack(
                                                                                children: [
                                                                                  montos == null
                                                                                      ? Padding(
                                                                                          padding: EdgeInsets.only(top: 20.0),
                                                                                          child: Center(
                                                                                              child: Text(
                                                                                            'Sin Monto Disponible',
                                                                                            style: GoogleFonts.raleway(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w500),
                                                                                          )),
                                                                                        )
                                                                                      : Padding(
                                                                                          padding: const EdgeInsets.only(top: 40.0),
                                                                                          child: ListView.builder(
                                                                                              padding: const EdgeInsets.all(8),
                                                                                              itemCount: montos.length,
                                                                                              itemBuilder: (context, index) {
                                                                                                return Padding(
                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                  child: InkWell(
                                                                                                    onTap: () {
                                                                                                      setState(() {
                                                                                                        CFT = montos[index].CFT.toString();
                                                                                                        MontCuotas = montos[index].MontoCuota.toString();
                                                                                                        CantCuotas = montos[index].CantidadCuotas.toString();
                                                                                                        MontoPrestado = montos[index].MontoPrestado!;
                                                                                                        Press = true;
                                                                                                        _loading2 = false;
                                                                                                      });
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Container(
                                                                                                      height: 90,
                                                                                                      decoration: BoxDecoration(color: (montos[index].Id! % 2) == 0 ? Colors.orange[200] : Colors.orange[300], borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                                                      child: Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                                                                            Column(
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  'CFT\n Regulado:',
                                                                                                                  style: GoogleFonts.raleway(
                                                                                                                    fontSize: 15,
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    color: Colors.grey[200],
                                                                                                                  ),
                                                                                                                  textAlign: TextAlign.center,
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  '% ' + montos[index].CFT.toString(),
                                                                                                                  style: GoogleFonts.roboto(
                                                                                                                    fontSize: 18,
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    color: Colors.grey[200],
                                                                                                                  ),
                                                                                                                  textAlign: TextAlign.center,
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            Container(
                                                                                                              child: Column(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    'En ' + montos[index].CantidadCuotas.toString() + ' Cuotas de',
                                                                                                                    style: GoogleFonts.roboto(
                                                                                                                      fontSize: 12,
                                                                                                                      fontWeight: FontWeight.w400,
                                                                                                                      color: Colors.black87,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    '${formatCurrency.format(montos[index].MontoCuota)}',
                                                                                                                    textAlign: TextAlign.left,
                                                                                                                    style: GoogleFonts.roboto(
                                                                                                                      fontSize: 18,
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      color: Colors.black87,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                          ]),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              }),
                                                                                        ),
                                                                                  Container(
                                                                                    height: 45,
                                                                                    padding: EdgeInsets.all(6),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topRight: Radius.circular(10),
                                                                                        topLeft: Radius.circular(10),
                                                                                      ),
                                                                                      color: Color(0xfff68712),
                                                                                    ),
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Text(
                                                                                        'Seleccione Opciones del Prestamo',
                                                                                        style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.topRight,
                                                                                    child: IconButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          Press = false;
                                                                                          _loading2 = false;
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      color: Colors.white,
                                                                                      icon: Icon(
                                                                                        Icons.close,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            70,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey[200],
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Calcular Prestamo",
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (context) =>
                                                                              Dialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                            child:
                                                                                Container(
                                                                              height: 380,
                                                                              child: Stack(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 40.0),
                                                                                    child: CupertinoScrollbar(
                                                                                      controller: _scrollController,
                                                                                      child: ListView.builder(
                                                                                          padding: const EdgeInsets.all(8),
                                                                                          itemCount: montos.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            return Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: InkWell(
                                                                                                onTap: () {
                                                                                                  setState(() {
                                                                                                    CFT = montos[index].CFT.toString();
                                                                                                    MontCuotas = montos[index].MontoCuota.toString();
                                                                                                    CantCuotas = montos[index].CantidadCuotas.toString();
                                                                                                    Press = true;
                                                                                                  });
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: Container(
                                                                                                  height: 90,
                                                                                                  decoration: BoxDecoration(color: (montos[index].Id! % 2) == 0 ? Colors.blue[200] : Colors.blue[300], borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                                                                        Column(
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              'CFT\n Regulado: ',
                                                                                                              style: GoogleFonts.raleway(
                                                                                                                fontSize: 15,
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                color: Colors.grey[200],
                                                                                                              ),
                                                                                                              textAlign: TextAlign.center,
                                                                                                            ),
                                                                                                            Text(
                                                                                                              '% ' + montos[index].CFT.toString(),
                                                                                                              style: GoogleFonts.roboto(
                                                                                                                fontSize: 18,
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                color: Colors.grey[200],
                                                                                                              ),
                                                                                                              textAlign: TextAlign.center,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Container(
                                                                                                          child: Column(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                'En ' + montos[index].CantidadCuotas.toString() + ' Cuotas de',
                                                                                                                style: GoogleFonts.roboto(
                                                                                                                  fontSize: 12,
                                                                                                                  fontWeight: FontWeight.w400,
                                                                                                                  color: Colors.black87,
                                                                                                                ),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                '${formatCurrency.format(montos[index].MontoCuota)}',
                                                                                                                textAlign: TextAlign.left,
                                                                                                                style: GoogleFonts.roboto(
                                                                                                                  fontSize: 18,
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  color: Colors.black87,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ]),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          }),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    height: 45,
                                                                                    padding: EdgeInsets.all(6),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topRight: Radius.circular(10),
                                                                                        topLeft: Radius.circular(10),
                                                                                      ),
                                                                                      color: Color(0xfff68712),
                                                                                    ),
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Text(
                                                                                        'Seleccione Opciones del Prestamo',
                                                                                        style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.topRight,
                                                                                    child: IconButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          Press = false;
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      color: Colors.white,
                                                                                      icon: Icon(
                                                                                        Icons.close,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(10),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              90,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.orange[200],
                                                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                                                Column(
                                                                                  children: [
                                                                                    Text(
                                                                                      'CFT\n Regulado: ',
                                                                                      style: GoogleFonts.raleway(
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.grey[200],
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    Text(
                                                                                      '% ' + CFT,
                                                                                      style: GoogleFonts.roboto(
                                                                                        fontSize: 18,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.grey[200],
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Container(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        'En ' + CantCuotas + ' Cuotas de',
                                                                                        style: GoogleFonts.roboto(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: Colors.black87,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        '${formatCurrency.format(double.parse(MontCuotas))}',
                                                                                        textAlign: TextAlign.left,
                                                                                        style: GoogleFonts.roboto(
                                                                                          fontSize: 18,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: Colors.black87,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                Container(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                      color: Color(0xfff68712),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Tomá una foto del frente de tu DNI',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    height: 140,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        image: _imageFront == null
                                            ? DecorationImage(
                                                image: const AssetImage(
                                                  'assets/Images/DniFrontal.jpg',
                                                ),
                                                fit: _imageFront == null
                                                    ? BoxFit.fitHeight
                                                    : BoxFit.cover)
                                            : DecorationImage(
                                                image:
                                                    MemoryImage(resultFront!),
                                                fit: _imageFront == null
                                                    ? BoxFit.fitHeight
                                                    : BoxFit.cover)),
                                    child: IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.camera_fill,
                                        color: Colors.transparent,
                                        size: 60,
                                      ),
                                      onPressed: () => noMonto
                                          ? AlertPop.alert(context,
                                              body: Text(planesd['Mensaje']))
                                          : getImageFront(ImageSource.camera),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                      color: Color(0xfff68712),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Tomá una foto del dorso de tu DNI',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    height: 140,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        image: _imageBack == null
                                            ? DecorationImage(
                                                image: AssetImage(
                                                    'assets/Images/DniBack.jpg'),
                                                fit: _imageBack == null
                                                    ? BoxFit.fitHeight
                                                    : BoxFit.cover)
                                            : DecorationImage(
                                                image: MemoryImage(resultBack!),
                                                fit: _imageBack == null
                                                    ? BoxFit.fitHeight
                                                    : BoxFit.cover)),
                                    child: IconButton(
                                      icon: Icon(
                                        CupertinoIcons.camera_fill,
                                        color: Colors.transparent,
                                        size: 60,
                                      ),
                                      onPressed: () => noMonto
                                          ? AlertPop.alert(context,
                                              body: Text(planesd['Mensaje']))
                                          : getImageBack(ImageSource.camera),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                      color: Color(0xfff68712),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Tomá una foto junto a tu DNI',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    height: 140,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                        image: _imageHuman == null
                                            ? DecorationImage(
                                                image: AssetImage(
                                                  'assets/Images/DniHuman.jpg',
                                                ),
                                                fit: _imageHuman == null
                                                    ? BoxFit.fitHeight
                                                    : BoxFit.cover)
                                            : DecorationImage(
                                                image:
                                                    MemoryImage(resultHuman!),
                                                fit: _imageHuman == null
                                                    ? BoxFit.fitHeight
                                                    : BoxFit.cover)),
                                    child: IconButton(
                                      icon: Icon(
                                        CupertinoIcons.camera_fill,
                                        color: Colors.transparent,
                                        size: 60,
                                      ),
                                      onPressed: () => noMonto
                                          ? AlertPop.alert(context,
                                              body: Text(planesd['Mensaje']))
                                          : getImageHuman(ImageSource.camera),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                ),
                                TipoPersona > 3
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, left: 15),
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                            color: Color(0xfff68712),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Tomá una foto de tu Recibo de Haberes',
                                            style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                TipoPersona > 3
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, left: 15),
                                        child: Container(
                                          height: 140,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              image: _imageRecibo == null
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                          'assets/Images/Recibo.jpg'),
                                                      fit: _imageRecibo == null
                                                          ? BoxFit.fitHeight
                                                          : BoxFit.cover)
                                                  : DecorationImage(
                                                      image: MemoryImage(
                                                          resultRecibo!),
                                                      fit: _imageRecibo == null
                                                          ? BoxFit.fitHeight
                                                          : BoxFit.cover)),
                                          child: IconButton(
                                            icon: Icon(
                                              CupertinoIcons.camera_fill,
                                              color: Colors.transparent,
                                              size: 60,
                                            ),
                                            onPressed: () => noMonto
                                                ? AlertPop.alert(context,
                                                    body: Text(
                                                        planesd['Mensaje']))
                                                : getImageRecibo(
                                                    ImageSource.camera),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                TipoPersona > 3
                                    ? Container(
                                        height: 20,
                                      )
                                    : Container(),
                                TipoPersona > 3
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, left: 15),
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                            color: Color(0xfff68712),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Tomá una foto de tu Certificado de Descuento ',
                                            style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                TipoPersona > 3
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, left: 15),
                                        child: Container(
                                          height: 140,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              image: _imageCertificado == null
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                          'assets/Images/Documento.jpg'),
                                                      fit: _imageCertificado ==
                                                              null
                                                          ? BoxFit.fitHeight
                                                          : BoxFit.cover)
                                                  : DecorationImage(
                                                      image: MemoryImage(
                                                          resultCertificado!),
                                                      fit: _imageCertificado ==
                                                              null
                                                          ? BoxFit.fitHeight
                                                          : BoxFit.cover)),
                                          child: IconButton(
                                            icon: Icon(
                                              CupertinoIcons.camera_fill,
                                              color: Colors.transparent,
                                              size: 60,
                                            ),
                                            onPressed: () => noMonto
                                                ? AlertPop.alert(context,
                                                    body: Text(
                                                        planesd['Mensaje']))
                                                : getImageCertificado(
                                                    ImageSource.camera),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                TipoPersona > 3
                                    ? Container(
                                        height: 20,
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                      color: Color(0xfff68712),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Aquí Firma tu solicitud',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15, left: 15),
                                      child: Signature(
                                        height: 200,
                                        controller: controller!,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      right: 0.0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IconButton(
                                          onPressed: () => controller!.clear(),
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20, bottom: 40),
                                  child: Container(
                                    height: 75,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 15,
                                        bottom: 15),
                                    child: GestureDetector(
                                      onTap: () => selectedActividad == null
                                          ? AlertPop.alert(context,
                                              body: Text(
                                                  'Seleccione Tipo de Prestamo'))
                                          : foto3 == false
                                              ? AlertPop.alert(context,
                                                  body: Text(
                                                      'Completa los campos solicitados'))
                                              : Press == false
                                                  ? AlertPop.alert(context,
                                                      body: Text(
                                                          'Debe seleccionar la cantidad de cuotas!'))
                                                  : SolicitarPrestamo(),
                                      child: Center(
                                        child: Text(
                                          'Solicitar Prestamo',
                                          style: GoogleFonts.raleway(
                                              color: Color(0xfff68712),
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
            ),
    );
  }
}
