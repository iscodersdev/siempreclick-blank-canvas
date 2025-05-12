import 'dart:convert';
import 'dart:typed_data';
import 'package:smart/Screens/Prestamos/Prestamos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;
import 'package:smart/API/Config/config.dart';
import 'package:smart/Models/Prestamos/PrestamosModel.dart';
import 'package:smart/services/alert.dart';


import '../../services/slideUpAnimation.dart';

final storage = FlutterSecureStorage();

class Prestamos {
  Future CompraEnCuotas(
      BuildContext context,
      String UAT,
      int Id,
      Uint8List Front,
      Uint8List Back,
      Uint8List Human,
      double Importe,
      int Cant,
      double Monto,
      int TipoPer,
      Uint8List Firma,
      Uint8List Recibo,
      Uint8List Certificado,
      String ProdID,String? SubId) async {
    print("SubProductoID: ${SubId!}");
    final url = Uri.http(Config.ApiURL, '/api/MProductos/Financiar');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'LineaPrestamoId': Id,
          'ProductoId': ProdID,
          'ImporteSolicitado': Importe,
          'FotoDNIAnverso': Front,
          'FotoDNIReverso': Back,
          'FotoSosteniendoDNI': Human,
          'CantidadCuotas': Cant,
          'MontoCuota': Monto,
          'TipoPersonaId': TipoPer,
          'FotoCertificadoDescuento': Certificado,
          'FotoReciboHaber': Recibo,
          'FirmaOlografica': Firma,
          'SubProductoID':SubId!.isNotEmpty?int.parse(SubId):null,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (jsonData['Status'] == 200) {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }

  Future ComprarConFondos(
      BuildContext context, String UAT, int ProductoID,int SubId) async {
    print(UAT);
    final url = Uri.http(Config.ApiURL, '/api/MProductos/CompraPorDebito');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({'UAT': UAT, 'ProductoId': ProductoID,'SubProductoId':SubId,}));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }

  Future<List<PrestamosModel>> getPrestamos(
      BuildContext context, String UAT) async {
    //AlertPop.alert(context, body: Text(UAT));
    List<PrestamosModel> prestamo = [];
    final url = Uri.http(Config.ApiURL, '/api/mprestamos/TraePrestamos');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (jsonData['Status'] == 200) {
      jsonData["Prestamos"].forEach((element) {
        if (element["Id"] > 0) {
          PrestamosModel prestamosModel = PrestamosModel(
            Id: element['Id'],
            MontoCuota: element['MontoCuota'],
            Saldo: element['Saldo'],
            Fecha: element['Fecha'],
            CFT: element['CFT'],
            Anulable: element['Anulable'],
            Color: element['Color'],
            Producto: element['Producto'],
            MontoPrestado: element['MontoPrestado '],
            CuotasRestantes: element['CuotasRestantes'],
            CantidadCuotas: element['CantidadCuotas'],
            Estado: element['Estado'],
            Transferido: element['Transferido'],
            Confirmable: element['Confirmable'],
            MontoCuotaAmpliado: element['MontoCuotaAmpliado'],
          );
          prestamo.add(prestamosModel);
        }
      });
    }
    return prestamo;
  }

