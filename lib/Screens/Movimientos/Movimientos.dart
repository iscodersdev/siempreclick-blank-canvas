import 'dart:convert';

import 'package:smart/Models/Movimientos%20Model/MovimientosModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart/API/Movimientos/MovimientosAPI.dart';

class MovimientosPage extends StatefulWidget {
  const MovimientosPage({Key? key}) : super(key: key);

  @override
  _MovimientosPageState createState() => _MovimientosPageState();
}

final storage = FlutterSecureStorage();
final formatCurrency = new NumberFormat.simpleCurrency();

class _MovimientosPageState extends State<MovimientosPage> {
  List<MovimientosModel> _Movimientos = [];
  bool _loading = false;
  String UAT = 'abcdefg';
  dynamic Usuario = null;
  GetMovimientos() async {
    String? User = await storage.read(key: 'USER');
    Usuario = jsonDecode(User!);
    Movimientos movimientosClases = Movimientos();
    _Movimientos =
        (await movimientosClases.getMovimientos(context, Usuario['UAT']));
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetMovimientos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF39a67b),
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'Movimientos',
            style: GoogleFonts.raleway(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _loading = true;
              });
              GetMovimientos();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 25,
            ),
          )
        ],
      ),
      body: _loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Container(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 20),
                        child: Text('Ultimos Movimientos',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.raleway(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Divider(
                        thickness: 1.2,
                      ),
                    ),
                    _Movimientos == null
                        ? Container(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Icon(
                                    Icons.compare_arrows,
                                    color: Colors.black54,
                                    size: 40,
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Text(
                                  'No se encontraron Movimientos Recientes',
                                  style: GoogleFonts.raleway(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: _Movimientos.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, left: 15, right: 15),
                                    child: Card(
                                      elevation: 3,
                                      child: ListTile(
                                        leading: Image(
                                          height: 50,
                                          width: 50,
                                          image: AssetImage(
                                              'assets/Images/MovimientosIcon.png'),
                                          color: Colors.black54,
                                        ),
                                        title: Text(
                                          _Movimientos[index].TipoMovimiento!,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                              fontSize: 17),
                                        ),
                                        subtitle: Text(
                                          convertirFecha(
                                              _Movimientos[index].Fecha!),
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                              fontSize: 14),
                                        ),
                                        trailing: Text(
                                          '${formatCurrency.format(_Movimientos[index].Monto)}',
                                          style: GoogleFonts.roboto(
                                              color: Color(0xff3375bb),
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  ],
                ),
              ),
            ),
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
