import 'dart:convert';
import 'package:smart/API/Config/config.dart';
import 'package:smart/Models/Movimientos%20Model/MovimientosModel.dart';
import 'package:smart/Models/TarjetasModel/TarjetasModel.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

class Tarjetas {
  Future<List<MediosDePagoModel>> getMediosDePago(
      BuildContext context, String UAT, int envio) async {
    List<MediosDePagoModel> mediosdePago = [];
    final url = Uri.http(Config.ApiURL, '/api/mBilletera/MediosPago');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["MediosPago"].forEach((element) {
        if (element["Id"] != null) {
          MediosDePagoModel mediosDePagoModel = MediosDePagoModel(
            Id: element['Id'],
            Descripcion: element['Descripcion'],
            TipoMedioPago: element['TipoMedioPago'],
            DetalleAdicional: element['DetalleAdicional'],
          );

          if (envio == 0) {
            mediosdePago.add(mediosDePagoModel);
            mediosdePago.removeWhere((MediosDePagoModel mediosDePagoModel) =>
                mediosDePagoModel.TipoMedioPago == 3);
          } else {
            mediosdePago.add(mediosDePagoModel);
          }
        }
      });
    }
    return mediosdePago;
  }

  Future<List<TarjetasModel>> getTarjetas(
      BuildContext context, String UAT) async {
    List<TarjetasModel> tarjetas = [];
    final url = Uri.http(Config.ApiURL, '/api/mBilletera/TarjetasBilletera');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["Tarjetas"].forEach((element) {
        if (element["Numero"] != null) {
          TarjetasModel tarjetasModel = TarjetasModel(
            Titular: element['Titular'],
            Numero: element['Numero'],
            Vencimiento: element['Vencimiento'],
          );
          tarjetas.add(tarjetasModel);
        }
      });
    }
    return tarjetas;
  }

  Future AltaTarjeta(BuildContext context, String UAT, String Titular,
      String Numero, String Vencimiento) async {
    final url = Uri.http(Config.ApiURL, '/api/mTarjetas/Alta');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
          'Titular': Titular,
          'Numero': Numero,
          'Vencimiento': Vencimiento,
        }));
    var jsonData = jsonDecode(response.body);
    if (jsonData['Status'] == 200) {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }
}
