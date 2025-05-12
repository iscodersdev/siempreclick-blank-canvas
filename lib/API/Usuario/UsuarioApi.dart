import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smart/API/Config/config.dart';
import 'package:smart/services/alert.dart';

final storage = FlutterSecureStorage();

class GrabaDatos {
  Future<dynamic> TraeDatosUsuario(BuildContext context, String UAT) async {
    final url = Uri.http(Config.ApiURL, '/api/MUsuario/TraeDatosUsuario');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    final dynamic _decodedJson = jsonDecode(response.body);
    if (_decodedJson['Status'] == 200) {
      await storage.write(key: "UsuarioDatos", value: response.body);
    } else {
      return AlertPop.alert(context,
          body: Text("Error No se encontraron datos del Usuario"));
    }
  }

  Future<void> GrabaDatosUsuario(
      BuildContext context, String UAT, dynamic _decodedJson) async {
    final url = Uri.http(Config.ApiURL, '/api/MUsuario/Actualiza_Datos_Legajo');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'mut_UAT': UAT,
          'usu_Celular': _decodedJson['Celular'],
          'usu_Mail': _decodedJson['Mail'],
          'cambia_Password_1': _decodedJson['Password'],
          'cambia_Password_2': _decodedJson['Password1'],
          'cambia_Password_3': _decodedJson['Password2'],
        }));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 200) {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }

  Future<void> GrabaDatosUsuarioInicio(
      BuildContext context,
      String UAT,
      String Celular,
      String Mail,
      DateTime Birth,
      String Pass1,
      String Pass2,
      String Domicilio) async {
    if (Birth == null) {
      Birth = DateTime.now();
    }
    final url = Uri.http(Config.ApiURL, '/api/MUsuario/ActualizaDatosPersona');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'uat': UAT,
          'Celular': Celular,
          'Mail': Mail,
          'Domicilio': Domicilio,
          'FechaNacimiento': Birth.toString(),
          'Password1': Pass1,
          'Password2': Pass2,
        }));

    var jsonData = jsonDecode(response.body);

    if (jsonData['Status'] == 200) {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }

  Future<void> GrabaFoto(
      BuildContext context, String UAT, Uint8List Foto) async {
    final url = Uri.http(Config.ApiURL, '/api/MUsuario/ActualizaFoto');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
          'Foto': Foto,
        }));

    var jsonData = jsonDecode(response.body);
    if (jsonData['Status'] == 200) {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    } else {
      AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }

  Future<void> ActualizaDarkMode(
      BuildContext context, String UAT, bool DarkMode) async {
    final url = Uri.http(Config.ApiURL, '/api/MUsuario/ActualizaDarkMode');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
          'DarkMode': DarkMode,
        }));

    var jsonData = jsonDecode(response.body);
    if (jsonData['Status'] == 200) {
    } else {
      AlertPop.alert(context, body: Text("No es posible Usar el DarkMode"));
    }
  }
}
