import 'dart:convert';

import 'package:smart/API/Config/config.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

Future<dynamic> GetDetalleServicio(
    BuildContext context, String UAT, String CodigoBarras) async {
  final url = Uri.http(Config.ApiURL, '/api/mPagos/DetallePagoBarras');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
        'CodigoBarras': CodigoBarras,
      }));
  var jsonData = jsonDecode(response.body);
  //AlertPop.alert(context, body: Text(response.body));
  if (jsonData['Status'] == 200) {
    await storage.write(key: "ServicioDetalle", value: response.body);
  } else {
    await storage.write(key: "ServicioDetalle", value: response.body);
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  }
}

Future EnvioServicio(BuildContext context, String UAT, String CodigoBarras,
    int MetodoPagoId, int TipoMedioPago) async {
  //AlertPop.alert(context, body: Text(Monto.toString()));
  final url = Uri.http(Config.ApiURL, '/api/mPagos/ConfirmaPagoBarras');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
        'CodigoBarras': CodigoBarras,
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
