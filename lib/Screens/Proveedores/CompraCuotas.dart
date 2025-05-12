import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:smart/API/Proveedores/ProveedoresAPI.dart';
import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smart/API/Prestamos/PrestamosApi.dart';
import 'package:smart/Models/Prestamos/PrestamosModel.dart';
import 'package:signature/signature.dart';

final storage = FlutterSecureStorage();

class CompraCuotasPage extends StatefulWidget {
  @override
  _CompraCuotasPageState createState() => _CompraCuotasPageState();
}

class _CompraCuotasPageState extends State<CompraCuotasPage> {
  bool _loading = true;
  List<PrestamoLineasModel> actividades = [];
  List<ProductosCompradosFinanciamientoModel> montos = [];
  PrestamoLineasModel? selectedActividad;
  ProductosCompradosFinanciamientoModel? selecetedPlan;
  SignatureController? controller;
  dynamic Usuario = null;
  final picker = ImagePicker();
  File? _imageFront;
  File? _imageBack;
  File? _imageHuman;
  File? _imageRecibo;
  File? _imageCertificado;
  bool frontIMG = false;
  bool backIMG = false;
  bool humanIMG = false;
  bool certificadoIMG = false;
  bool reciboIMG = false;
  String? Nombre;
  String? Desc;
  String? FotoS;
  String? Precio;
  Uint8List? resultFront = null;
  Uint8List? resultBack = null;
  String Montosdisp = '1';
  Uint8List? resultHuman = null;
  Uint8List? resultRecibo = null;
  Uint8List? resultCertificado = null;
  int TipoPersona = 0;
  String ProdId = '';
  String? SubProdId = '';
  final MontoController = TextEditingController();
  final formatCurrency = new NumberFormat.simpleCurrency();

  getProducto() async {
    Nombre = await storage.read(key: 'ProdNombre');
    Desc = await storage.read(key: 'ProdDetail');
    FotoS = await storage.read(key: 'ProdFoto');
    Precio = await storage.read(key: 'ProdPrecio');
    ProdId = (await storage.read(key: 'ProdID'))!;
    SubProdId = await storage.read(key: 'SubProductoId');
    print("ESTE ES EL SUBPRODID: ${SubProdId}");
    getMontosDePrestamo();
  }

  getMontosDePrestamo() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    TipoPersona = Usuario['TipoPersonaId'];
    Proveedores provClases = Proveedores();
    montos = await provClases.getPlanesDisponiblesComprar(
      context, Usuario["UAT"], int.parse(ProdId),);

