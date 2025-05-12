import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart/API/Billetera/BilleteraApi.dart';
import 'package:smart/API/Movimientos/MovimientosAPI.dart';
import 'package:smart/API/Proveedores/ProveedoresAPI.dart';
import 'package:smart/Models/Movimientos%20Model/MovimientosModel.dart';
import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
import 'package:smart/Screens/EnviarDinero/EnviarDinero.dart';
import 'package:smart/Screens/Proveedores/Proveedores.dart';
import 'package:smart/Screens/Receta/Receta.dart';
import 'package:smart/Screens/RecibirDinero/RecibirDinero.dart';
import 'package:smart/Screens/Servicios/ServiciosPage.dart';
import 'package:smart/Screens/Tarjetas/Tarjetas.dart';
import 'package:smart/Screens/mas/Mas.dart';
import 'package:smart/route/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:smart/services/alert.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:smart/Widgets/MyImagen.dart';

import '../../API/noticia.dart';
import '../../Models/noticia/Noticia.dart';
import '../../Widgets/Preview.dart';
import '../BottomBar/BottomBar.dart';
import '../Proveedores/VerProducto.dart';

final storage = FlutterSecureStorage();
final formatCurrency = new NumberFormat.currency(locale: 'id', symbol: "\$");

class MiControlador extends GetxController {
  final _navController = 0.obs;
}

