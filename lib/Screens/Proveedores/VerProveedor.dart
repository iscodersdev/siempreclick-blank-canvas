import 'dart:convert';
import 'dart:typed_data';
import 'package:smart/Screens/Proveedores/VerProducto.dart';
import 'package:smart/Widgets/MyImagen.dart';
import 'package:smart/API/Proveedores/ProveedoresAPI.dart';
import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class VerProveedorPage extends StatefulWidget {
  @override
  _VerProveedorPageState createState() => _VerProveedorPageState();
}

final storage = FlutterSecureStorage();

class _VerProveedorPageState extends State<VerProveedorPage> {
  String Nombre = 'Nombre';
  String Razon = 'Razon';
  String Cuit = 'Cuit';
  String Id = '0';
  String Foto = '';
  bool _loading = true;
  dynamic Usuario = null;

  List<ProductosModel> _Productos = [];
  getProductos() async {
    Nombre = (await storage.read(key: 'ProvNombre'))!;
    Razon = (await storage.read(key: 'ProvRazon'))!;
    Cuit = (await storage.read(key: 'ProvCuit'))!;
    Id = (await storage.read(key: 'ProvId'))!;
    Foto = (await storage.read(key: 'ProvFoto'))!;
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Proveedores proveedoresClases = Proveedores();
    // _Productos =
    //     (await proveedoresClases.getProductos(context, Usuario['UAT'], Id));
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color(0xff3375bb),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              MdiIcons.cart,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Color(0xff3375bb),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: MyImage(
                                    imageBytes:
                                        Uint8List.fromList(Foto.codeUnits),
                                    boxFit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Text(
                                Nombre,
                                style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Razon,
                                  style: GoogleFonts.raleway(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              //Text(Razon, style: GoogleFonts.raleway(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w400),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Productos Disponibles:',
                        style: GoogleFonts.raleway(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        //physics:BouncingScrollPhysics(),
                        padding: EdgeInsets.all(10.0),
                        children: _Productos.map(
                          (data) => GestureDetector(
                            onTap: () {
                              IrAProducto(data.Descripcion!, data.Precio!,
                                  data.DescripcionAmpliada!, data.Foto!);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 130,
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15))),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)),
                                        child: MyImage(
                                          imageBytes: data.Foto,
                                          boxFit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Color(0xff3375bb),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight:
                                                  Radius.circular(15))),
                                      child: Align(
                                        child: Text(
                                          data.Descripcion!,
                                          style: GoogleFonts.raleway(
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void IrAProducto(
      String Descripcion, double Precio, String Desc, Uint8List Foto) async {
    storage.write(key: "ProdNombre", value: Descripcion);
    storage.write(key: "ProdPrecio", value: Precio.toString());
    storage.write(key: "ProdDetail", value: Desc);
    String s = new String.fromCharCodes(Foto);
    storage.write(key: "ProdFoto", value: s);
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: VerProdutos(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
}
