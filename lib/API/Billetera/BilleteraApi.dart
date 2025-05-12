import 'dart:convert';
import 'dart:io';
import 'package:smart/API/Config/config.dart';
import 'package:smart/Models/BilleterasModel/BilleteraModel.dart';
import 'package:smart/Models/Movimientos%20Model/MovimientosModel.dart';
import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

Future<dynamic> GetSaldoBilletera(BuildContext context, String UAT) async {
  print(UAT);
  final url = Uri.http(Config.ApiURL, '/api/mBilletera/SaldoBilletera');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
      }));
  var jsonData = jsonDecode(response.body);
  String Billetera = 'true';
  if (jsonData['Status'] == 200) {
    if (jsonData['Saldo'] == null) {
      jsonData['Saldo'] = 0;
    }
  } else {
    jsonData['Saldo'] = 0;
    Billetera = 'false';
  }
  await storage.write(key: 'Billetera', value: Billetera);
  await storage.write(key: "Saldo", value: jsonData['Saldo'].toString());
  //AlertPop.alert(context, body: Text(response.body));
}
Future<List<SubProductoModel>> GetSubProdcutos(
    BuildContext context, String UAT, String ProductoId) async {
  List<SubProductoModel> subProductos = [];
  final url =
  Uri.http(Config.ApiURL, '/api/MProductos/TraeSubProductos');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
        'ProductoId': ProductoId,
      }));
  var jsonData = jsonDecode(response.body);
  if (jsonData['Status'] == 200) {
    jsonData["SubProductos"].forEach((element) {
      if (element["Id"] != null) {
        SubProductoModel subProductoModel = SubProductoModel(
          Id: element['Id'],
          ProductoId: element['ProductoId'],
          NombreSubProducto: element['NombreSubProducto'],
        );
        subProductos.add(subProductoModel);
      }
    });
  }
  return subProductos;
}
Future<dynamic> GetCVUScanned(
    BuildContext context, String UAT, String CVU) async {
  final url = Uri.http(Config.ApiURL, '/api/mClientes/ClienteBilletera');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
        'CVU': CVU,
      }));
  var jsonData = jsonDecode(response.body);
  //AlertPop.alert(context, body: Text(response.body));
  if (jsonData['Status'] == 200) {
    await storage.write(key: "CVU", value: response.body);
  } else {
    await storage.write(key: "CVU", value: response.body);
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  }
  //AlertPop.alert(context, body: Text(response.body));
}

Future<dynamic> GetCVU(BuildContext context, String UAT) async {
  final url = Uri.http(Config.ApiURL, '/api/mBilletera/CVUBilletera');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
      }));

  var jsonData = jsonDecode(response.body);
  if (jsonData['Status'] == 200) {
    await storage.write(key: "CVU", value: response.body);
  } else {
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  }
}

class Billetera {
  Future<List<BilleteraModel>> getBilleteras(
      BuildContext context, String UAT) async {
    List<BilleteraModel> billetera = [];
    final url = Uri.http(Config.ApiURL, '/api/mBilletera/BilleterasAsociadas');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["Billeteras"].forEach((element) {
        if (element["CVU"] != null) {
          BilleteraModel tarjetasModel = BilleteraModel(
            Titular: element['Titular'],
            CVU: element['CVU'],
          );
          billetera.add(tarjetasModel);
        }
      });
    }
    return billetera;
  }

  Future<List<BilleteraTercerosModel>> getBilleterasTerceros(
      BuildContext context, String UAT) async {
    List<BilleteraTercerosModel> billeteraTerceros = [];
    final url =
        Uri.http(Config.ApiURL, '/api/mBilletera/CuentasTercerosBilletera');
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
          BilleteraTercerosModel tarjetastercerosModel = BilleteraTercerosModel(
            Descripcion: element['Descripcion'],
            CBU: element['CBU'],
          );
          billeteraTerceros.add(tarjetastercerosModel);
        }
      });
    }
    return billeteraTerceros;
  }
}

Future EnvioBilletera(
  BuildContext context,
  String UAT,
  String Monto,
  String CVU,
) async {
  //AlertPop.alert(context, body: Text(Monto.toString()));
  final url = Uri.http(Config.ApiURL, '/api/mEnvios/EnvioBilletera');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
        'Monto': Monto.toString().replaceAll(",", ""),
        'CVU': CVU,
      }));
  var jsonData = jsonDecode(response.body);
  if (jsonData['Status'] == 200) {
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  } else {
    AlertPop.alert(context, body: Text(jsonData['Mensaje']));
  }
}

Future TransferirBilletera(BuildContext context, String UAT, String Monto,
    int MetodoPagoId, int TipoMedioPago) async {
  //AlertPop.alert(context, body: Text(MetodoPagoId.toString()));
  final url = Uri.http(Config.ApiURL, '/api/mEnvios/RetiroDinero');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'UAT': UAT,
        'Monto': Monto.toString().replaceAll(",", ""),
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
