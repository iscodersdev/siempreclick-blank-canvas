import 'dart:convert';
import 'package:smart/API/Config/config.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

Future IngresoDinero(BuildContext context, String UAT, double Monto,
    int MetodoPagoId, int TipoMedioPago) async {
  final url = Uri.http(Config.ApiURL, '/api/mEnvios/IngresoDinero');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
        'Monto': Monto,
        'MetodoPagoId': MetodoPagoId,
        'TipoMedioPago': TipoMedioPago,
      }));
  var jsonData = jsonDecode(response.body);
  if (jsonData['Status'] == 200) {
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  } else {
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  }
}
