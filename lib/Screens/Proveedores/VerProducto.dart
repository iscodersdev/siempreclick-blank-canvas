import 'dart:convert';
import 'dart:typed_data';

import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:smart/API/Prestamos/PrestamosApi.dart';
import 'package:smart/Models/Prestamos/PrestamosModel.dart';
import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
import 'package:smart/Screens/Proveedores/CompraCuotas.dart';
import 'package:smart/Widgets/MyImagen.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../Models/Prestamos/PrestamosModel.dart';

class VerProdutos extends StatefulWidget {
  @override
  _VerProdutosState createState() => _VerProdutosState();
}

final storage = FlutterSecureStorage();

class _VerProdutosState extends State<VerProdutos> {
  String? Nombre;
  String? Desc;
  String? FotoS;
  String? FotoS1;
  String? FotoS2;
  String? FotoS3;
  String? FotoS4;
  String? FotoS5;
  String? Precio;
  bool _loading = true;
  Uint8List? Foto;
  dynamic Usuario = null;
  String Montosdisp = '1';
  String ProdId = '';
  List<PlanesDisponibles> montos = [];
  List<SubProductoModel> subProductos = [];
  SubProductoModel? selectedSub;
  String Saldo = '';
  bool Billetera = true;
  List<Uint8List> fotos = [];
  getProducto() async {
    Nombre = await storage.read(key: 'ProdNombre');
    Desc = await storage.read(key: 'ProdDetail');
    FotoS = await storage.read(key: 'ProdFoto');
    FotoS1 = await storage.read(key: 'ProdFoto1');
    FotoS2 = await storage.read(key: 'ProdFoto2');
    FotoS3 = await storage.read(key: 'ProdFoto3');
    FotoS4 = await storage.read(key: 'ProdFoto4');
    FotoS5 = await storage.read(key: 'ProdFoto5');
    Precio = await storage.read(key: 'ProdPrecio');
    ProdId = (await storage.read(key: 'ProdID'))!;
    if (FotoS != null) fotos.add(convertBase64ToUint8List(FotoS!));
    if (FotoS1 != null) fotos.add(convertBase64ToUint8List(FotoS1!));
    if (FotoS2 != null) fotos.add(convertBase64ToUint8List(FotoS2!));
    if (FotoS3 != null) fotos.add(convertBase64ToUint8List(FotoS3!));
    if (FotoS4 != null) fotos.add(convertBase64ToUint8List(FotoS4!));
    if (FotoS5 != null) fotos.add(convertBase64ToUint8List(FotoS5!));
    GetSaldo();
  }
  Uint8List convertBase64ToUint8List(String? base64String) {
    List<int> bytes = base64.decode(base64String!);
    return Uint8List.fromList(bytes);
  }
  GetSaldo() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    subProductos = await GetSubProdcutos(context, Usuario['UAT'],ProdId);
    print('SUBPRODUCTOS: ${subProductos.length}' );
    await GetSaldoBilletera(context, Usuario['UAT']);
    Saldo = (await storage.read(key: 'Saldo'))!;
    String? billetera = await storage.read(key: 'Billetera');
    if (billetera == 'false') {
      Billetera = false;
    }
    setState(() {
      _loading = false;
    });
  }
  ComprarProducto() async {
    String? jason = await storage.read(key: "USER");
    Usuario = jsonDecode(jason!);
    Prestamos Class = Prestamos();
    if(subProductos.isNotEmpty){
      await Class.ComprarConFondos(context, Usuario["UAT"], int.parse(ProdId),selectedSub!.Id!);
    }else{
      await Class.ComprarConFondos(context, Usuario["UAT"], int.parse(ProdId),0);
    }
    setState(() {
      _loading = false;
    });
  }

  final formatCurrency = new NumberFormat.simpleCurrency();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducto();
  }
 int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xfff68712)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    fotos.isEmpty
                        ? const CircularProgressIndicator() // Mostrar un indicador de carga mientras se cargan las fotos
                        : Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: fotos.length,
                              onPageChanged: (index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Image(
                                  image: MemoryImage(
                                    fotos[index],
                                  ),
                                  fit: BoxFit.cover,
                                );
                              }),
                        ),
                    Container(
                      color: Colors.grey[100],
                      child: Column(
                        children: [
                          Text(
                            '${currentPage + 1}/${fotos.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                            ),
                          ),
                          Container(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0, left: 30),
                            child: Text(
                              Nombre!,
                              style: GoogleFonts.raleway(fontWeight: FontWeight.w600, fontSize: 23),
                            ),
                          ),
                          Container(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 30.0, left: 30),
                            child: Divider(
                              thickness: 1.5,
                            ),
                          ),
                          subProductos.isEmpty?Container():Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
                              margin: const EdgeInsets.only(left: 25, top: 10,bottom: 10),
                              height: 65,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: DropdownButton<SubProductoModel>(
                                value: selectedSub,
                                onChanged:
                                    (SubProductoModel? newValue) {
                                  setState(() {
                                    selectedSub = newValue;
                                    print("ESTE ES EL SELECTEDSUB: ${selectedSub?.Id}");
                                  });
                                },
                                hint: const Text('Opciones'),
                                isExpanded: true,
                                underline: Container(),
                                items: subProductos.map<
                                    DropdownMenuItem<SubProductoModel>>(
                                        (SubProductoModel sub) {
                                      return DropdownMenuItem<SubProductoModel>(
                                        value: sub,
                                        child: Row(
                                          children: [
                                            Text(
                                              sub.NombreSubProducto!,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black87,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize: 16),
                                            ), // Texto del motivo
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, top: 10, bottom: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Detalles:',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.black87
                                  ),
                                )),
                          ),
                          Desc != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 5, bottom: 10),
                                  child: SizedBox(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            Desc!,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.raleway(),
                                          ))),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 10, bottom: 10),
                                  child: Container(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Producto sin Descripcion ampliada',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.raleway(),
                                          ))),
                                ),
                          Container(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _loading
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${formatCurrency.format(double.parse(Precio!))}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700, fontSize: 19),
                    ),
                  ),
                  double.parse(Saldo) >= double.parse(Precio!)
                      ? Container(
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (double.parse(Saldo) >=
                                      double.parse(Precio!)) {
                                    setState(() {
                                      _loading = true;
                                    });
                                    ComprarProducto();
                                  } else {
                                    AlertPop.alert(context,
                                        body: Text(
                                            'No Posee Saldo Disponible para realizar la Operacion!'));
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color(0xfff68712),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Comprar',
                                      style: GoogleFonts.raleway(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(subProductos.isEmpty){
                                    storage.write(key: 'SubProductoId', value: '0');
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: CompraCuotasPage(),
                                      withNavBar:
                                      true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                    );
                                  }else{
                                    if(selectedSub!.Id != null){
                                      storage.write(key: 'SubProductoId', value: selectedSub!.Id!.toString());
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: CompraCuotasPage(),
                                        withNavBar:
                                        true, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                      );
                                    }else{
                                      _mostrarSnackBar(context, 'Seleccione una opcion del producto para comprar', 500);
                                    }
                                  }

                                },
                                child: Container(
                                  height: 30,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color(0xfff68712),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Comprar en Cuotas',
                                      style: GoogleFonts.raleway(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if(subProductos.isEmpty){
                              storage.write(key: 'SubProductoId', value: '0');
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: CompraCuotasPage(),
                                withNavBar:
                                true, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                              );
                            }else{
                              if(selectedSub != null){
                                storage.write(key: 'SubProductoId', value: selectedSub!.Id!.toString());
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: CompraCuotasPage(),
                                  withNavBar:
                                  true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                                );
                              }else{
                                _mostrarSnackBar(context, 'Seleccione una opcion del producto para comprar', 500);
                              }
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 200,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Color(0xfff68712),
                            ),
                            child: Center(
                              child: Text(
                                'Comprar en Cuotas',
                                style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
class MyImageProd extends StatelessWidget {
  final Uint8List imageBytes;
  final BoxFit boxFit;

  MyImageProd({required this.imageBytes, required this.boxFit});

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      imageBytes,
      fit: boxFit,
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