    Montosdisp = (await storage.read(key: 'montosdispprod'))!;
    setState(() {
      _loading = false;
    });
  }

  String ColorTheme = '0xff064838';
  String ColorTheme2 = 'Colors.blue';

  Future getImageFront(ImageSource source) async {
    final _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File? cropped = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Color(0xfff68712),
            toolbarTitle: "Recortar",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Color(0xfff68712),
            backgroundColor: Colors.white,
          )) ;
      _imageFront = File(cropped!.path);
      Uint8List? FotoFornt = _imageFront!.readAsBytesSync();
      var result3 = await FlutterImageCompress.compressWithList(
        FotoFornt,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        resultFront = result3;
        frontIMG = true;
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
            toolbarColor: Color(0xfff68712),
            toolbarTitle: "Recortar",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Color(0xfff68712),
            backgroundColor: Colors.white,
          )));
      _imageBack = File(cropped!.path);
      Uint8List FotoBack = _imageBack!.readAsBytesSync();
      var result2 = await FlutterImageCompress.compressWithList(
        FotoBack,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        resultBack = result2;
        backIMG = true;
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
            toolbarColor: Color(0xfff68712),
            toolbarTitle: "Recortar",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Color(0xfff68712),
            backgroundColor: Colors.white,
          ))) ;
      _imageHuman = File(cropped!.path);
      Uint8List FotoHuman = _imageHuman!.readAsBytesSync();
      var result1 = await FlutterImageCompress.compressWithList(
        FotoHuman,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        resultHuman = result1;
        _loading = true;
        humanIMG = true;
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
            toolbarColor: Color(0xfff68712),
            toolbarTitle: "Recortar",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Color(0xfff68712),
            backgroundColor: Colors.white,
          ))) ;
      _imageRecibo = File(cropped!.path);
      Uint8List FotoRecibo = _imageRecibo!.readAsBytesSync();
      var result4 = await FlutterImageCompress.compressWithList(
        FotoRecibo,
        minHeight: 600,
        minWidth: 600,
        quality: 96,
      );
      setState(() {
        resultRecibo = result4;
        _loading = true;
        reciboIMG = true;
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
            toolbarColor: Color(0xfff68712),
            toolbarTitle: "Recortar",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Color(0xfff68712),
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
        resultCertificado = result5;
        _loading = true;
        certificadoIMG = true;
      });
      setState(() {
        _loading = false;
      });
    }
  }

  SolicitarPrestamo() async {
    setState(() {
      _loading = true;
    });
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    Prestamos reservasClases = Prestamos();
    Uint8List? Firma = await controller!.toPngBytes();
    if (selecetedPlan == null && montos.length != 0) {
      AlertPop.alert(context,
          body: Text('Porfavor Seleccionar una opcion de Cuotas!'));
    } else {
      if (resultFront == null) {
        AlertPop.alert(context,
            body: Text('Porfavor Cargar las fotos en los cuadros superiores!'));
      } else {
        if (resultHuman == null) {
          AlertPop.alert(context,
              body:
                  Text('Porfavor Cargar las fotos en los cuadros superiores!'));
        } else {
          if (resultBack == null) {
            AlertPop.alert(context,
                body: Text(
                    'Porfavor Cargar las fotos en los cuadros superiores!'));
          } else {
            if (Firma == null) {
              AlertPop.alert(context, body: Text('Debe firmar su Solicitud!'));
            } else {
              if (TipoPersona > 3) {
                await reservasClases.CompraEnCuotas(
                    context,
                    Usuario["UAT"],
                    1,
                    resultFront!,
                    resultBack!,
                    resultHuman!,
                    selecetedPlan!.MontoPrestado!,
                    selecetedPlan!.CantidadCuotas!,
                    selecetedPlan!.MontoCuota!,
                    TipoPersona,
                    Firma,
                    resultRecibo!,
                    resultCertificado!,
                    ProdId,
                    SubProdId!
                );
              } else {
                await reservasClases.CompraEnCuotas(
                    context,
                    Usuario["UAT"],
                    1,
                    resultFront!,
                    resultBack!,
                    resultHuman!,
                    selecetedPlan!.MontoPrestado!,
                    selecetedPlan!.CantidadCuotas!,
                    selecetedPlan!.MontoCuota!,
                    TipoPersona,
                    Firma,
                    resultRecibo!,
                    resultCertificado!,
                    ProdId,
                    SubProdId!
                );
              }
            }
          }
        }
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black54,
    );

    getProducto();
  }

  dynamic prelogin = "";
  Uint8List? Foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[300],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xfff68712),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Compra en Cuotas',
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
                    montos == null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(Icons.error_outline),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'No posee Prestamos Disponibles\n ni Fondos en la Billetera',
                                          style: GoogleFonts.roboto(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 3,
                                    ),
                                    montos.isEmpty ?
                                    Center(child:
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("El producto no tiene opciones de financiamiento disponible.",
                                        style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                          textAlign: TextAlign.center
                                        ),
                                      ))
                                    :Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 90,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            alignment: Alignment.center,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<
                                                  ProductosCompradosFinanciamientoModel>(
                                                itemHeight: 90,
                                                hint: Center(
                                                    child: Text(
                                                  "  Cantidad de Cuotas",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black87,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )),
                                                isExpanded: true,
                                                dropdownColor: Colors.grey[200],
                                                value: selecetedPlan,
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.black87,
                                                ),
                                                onChanged:
                                                    (ProductosCompradosFinanciamientoModel?
                                                        newValueServicio) {
                                                  setState(() {
                                                    selecetedPlan =
                                                        newValueServicio;
                                                  });
                                                },
                                                items: montos.map(
                                                    (ProductosCompradosFinanciamientoModel
                                                        servicio) {
                                                  return new DropdownMenuItem<
                                                      ProductosCompradosFinanciamientoModel>(
                                                    value: servicio,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 90,
                                                        decoration: BoxDecoration(
                                                            color: (servicio.Id! %
                                                                        2) ==
                                                                    0
                                                                ? Colors
                                                                    .orange[200]
                                                                : Colors
                                                                    .orange[300],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        'En ' +
                                                                            servicio.CantidadCuotas.toString() +
                                                                            ' Cuotas de',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          '${formatCurrency.format(servicio.MontoCuota)}',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Colors.black87,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        'CFT: % ',
                                                                        style: GoogleFonts
                                                                            .raleway(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.grey[200],
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      Text(
                                                                        servicio
                                                                            .CFT
                                                                            .toString(),
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.grey[200],
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 10,
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
                      padding: const EdgeInsets.only(right: 15, left: 15),
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
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Container(
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            image: frontIMG == false
                                ? DecorationImage(
                                    image: AssetImage(
                                      'assets/Images/DniFrontal.jpg',
                                    ),
                                    fit: _imageFront == null
                                        ? BoxFit.fitHeight
                                        : BoxFit.cover)
                                : DecorationImage(
                                    image: MemoryImage(resultFront!),
                                    fit: BoxFit.cover)),
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.camera_fill,
                            color: Colors.black38,
                            size: 60,
                          ),
                          onPressed: () => getImageFront(ImageSource.camera),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
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
                          'Tomá una foto del dorso de tu DNI',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Container(
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          image: backIMG == false
                              ? DecorationImage(
                                  image:
                                      AssetImage('assets/Images/DniBack.jpg'),
                                  fit: _imageBack == null
                                      ? BoxFit.fitHeight
                                      : BoxFit.cover)
                              : DecorationImage(
                                  image: MemoryImage(resultBack!),
                                  fit: BoxFit.cover),
                        ),
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.camera_fill,
                            color: Colors.black38,
                            size: 60,
                          ),
                          onPressed: () => getImageBack(ImageSource.camera),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
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
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Container(
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Colors.white,
                            image: humanIMG
                                ? DecorationImage(
                                    image: MemoryImage(resultHuman!),
                                    fit: _imageHuman == null
                                        ? BoxFit.fitHeight
                                        : BoxFit.cover)
                                : DecorationImage(
                                    image: AssetImage(
                                      'assets/Images/DniHuman.jpg',
                                    ),
                                    fit: _imageHuman == null
                                        ? BoxFit.fitHeight
                                        : BoxFit.cover)),
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.camera_fill,
                            color: Colors.black38,
                            size: 60,
                          ),
                          onPressed: () => getImageHuman(ImageSource.camera),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    TipoPersona > 3
                        ? Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
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
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                image: _imageRecibo == null
                                    ? const DecorationImage(
                                        image: AssetImage(
                                            'assets/Images/Recibo.jpg'),
                                        fit: BoxFit.fitHeight)
                                    : DecorationImage(
                                        image: MemoryImage(resultRecibo!),
                                        fit: BoxFit.cover),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.camera_fill,
                                  color: Colors.transparent,
                                  size: 60,
                                ),
                                onPressed: () =>
                                    getImageRecibo(ImageSource.camera),
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
                            padding: const EdgeInsets.only(right: 15, left: 15),
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
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                image: _imageCertificado == null
                                    ? const DecorationImage(
                                        image: AssetImage(
                                            'assets/Images/Documento.jpg'),
                                        fit: BoxFit.fitHeight)
                                    : DecorationImage(
                                        image: MemoryImage(resultCertificado!),
                                        fit: BoxFit.cover),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.camera_fill,
                                  color: Colors.transparent,
                                  size: 60,
                                ),
                                onPressed: () =>
                                    getImageCertificado(ImageSource.camera),
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
                      padding: const EdgeInsets.only(right: 15, left: 15),
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
                          'Aquí Firma tu solicitud de compra en Cuotas',
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
                          padding: const EdgeInsets.only(right: 15, left: 15),
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
                            padding: const EdgeInsets.only(right: 10.0),
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
                      padding: const EdgeInsets.only(right: 15, left: 15),
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
                    Container(
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          SolicitarPrestamo();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xfff68712),
                          ),
                          child: Center(
                            child: Text(
                              'Finalizar Compra',
                              style: GoogleFonts.raleway(
                                  color: Colors.white,fontWeight: FontWeight.w600, fontSize: 18),
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
