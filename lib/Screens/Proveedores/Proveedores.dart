import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:smart/API/Proveedores/ProveedoresAPI.dart';
import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
import 'package:smart/Screens/Proveedores/VerProducto.dart';

class ProveedoresPage extends StatefulWidget {
  @override
  _ProveedoresPageState createState() => _ProveedoresPageState();
}

final storage = FlutterSecureStorage();

class _ProveedoresPageState extends State<ProveedoresPage> {
  List<ProveedoresModel> _Proveedores = [];
  bool loading = true;
  String UAT = 'abcdefg';
  dynamic Usuario = null;
  String Nombre = 'Nombre';
  String Razon = 'Razon';
  String Cuit = 'Cuit';
  String Id = '0';
  String Foto = '';
  final formatCurrency = NumberFormat.simpleCurrency();
  final TextEditingController _filter = TextEditingController();
  Icon _searchIcon = Icon(Icons.search);
  String _searchText = "";
  int _paginaInicio = 0;
  int _paginaFinal = 8;
  ScrollController _scrollController = ScrollController();
  bool _isloading = false;
  bool _listavacia = false;
  Proveedores proveedoresClases = Proveedores();
  Widget _appBarTitle = Text(
    'Rubros',
    style: GoogleFonts.raleway(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
  );
  List<RubrosModel> _Rubros = []; // Lista de rubros
  int selectedRubroId = 0;

  List<ProductosModel> _Productos = [];
  getProductos() async {
    setState(() {
        _isloading = true;
      Id = '0';
    });

    List<ProductosModel> prods = (await proveedoresClases.getProductos(
        context, Usuario['UAT'], Id, _paginaInicio, _paginaFinal));
    if(mounted){
      setState(() {
        if(prods.isNotEmpty)
        {
          _Productos.addAll(prods);
          loading = false;
          _isloading = false;
        }else{
          _listavacia = true;
          _isloading = false;
        }

      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  getProductosPorRubro(String? id) async {
    //String? idRurbo = await storage.read(key: 'RubroId');
    setState(() {
      loading = true;
    });
    selectedRubroId = int.parse(id!);
    // if(idRurbo != null){
    //   setState(() {
    //     id = idRurbo;
    //     selectedRubroId = int.parse(idRurbo);
    //   });
    //}
    _productosFiltrados = (await proveedoresClases.getProductosPorRubro(
      context,
      Usuario['UAT'],
      int.parse(id!),
    ));
    setState(() {
      loading = false;
    });
  }

  final TextEditingController _searchController = TextEditingController();

  List<ProductosModel> _productosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isloading) {
        cargamasproductos();
      }
    });
    cargarRubros(); // Cargar los rubros al inicializar la página
  }

  void cargarRubros() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);

