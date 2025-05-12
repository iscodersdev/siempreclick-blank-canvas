// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:smart/API/Billetera/BilleteraApi.dart';
// import 'package:smart/API/Movimientos/MovimientosAPI.dart';
// import 'package:smart/API/Proveedores/ProveedoresAPI.dart';
// import 'package:smart/Models/Movimientos%20Model/MovimientosModel.dart';
// import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
// import 'package:smart/Screens/EnviarDinero/EnviarDinero.dart';
// import 'package:smart/Screens/Proveedores/Proveedores.dart';
// import 'package:smart/Screens/Receta/Receta.dart';
// import 'package:smart/Screens/RecibirDinero/RecibirDinero.dart';
// import 'package:smart/Screens/Servicios/ServiciosPage.dart';
// import 'package:smart/Screens/Tarjetas/Tarjetas.dart';
// import 'package:smart/Screens/mas/Mas.dart';
// import 'package:smart/route/bloc.navigation_bloc/navigation_bloc.dart';
// import 'package:smart/services/alert.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:expandable/expandable.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:smart/Widgets/MyImagen.dart';
//
// import '../../API/noticia.dart';
// import '../../Models/noticia/Noticia.dart';
// import '../BottomBar/BottomBar.dart';
// import '../Proveedores/VerProducto.dart';
//
// final storage = FlutterSecureStorage();
// final formatCurrency = new NumberFormat.currency(locale: 'id', symbol: "\$");
//
// class MiControlador extends GetxController {
//   final _navController = 0.obs;
// }
//
// class HomeScreenPage extends StatefulWidget implements NavigationStates {
//   @override
//   _HomeScreenPageState createState() => _HomeScreenPageState();
// }
//
// class _HomeScreenPageState extends State<HomeScreenPage> {
//   bool _loading = true;
//   String UAT = 'abcdefg';
//   String Saldo = '0';
//   dynamic Usuario = null;
//   List<MovimientosModel>? _Movimientos;
//   List<ProveedoresModel>? _Proveedores;
//   List<RubrosModel>? _Rubros;
//   bool Billetera = true;
//   String Mensaje = '';
//   List<ProductosModel>? _Productos;
//   String Nombre = '.';
//   List<NoticiaModel> _noticias = [];
//   int _currentIndex = 0;
//
//   GetSaldo() async {
//     String? User = await storage.read(key: 'USER');
//     Usuario = jsonDecode(User!);
//     await GetSaldoBilletera(context, Usuario['UAT']);
//     Nombre = Usuario['Nombres'];
//     List<String> wordList = Nombre.split(" ");
//     if (wordList.isNotEmpty) {
//       Nombre = wordList[0];
//     }
//     Saldo = (await storage.read(key: 'Saldo'))!;
//     String? billetera = await storage.read(key: 'Billetera');
//     if (billetera == 'false') {
//       Billetera = false;
//     }
//     GetMovimientos();
//   }
//
//   GetMovimientos() async {
//     String? User = await storage.read(key: 'USER');
//     Usuario = jsonDecode(User!);
//     Movimientos movimientosClases = Movimientos();
//     _Movimientos =
//         (await movimientosClases.getMovimientos(context, Usuario['UAT']));
//     GetProveedores();
//   }
//
//   GetProveedores() async {
//     String? User = await storage.read(key: 'USER');
//     Usuario = jsonDecode(User!);
//     Proveedores proveedoresClases = Proveedores();
//     _Proveedores =
//         (await proveedoresClases.getProveedores(context, Usuario['UAT']));
//     _Rubros = await proveedoresClases.getRubros(context, Usuario['UAT']);
//     print("ESTA ES LA CANTIDAD DE RUBROS ${_Rubros!.length}");
//     GetProductos();
//   }
//
//   Future<void> getNovedades() async {
//     String? jason = await storage.read(key: "USER");
//     Usuario = jsonDecode(jason!);
//     NoticiasServices noticiasClass = NoticiasServices();
//     //AlertPop.alert(context, body: Text(noticiasClass.novedades.length.toString()));
//     _noticias = await noticiasClass.getNovedades(context, Usuario["UAT"], 0);
//     setState(() {
//       // CantidadCargada = _noticiasService.novedades.length;
//       _loading = false;
//     });
//   }
//
//   GetProductos() async {
//     String? User = await storage.read(key: 'USER');
//     Usuario = jsonDecode(User!);
//     Proveedores proveedoresClases = Proveedores();
//     _Productos = await proveedoresClases.getProductosHome(
//         context, Usuario['UAT'], _Proveedores![0].Id.toString());
//     setState(() {
//       // CantidadCargada = _noticiasService.novedades.length;
//       _loading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     GetSaldo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controlador = Get.put(MiControlador());
//     var fullWidth = MediaQuery.of(context).size.width;
//     var fullHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//         body: _loading
//             ? Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(color: Colors.white),
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Lottie.asset(
//                           'assets/gifs/lottie_load.json', // Replace with the actual asset path
//                           width: 30,
//                           height: 30,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       Text('Aguarde porfavor...',
//                           style: GoogleFonts.poppins(
//                               color: Colors.black54,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500))
//                     ]))
//             : SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 20,
//                       color: Color(0XFF39a67b),
//                     ),
//                     // OFERTA NUMERO 1
//                     Container(
//                       height: fullHeight / 3.5,
//                       width: fullWidth,
//                       padding:
//                           const EdgeInsets.only(left: 20, top: 20, right: 20),
//                       margin: const EdgeInsets.only(bottom: 20),
//                       decoration: const BoxDecoration(
//                           color: Color(0XFF39a67b),
//                           borderRadius: BorderRadius.only(
//                               bottomRight: Radius.circular(30),
//                               bottomLeft: Radius.circular(30))),
//                       clipBehavior: Clip.hardEdge,
//                       child: Stack(
//                         children: [
//                           Positioned.fill(
//                             child: FractionalTranslation(
//                               translation: const Offset(0.0,
//                                   0.3), // Ajusta este valor según tu necesidad
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: SizedBox(
//                                   width: fullWidth,
//                                   child: MyImage(
//                                     imageBytes: _Productos![3].Foto!,
//                                     boxFit: BoxFit.scaleDown,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           //titulo
//                           Positioned(
//                             left: 15,
//                             top: 15,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Conoce nuestros',
//                                   style: GoogleFonts.raleway(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 20),
//                                 ),
//                                 Text(
//                                   'Precios únicos!',
//                                   style: GoogleFonts.raleway(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20),
//                                 ),
//                                 Text(
//                                   'Electro',
//                                   style: GoogleFonts.raleway(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                             top: -10,
//                             right: -10,
//                             child: Container(
//                               padding: const EdgeInsets.all(20),
//                               child: Image.asset(
//                                 'assets/Images/logo1w.png',
//                                 scale: 4,
//                               ),
//                             ),
//                           ),
//                           //precio
//                           Positioned(
//                             bottom: 15,
//                             right: 15,
//                             child: Container(
//                               padding: const EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(100)),
//                               child: Icon(
//                                 Icons.arrow_circle_right_outlined,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           //favs
//                           Positioned(
//                             bottom: 15,
//                             left: 15,
//                             child: Container(
//                               padding: const EdgeInsets.all(15),
//                               decoration: BoxDecoration(
//                                   color: const Color(0xfff68712),
//                                   borderRadius: BorderRadius.circular(100)),
//                               child: Text(
//                                 '${formatCurrency.format(_Productos![3].Precio!)}',
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     ////////////////////////////////////////////////END UPPER PART///////////////////////////////////////////////
//
//                     GestureDetector(
//                       child: Container(
//                         margin: const EdgeInsets.only(
//                             left: 20, right: 20, bottom: 10),
//                         constraints:
//                             const BoxConstraints(minHeight: 50, maxHeight: 60),
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         width: fullWidth,
//                         decoration: BoxDecoration(
//                           color: const Color(0xfff68712),
//                           borderRadius: BorderRadius.circular(15),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 5,
//                               blurRadius: 7,
//                               offset: const Offset(
//                                   0, 3), // changes position of shadow
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Maneja tu Billetera Virtual Aquí',
//                               style: GoogleFonts.raleway(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16),
//                             ),
//                             IconButton(
//                                 icon: const Icon(
//                                   Icons.arrow_circle_right_outlined,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: () {
//                                   controlador._navController.value = 2;
//                                   PersistentNavBarNavigator.pushNewScreen(context, screen: WalletPage());
//                                 }
//
//                             // Obx(() => IconButton(
//                             //   icon: const Icon(
//                             //     Icons.arrow_circle_right_outlined,
//                             //     color: Colors.white,
//                             //   ),
//                             //   onPressed: () => controlador._navController.value = 2),
//                             // )
//                             )],
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(
//                       height: fullHeight *
//                           _Rubros!.length *
//                           0.128, // Para que podamos ver todos los rubros.
//                       child: _Rubros!.length == 0 || _Rubros == null
//                           ? Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   const Padding(
//                                     padding:
//                                         EdgeInsets.only(top: 40.0, bottom: 20),
//                                     child: Icon(
//                                       Icons.shopping_cart_outlined,
//                                       size: 30,
//                                       color: Color(0xfff68712),
//                                     ),
//                                   ),
//                                   Text(
//                                     'No se encontraron \nProductos Disponibles',
//                                     textAlign: TextAlign.center,
//                                     style: GoogleFonts.roboto(
//                                         color: Colors.black54,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w400),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : GridView.builder(
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 crossAxisSpacing: 20,
//                                 mainAxisSpacing: 20,
//                               ),
//                               padding: const EdgeInsets.only(
//                                   left: 18, right: 18, top: 18),
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount:
//                                   16, // Cambia esto al número correcto de productos
//                               itemBuilder: (context, index) {
//                                 return GestureDetector(
//                                   onTap: () {
//                                     storage.write(
//                                         key: "RubroId",
//                                         value: _Rubros![index].Id!.toString());
//                                     IrARubro(_Rubros![index].Id!);
//                                   },
//                                   child: Container(
//                                     //height: 100,
//                                     width: 200,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.2),
//                                           spreadRadius: 5,
//                                           blurRadius: 7,
//                                           offset: const Offset(0,
//                                               3), // changes position of shadow
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Stack(
//                                           children: [
//                                             Container(
//                                               height: 100,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       const BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(10),
//                                                     topRight:
//                                                         Radius.circular(10),
//                                                   ),
//                                                   image: _Rubros![index]
//                                                               .IconoAPP ==
//                                                           null
//                                                       ? const DecorationImage(
//                                                           image: AssetImage(
//                                                               'assets/Images/no-foto.png'),
//                                                           fit: BoxFit.scaleDown,
//                                                           scale: 7,
//                                                         )
//                                                       : DecorationImage(
//                                                           image: MemoryImage(
//                                                               _Rubros![index]
//                                                                   .IconoAPP!),
//                                                           fit: BoxFit.scaleDown,
//                                                           scale: 9,
//                                                         )),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: [
//                                               //Container(height: 10),
//                                               Text(
//                                                 _Rubros![index].Descripcion!,
//                                                 textAlign: TextAlign.center,
//                                                 maxLines: 1,
//                                                 style: GoogleFonts.poppins(
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.w700,
//                                                     fontSize: 15),
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: [
//                                                     Text(
//                                                       'Ver Más',
//                                                       style:
//                                                           GoogleFonts.raleway(
//                                                         color: const Color(
//                                                             0xfff68712),
//                                                         fontSize: 12,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),
//                   ],
//                 ),
//               ));
//   }
//
//   void IrAProducto(String Descripcion, double Precio, String Desc,
//       Uint8List Foto, int ID) async {
//     storage.write(key: "ProdNombre", value: Descripcion);
//     storage.write(key: "ProdPrecio", value: Precio.toString());
//     storage.write(key: "ProdDetail", value: Desc);
//     storage.write(key: "ProdID", value: ID.toString());
//     String s = new String.fromCharCodes(Foto);
//     storage.write(key: "ProdFoto", value: s);
//     PersistentNavBarNavigator.pushNewScreen(
//       context,
//       screen: VerProdutos(),
//       withNavBar: false, // OPTIONAL VALUE. True by default.
//       pageTransitionAnimation: PageTransitionAnimation.cupertino,
//     );
//   }
//
//   void IrARubro(int? Id) async {
//     PersistentNavBarNavigator.pushNewScreen(
//       context,
//       screen: ProveedoresPage(),
//       withNavBar: false, // OPTIONAL VALUE. True by default.
//       pageTransitionAnimation: PageTransitionAnimation.cupertino,
//     ).then((value) {
//       storage.delete(key: 'RubroId');
//     });
//   }
// }
//
// String convertirFecha(String Fecha) {
//   return Fecha.substring(8, 10) +
//       "/" +
//       Fecha.substring(5, 7) +
//       "/" +
//       Fecha.substring(0, 4);
// }
//
// _mostrarSnackBar(BuildContext context, String _mensaje, int _status) {
//   final snackBarER = SnackBar(
//     elevation: 5.0,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
//     backgroundColor: _status == 200 ? Colors.green[400] : Colors.red,
//     behavior: SnackBarBehavior.floating,
//     content: Row(
//       children: [
//         Icon(_status == 200 ? Icons.check_circle_outline : Icons.error_outline,
//             color: Colors.white),
//         const SizedBox(
//           width: 5,
//         ),
//         Flexible(
//           child: Text(_mensaje,
//               style: GoogleFonts.raleway(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 13,
//                   color: Colors.white)),
//         ),
//       ],
//     ),
//     action: SnackBarAction(
//       label: 'Cerrar',
//       textColor: Colors.white,
//       onPressed: () {
//         // Solo cierra el popup. no requiere acción
//       },
//     ),
//   );
//   ScaffoldMessenger.of(context).showSnackBar(snackBarER);
// }