class HomeScreenPage extends StatefulWidget implements NavigationStates {
  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  bool _loading = true;
  String UAT = 'abcdefg';
  String Saldo = '0';
  dynamic Usuario = null;
  List<MovimientosModel>? _Movimientos;
  List<ProveedoresModel>? _Proveedores;
  List<RubrosModel>? _Rubros;
  bool Billetera = true;
  String Mensaje = '';
  List<ProductosModel>? _Productos;
  String Nombre = '.';
  List<NoticiaModel> _noticias = [];
  int _currentIndex = 0;

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
    }
    GetMovimientos();
  }

  GetMovimientos() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Movimientos movimientosClases = Movimientos();
    _Movimientos =
        (await movimientosClases.getMovimientos(context, Usuario['UAT']));
    GetProveedores();
  }

  GetProveedores() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Proveedores proveedoresClases = Proveedores();
    _Proveedores =
        (await proveedoresClases.getProveedores(context, Usuario['UAT']));
    _Rubros = await proveedoresClases.getRubros(context, Usuario['UAT']);
    print("ESTA ES LA CANTIDAD DE RUBROS ${_Rubros!.length}");
    GetProductos();
  }


  GetProductos() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Proveedores proveedoresClases = Proveedores();
    _Productos = await proveedoresClases.getProductosHome(
        context, Usuario['UAT'], _Proveedores![0].Id.toString());
    NoticiasServices noticiasClass = NoticiasServices();
    _noticias = await noticiasClass.getNovedades(context, Usuario["UAT"], 0);
    setState(() {
      // CantidadCargada = _noticiasService.novedades.length;
      _loading = false;
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetSaldo();
  }

  @override
  Widget build(BuildContext context) {
    final controlador = Get.put(MiControlador());
    var fullWidth = MediaQuery.of(context).size.width;
    var fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0XFF39a67b),
        title:Padding(
          padding: const EdgeInsets.only(left: 100,right:100),
          child: Center(child: Image.asset('assets/Images/siempreclickLogo.png',width: 150,height: 60))
        ),

      ),
        body: _loading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Lottie.asset(
                          'assets/gifs/lottie_load.json', // Replace with the actual asset path
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text('Aguarde porfavor...',
                          style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500))
                    ]))
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CarouselSlider.builder(

                        options: CarouselOptions(height: fullHeight * 0.2, autoPlay: true,enableInfiniteScroll: false ),
                        itemCount: _noticias.length ,
                        itemBuilder: (context, index, pa) {
                          return Padding(
                              padding:
                              const EdgeInsets.only(top: 10, bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  IrANoticia(context, _noticias[index].Id!.toString(), _noticias[index].Titulo!,
                                      _noticias[index].Texto!, _noticias[index].Fecha!.toString(), _noticias[index].Imagen!);
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: MemoryImage(_noticias[index].Imagen!
                                    ),
                                        fit: BoxFit.cover
                                  )
                                ),
                              ))));
                        }
                    ),
                    Container(
                      height: fullHeight * 0.12,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 33),
                          child: GestureDetector(
                            onTap: () {
                              controlador._navController.value = 2;
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: WalletPage(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                              constraints: const BoxConstraints(minHeight: 50, maxHeight: 60),
                              width: fullWidth,
                              decoration: BoxDecoration(
                                color: const Color(0XFF39a67b),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3), // Cambia la posición de la sombra
                                  ),
                                ],
                              ),
                              child:

                              // Texto centrado
                              Padding(
                                  padding: const EdgeInsets.only(top: 12, left: 10),
                                  child:
                                  Text(
                                      'Maneja tu Billetera Virtual Aquí',
                                      style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ))
                              ),

                            ),
                          ),
                        ),
                        Positioned(
                          right: 35,
                          bottom: 15,
                          child: Image.asset(
                            'assets/Images/billetera.png',
                            width: 60,
                            height: 60,
                          ),
                        ),

                      ],
                    ),
                    ),



                    ////////////////////////////////////////////////END UPPER PART///////////////////////////////////////////////



                    _Rubros!.length == 0 || _Rubros == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 40.0, bottom: 20),
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 30,
                                    color: Color(0xfff68712),
                                  ),
                                ),
                                Text(
                                  'No se encontraron \nProductos Disponibles',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                          height: 160,
                          child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                              // gridDelegate:
                              //     const SliverGridDelegateWithFixedCrossAxisCount(
                              //   crossAxisCount: 2,
                              //   crossAxisSpacing: 20,
                              //   mainAxisSpacing: 20,
                              // ),
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 18),
                              //physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  16, // Cambia esto al número correcto de productos
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    storage.write(
                                        key: "RubroId",
                                        value: _Rubros![index].Id!.toString());
                                    IrARubro(_Rubros![index].Id!);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,

                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(

                                                children: [
                                                  Container(
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        color: Color(0XFFF6F6F6),
                                                        borderRadius:
                                                        BorderRadius.circular(100),
                                                        image: _Rubros![index]
                                                                    .IconoAPP ==
                                                                null
                                                            ? const DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/Images/no-foto.png'),
                                                                fit: BoxFit.scaleDown,
                                                                scale: 7,
                                                              )
                                                            : DecorationImage(
                                                                image: MemoryImage(
                                                                    _Rubros![index]
                                                                        .IconoAPP!),
                                                                fit: BoxFit.scaleDown,
                                                                scale: 10,
                                                              )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          _Rubros![index].Descripcion!.length > 12 ?
                                          '${_Rubros![index].Descripcion!.substring(0,12)}...': _Rubros![index].Descripcion!,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recomendado',
                              style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      )),

                          GestureDetector(
                            child:Text('Ver Más',
                            style: GoogleFonts.poppins(
                              color: Color(0xfff68712),
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                            )),
                            onTap: (){

                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: fullHeight * 0.5,
                      child: GridView.builder(

                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2
                          ),
                          itemCount: 4,
                          itemBuilder: (BuildContext context , int index)
                          {
                            var producto = _Productos![index];
                            return Padding(
                              padding:
                              const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  IrAProducto(
                                    producto.Descripcion!,
                                    producto.Precio!,
                                    producto.DescripcionAmpliada!,
                                    producto.Foto!,
                                    producto.Id!,
                                  );
                                },
                                child: productoView(
                                  colorproductoview: _Productos!.isEmpty ? Colors.transparent : Colors.white,
                                  formatCurrency:
                                  formatCurrency,
                                  producto: producto,
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ));
  }

  void IrAProducto(String Descripcion, double Precio, String Desc,
      Uint8List Foto, int ID) async {
    storage.write(key: "ProdNombre", value: Descripcion);
    storage.write(key: "ProdPrecio", value: Precio.toString());
    storage.write(key: "ProdDetail", value: Desc);
    storage.write(key: "ProdID", value: ID.toString());
    String s = new String.fromCharCodes(Foto);
    storage.write(key: "ProdFoto", value: s);
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: VerProdutos(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  void IrARubro(int? Id) async {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: ProveedoresPage(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    ).then((value) {
      storage.delete(key: 'RubroId');
    });
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(8, 10) +
      "/" +
      Fecha.substring(5, 7) +
      "/" +
      Fecha.substring(0, 4);
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
