import 'dart:convert';
import 'package:smart/API/Config/config.dart';
import 'package:smart/Models/Movimientos%20Model/MovimientosModel.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

class Movimientos {
  Future<List<MovimientosModel>> getMovimientos(
      BuildContext context, String UAT) async {
    List<MovimientosModel> movimientos = [];
    final url = Uri.http(Config.ApiURL, '/api/mBilletera/MovimientosBilletera');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    if (jsonData['Status'] == 200) {
      jsonData["Movimientos"].forEach((element) {
        if (element["Monto"] != null) {
          MovimientosModel movimientosModel = MovimientosModel(
            Monto: element['Monto'],
            TipoMovimiento: element['TipoMovimiento'],
            Fecha: element['Fecha'],
          );
          movimientos.add(movimientosModel);
        }
      });
    }
    return movimientos;
  }
}