  Future<void> getLegajo(BuildContext context, String UAT, String Id) async {
    final url =
        Uri.http(Config.ApiURL, '/api/mprestamos/TraeLegajoElectronico');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'PrestamoId': Id,
        }));

    final dynamic _decodedJson = jsonDecode(response.body);

    if (_decodedJson['Status'].toString().isEmpty ||
        _decodedJson['Status'] != 200) {
      return AlertPop.alert(context, body: Text(_decodedJson["Mensaje"]));
    } else {
      storage.write(key: "Binario", value: response.body);
    }
  }

  Future<List<PrestamoRenglonModel>> getPrestamosRenglones(
      BuildContext context, String UAT, int Id) async {
    List<PrestamoRenglonModel> prestamoRenglon = [];
    final url =
        Uri.http(Config.ApiURL, '/api/mprestamos/TraePrestamosRenglones');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'PrestamoId': Id,
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["Renglones"].forEach((element) {
        if (element["Id"] > 0) {
          PrestamoRenglonModel prestamosrenModel = PrestamoRenglonModel(
            Id: element['Id'],
            Saldo: element['Saldo'],
            Credito: element['Credito'],
            Fecha: element['Fecha'],
            Concepto: element['Concepto'],
            Debito: element['Debito'],
          );
          prestamoRenglon.add(prestamosrenModel);
        }
      });
    }
    return prestamoRenglon;
  }

  Future<void> getMontoMax(BuildContext context, String UAT, int Monto) async {
    final url =
        Uri.http(Config.ApiURL, '/api/MPrestamos/MontoMensualDisponible');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'MontoMensualDisponible': Monto,
        }));

    final dynamic _decodedJson = jsonDecode(response.body);
    print(response.body);
    if (_decodedJson['Status'].toString().isEmpty ||
        _decodedJson['Status'] != 200) {
      return AlertPop.alert(context, body: Text(_decodedJson["Mensaje"]));
    } else {
      storage.write(key: "Binario", value: response.body);
    }
  }

  Future<List<PrestamoLineasModel>> getPrestamosLineas(
      BuildContext context, String UAT, bool Ampliado) async {
    print(Ampliado);
    List<PrestamoLineasModel> prestamoLinea = [];
    final url = Uri.http(Config.ApiURL, '/api/mprestamos/TraeLineasPrestamos');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'Ampliado': Ampliado,
        }));

    var jsonData = jsonDecode(response.body);

    storage.write(key: 'lineas', value: response.body);
    print(response.body);

    if (jsonData['Status'] == 200) {
      storage.write(
          key: 'Disponible', value: jsonData['Disponible'].toString());
      jsonData["LineasPrestamos"].forEach((element) {
        if (element["Id"] > 0) {
          PrestamoLineasModel prestamoslinModel = PrestamoLineasModel(
            Id: element['Id'],
            Nombre: element['Nombre'],
            MontoMaximo: element['MontoMaximo'],
            MontoMinimo: element['MontoMinimo'],
            Intervalo: element['Intervalo'],
          );
          prestamoLinea.add(prestamoslinModel);
        }
      });
    } else {
      Navigator.of(context).pop();
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
    return prestamoLinea;
  }

  Future<List<PlanesDisponibles>> getPlanesDisponibles(BuildContext context,
      String UAT, int Id, double ImporteDeseado, bool Ampliado) async {
    print(Id);
    print(UAT);
    print(Ampliado);
    print(ImporteDeseado);
    List<PlanesDisponibles> prestamoLinea = [];
    final url =
        Uri.http(Config.ApiURL, '/api/mprestamos/TraePlanesDisponibles');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'ImporteDeseado': ImporteDeseado,
          'Ampliado': Ampliado,
          'LineaId': Id,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    storage.write(key: 'planes', value: response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["PlanesDisponibles"].forEach((element) {
        if (element["Id"] > 0) {
          PlanesDisponibles planesModel = PlanesDisponibles(
            Id: element['Id'],
            CFT: element['CFT'],
            MontoPrestado: element['MontoPrestado'],
            CantidadCuotas: element['CantidadCuotas'],
            MontoCuota: element['MontoCuota'],
          );
          prestamoLinea.add(planesModel);
          storage.write(key: 'montosdisp', value: '0');
        }
      });
    } else {
      storage.write(key: 'montosdisp', value: '1');
      // AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
    return prestamoLinea;
  }

  Future<List<PreCancelaciones>> GetPrecancelaciones(
      BuildContext context, String UAT) async {
    List<PreCancelaciones> precancelacion = [];
    final url = Uri.http(Config.ApiURL, '/api/mprestamos/TraePrecancelaciones');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    //print(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["Precancelaciones"].forEach((element) {
        if (element["PrestamoId"] > 0) {
          PreCancelaciones preCancelacionesModel = PreCancelaciones(
            PrestamoId: element['PrestamoId'],
            Entidad: element['Entidad'],
            NumeroConvenio: element['NumeroConvenio'],
            ImporteCuota: element['ImporteCuota'],
            Precancelar: element['Precancelar'],
          );
          precancelacion.add(preCancelacionesModel);
        }
      });
    } else {
      storage.write(key: 'montosdisp', value: '1');
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
    return precancelacion;
  }

  Future<List<PlanesDisponibles>> getPlanesDisponiblesOrg(BuildContext context,
      String UAT, int Id, double ImporteDeseado, bool Ampliado) async {
    print(ImporteDeseado);
    List<PlanesDisponibles> prestamoLinea = [];
    final url = Uri.http(
        Config.ApiURL, '/api/mprestamos/TraePlanesDisponiblesOtroOrganismo');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'ImporteDeseado': ImporteDeseado,
          'Ampliado': Ampliado,
          'LineaId': Id,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    storage.write(key: 'planes', value: response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["PlanesDisponibles"].forEach((element) {
        if (element["Id"] > 0) {
          PlanesDisponibles planesModel = PlanesDisponibles(
            Id: element['Id'],
            CFT: element['CFT'],
            MontoPrestado: element['MontoPrestado'],
            CantidadCuotas: element['CantidadCuotas'],
            MontoCuota: element['MontoCuota'],
          );
          prestamoLinea.add(planesModel);
          storage.write(key: 'montosdisp', value: '0');
        }
      });
    } else {
      storage.write(key: 'montosdisp', value: '1');
      // AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
    return prestamoLinea;
  }

  Future solicitarPrestamo(
      BuildContext context,
      String UAT,
      List Precancel,
      int Id,
      Uint8List Front,
      Uint8List Back,
      Uint8List Human,
      double Importe,
      String Cant,
      double Monto,
      int TipoPer,
      Uint8List Firma,
      Uint8List Recibo,
      Uint8List Certificado,
      bool Ampliado,
      String Disponible) async {
    print(Importe);
    final url = Uri.http(Config.ApiURL, '/api/mprestamos/SolicitaPrestamo');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'Precancelaciones': Precancel,
          'LineaPrestamoId': Id,
          'ImporteSolicitado': Importe,
          'FotoDNIAnverso': Front,
          'FotoDNIReverso': Back,
          'FotoSosteniendoDNI': Human,
          'CantidadCuotas': Cant,
          'MontoCuota': Monto,
          'TipoPersonaId': TipoPer,
          'FotoCertificadoDescuento': Certificado,
          'FotoReciboHaber': Recibo,
          'FirmaOlografica': Firma,
          'Ampliado': Ampliado,
          'Disponible': double.parse(Disponible),
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    print(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TransferenciaOkAnimation()));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }

  Future PedirToken(BuildContext context, String UAT, int Id) async {
    final url = Uri.http(Config.ApiURL, '/api/mprestamos/SolicitaToken');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'PrestamoId': Id,
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      await storage.write(key: 'Token', value: '1');
    }
  }

  Future anularPrestamo(BuildContext context, String UAT, int Id) async {
    final url = Uri.http(Config.ApiURL, '/api/mprestamos/AnulaPrestamo');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'PrestamoId': Id,
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }

  Future ConfirmaPrestamo(BuildContext context, String UAT, int Id,
      String Token, Uint8List Signature) async {
    final url = Uri.http(Config.ApiURL, '/api/mprestamos/ConfirmarPrestamo');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'PrestamoId': Id,
          'Token': int.parse(Token),
          'FirmaOlografica': Signature,
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }
}
