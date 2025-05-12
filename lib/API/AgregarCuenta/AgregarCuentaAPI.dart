import 'dart:convert';
import 'package:smart/API/Config/config.dart';
import 'package:smart/Models/CuentasModel/CuentasModel.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

Future AltaCuenta(BuildContext context, String UAT, String Numero,
    String Titular, String CBU, String Alias, bool Terceros) async {
  final url = Uri.http(Config.ApiURL, '/api/mCuentas/Alta');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
        'Numero': Numero,
        'Titular': Titular,
        'CBU': CBU,
        'Terceros': Terceros,
      }));
  var jsonData = jsonDecode(response.body);
  if (jsonData['Status'] == 200) {
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  } else {
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  }
}

class Cuentas {
  Future<List<CuentasModel>> getCuentas(
      BuildContext context, String UAT) async {
    List<CuentasModel> cuentas = [];
    final url = Uri.http(Config.ApiURL, '/api/mBilletera/CuentasBilletera');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["Cuentas"].forEach((element) {
        if (element["CBU"] != null) {
          CuentasModel cuentasModel = CuentasModel(
            Descripcion: element['Descripcion'],
            CBU: element['CBU'],
          );
          cuentas.add(cuentasModel);
        }
      });
    }
    return cuentas;
  }
}
