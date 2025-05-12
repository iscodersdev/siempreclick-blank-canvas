import 'dart:convert';
import 'dart:typed_data';
import 'package:smart/API/Proveedores/ProveedoresAPI.dart';
import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
import 'package:smart/Screens/MisCompras/VerCompra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

final storage = FlutterSecureStorage();

class MisComprasPage extends StatefulWidget {
  const MisComprasPage({Key? key}) : super(key: key);

  @override
  _MisComprasPageState createState() => _MisComprasPageState();
}

class _MisComprasPageState extends State<MisComprasPage> {
  bool _loading = true;
  List<ProductosCompradosModel> _ProductosComprados = [];
  dynamic Usuario = null;
  getProductosComprados() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Proveedores proveedoresClases = Proveedores();
    _ProductosComprados =
        await proveedoresClases.getProductosComprados(context, Usuario['UAT']);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductosComprados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF39a67b),
        title: Text(
          'Mis Compras',
          style: GoogleFonts.raleway(
              color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[50],
              child: _ProductosComprados.length == 0
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black54,
                              size: 40,
                            ),
                          ),
                          Text(
                            'No se encontrarón compras',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                                fontSize: 17),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _ProductosComprados.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 15, right: 15),
                          child: GestureDetector(
                            onTap: () {
                              IrAProducto(
                                  _ProductosComprados[index].Descripcion!,
                                  _ProductosComprados[index].Precio!,
                                  _ProductosComprados[index].DescripcionAmpliada!,
                                  _ProductosComprados[index].Foto!,
                                  _ProductosComprados[index].FechaCompra!,
                                  _ProductosComprados[index].EstadoDescripcion!,
                                  _ProductosComprados[index].Id!);
                            },
                            child: SizedBox(
                              height: 100,
                              child: Card(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                                elevation: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Center(
                                    child: ListTile(
                                      leading: Image(
                                          height: 100,
                                          width: 100,
                                          image: MemoryImage(
                                              _ProductosComprados[index]
                                                  .Foto!)),
                                      title: Text(
                                        _ProductosComprados[index].Descripcion!,
                                        maxLines: 2,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        'Comprado el ' + convertirFecha(_ProductosComprados[index].FechaCompra!),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                            fontSize: 12),
                                      ),
                                      trailing: Text(
                                        'Ver\n Detalle',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xfff68712),
                                            fontSize: 11),
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
            )),
    );
  }

  void IrAProducto(String Descripcion, double Precio, String Desc,
      Uint8List Foto, String FechaCompra, String Estado, int Id) async {
    storage.write(key: "ProdNombre", value: Descripcion);
    storage.write(key: "ProdPrecio", value: Precio.toString());
    storage.write(key: "ProdDetail", value: Desc);
    String s = new String.fromCharCodes(Foto);
    storage.write(key: "ProdFoto", value: s);
    storage.write(key: 'ProdID', value: Id.toString());
    storage.write(key: "ProdFechaCompra", value: FechaCompra);
    storage.write(key: "ProdEstado", value: Estado);
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: VerCompra(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
}

String convertirFecha(String Fecha) {
  return Fecha.substring(8, 10) +
      "/" +
      Fecha.substring(5, 7) +
      "/" +
      Fecha.substring(0, 4);
}