    String? idRurbo = await storage.read(key: 'RubroId');
    print("RUBROID STORAGE ${idRurbo}");
    if (idRurbo != null) {
      setState(() {
        selectedRubroId = int.parse(idRurbo);
      });
      _productosFiltrados = (await proveedoresClases.getProductosPorRubro(
        context,
        Usuario['UAT'],
        int.parse(idRurbo!),
      ));
    }
    _Rubros = await proveedoresClases.getRubros(context, Usuario['UAT']);
    getProductos(); // Notificar a Flutter que los datos han cambiado
  }

  void limpiarStorage() async {
    await storage.delete(key: "ProdNombre");
    await storage.delete(key: "ProdPrecio");
    await storage.delete(key: "ProdDetail");
    await storage.delete(key: "ProdID");
    await storage.delete(key: "ProdFoto");
    await storage.delete(key: "ProdFoto1");
    await storage.delete(key: "ProdFoto2");
    await storage.delete(key: "ProdFoto3");
    await storage.delete(key: "ProdFoto4");
    await storage.delete(key: "ProdFoto5");
  }

  void IrAProducto(
    String? Descripcion,
    double? Precio,
    String? Desc,
    Uint8List? Foto,
    Uint8List? Foto1,
    Uint8List? Foto2,
    Uint8List? Foto3,
    Uint8List? Foto4,
    Uint8List? Foto5,
    int? ID,
  ) async {
    // Limpia el storage antes de escribir los nuevos valores
    storage.write(key: "ProdNombre", value: Descripcion!);
    storage.write(key: "ProdPrecio", value: Precio.toString());
    storage.write(key: "ProdDetail", value: Desc);
    storage.write(key: "ProdID", value: ID.toString());

    if (Foto != null) {
      String? s = base64.encode(Foto);
      storage.write(key: "ProdFoto", value: s);
    }
    if (Foto1 != null) {
      String? s1 = base64.encode(Foto1);
      storage.write(key: "ProdFoto1", value: s1);
    }
    if (Foto2 != null) {
      String? s2 = base64.encode(Foto2);
      storage.write(key: "ProdFoto2", value: s2);
    }
    if (Foto3 != null) {
      String? s3 = base64.encode(Foto3);
      storage.write(key: "ProdFoto3", value: s3);
    }
    if (Foto4 != null) {
      String? s4 = base64.encode(Foto4);
      storage.write(key: "ProdFoto4", value: s4);
    }
    if (Foto5 != null) {
      String? s5 = base64.encode(Foto5);
      storage.write(key: "ProdFoto5", value: s5);
    }

    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: VerProdutos(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    ).then((value) {
      limpiarStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: loading
            ? Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.white),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircularProgressIndicator(),
                        ),
                        Text(
                          'Aguarde porfavor...\n(Puede demorar)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ]),
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 45, left: 20, right: 20, bottom: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _productosFiltrados = _Productos.where(
                                        (producto) => producto.Descripcion!
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Buscar producto',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _Rubros.length,
                      itemBuilder: (context, index) {
                        final rubro = _Rubros[index];
                        return GestureDetector(
                          onTap: () {
                            if (rubro.Id == selectedRubroId) {
                              setState(() {
                                selectedRubroId = 0;
                                storage.delete(key: 'RubroId');
                              });
                            } else {
                              setState(() {
                                selectedRubroId = rubro.Id!;
                                Id = rubro.Id.toString();
                              });
                              getProductosPorRubro(Id);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: selectedRubroId == rubro.Id
                                  ? Colors.blue[800]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                rubro.Nombre!,
                                style: TextStyle(
                                  color: selectedRubroId == rubro.Id
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  _Productos.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'No se encontraron productos.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : selectedRubroId != 0 && _productosFiltrados.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, size: 50, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  'No se encontraron productos para este rubro.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : Expanded(
                              child: Stack(
                                children: [
                                  CustomScrollView(
                                    controller: _scrollController,
                                    slivers: [
                                      SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            if (index ==
                                                (_productosFiltrados.length +
                                                    (_Productos.length ))) {
                                              return SizedBox
                                                  .shrink(); // Placeholder for the loader
                                            } else {
                                              var producto;
                                              if (selectedRubroId != 0) {
                                                producto =
                                                    _productosFiltrados[index];
                                              } else {
                                                producto = _Productos[index];
                                              }

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    IrAProducto(
                                                      producto.Descripcion,
                                                      producto.Precio!,
                                                      producto
                                                          .DescripcionAmpliada,
                                                      producto.Foto,
                                                      producto.Foto1,
                                                      producto.Foto2,
                                                      producto.Foto3,
                                                      producto.Foto4,
                                                      producto.Foto5,
                                                      producto.Id!,
                                                    );
                                                  },
                                                  child: productoView(
                                                    colorproductoview: _Productos.isEmpty ? Colors.transparent : Colors.white,
                                                    formatCurrency:
                                                        formatCurrency,
                                                    producto: producto,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          childCount: selectedRubroId != 0
                                              ? _productosFiltrados.length
                                              : _Productos.length ,
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                  _listavacia == true &&  _isloading == false
                      ? Container(
                            height: 10,
                            decoration: BoxDecoration(
                                color: Colors.transparent),
                  )
                  :  _isloading == true
                      ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Lottie.asset(
                      'assets/gifs/lottie_load.json', // Replace with the actual asset path
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ) : Container()

                ],
              ),
      ),
    );
  }

  void cargamasproductos() {
    setState(() {
      _paginaInicio += 8;
      _paginaFinal += 8;
    });
    getProductos();
  }
}

class productoView extends StatelessWidget {
  const productoView({
    key,
    required this.formatCurrency,
    required this.producto,
    required this.colorproductoview
  });

  final NumberFormat formatCurrency;
  final producto;
  final colorproductoview;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color:colorproductoview,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 91,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              image: producto.Foto != null
                  ? DecorationImage(
                      image: MemoryImage(producto.Foto!),
                      fit: BoxFit.contain,
                    )
                  : const DecorationImage(
                      image: AssetImage('assets/Images/no-foto.png'),
                      scale: 7,
                      fit: BoxFit.scaleDown,
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  producto.Descripcion!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style:
                      GoogleFonts.poppins(color: Colors.black54, fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Ver Más',
                        style: GoogleFonts.raleway(
                          color: const Color(0xfff68712),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${formatCurrency.format(producto.Precio!)}',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: const Color(0xfff68712),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
