import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smart/API/Config/config.dart';

//import 'package:onesignal_flutter/onesignal_flutter.dart';
final storage = FlutterSecureStorage();

Future<dynamic> loginUser(
    BuildContext context, String dni, String password) async {
  // var status = await OneSignal.shared.getDeviceState();
  // String onesignalUserId = status.userId;
  final url = Uri.http(Config.ApiURL, '/api/musuario/login20');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'Mail': dni,
        'Password': password,
        'EmpresaId': 1,
        //'DeviceId': onesignalUserId,
      }));

  var jsonData = jsonDecode(response.body);
  print(response.body);
  //AlertPop.alert(context, body: Text(response.body));
  if (jsonData['Status'] == 200) {
    storage.write(key: 'USER', value: response.body);
    Navigator.pushNamed(context, '/Home');
  } else {
    if (jsonData['Mensaje'] == null) {
      return AlertPop.alert(context, body: Text('Mensaje'));
    } else {
      return AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
  }
}

Future<void> MaRecuperarClave(BuildContext context, String DNI) async {
  final url = Uri.http(Config.ApiURL, '/api/musuario/RecuperaPassword');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'eMail': DNI,
      }));
  var jsonData = jsonDecode(response.body);

  if (jsonData['Status'] == 200) {
    _mostrarSnackBar(context, jsonData['Mensaje'], 200);

  } else {
    _mostrarSnackBar(context, jsonData['Mensaje'], 500);
  }
}
_mostrarSnackBar(BuildContext context, String _mensaje, int _status) {
  final snackBarER = SnackBar(
    elevation: 5.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    backgroundColor: _status == 200 ? Colors.green[400] : Colors.red,
    behavior: SnackBarBehavior.floating,
    content: Row(
      children: [
        Icon(_status == 200 ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white),
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: Text(_mensaje,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white)),
        ),
      ],
    ),
    action: SnackBarAction(
      label: 'Cerrar',
      textColor: Colors.white,
      onPressed: () {
        // Solo cierra el popup. no requiere acción
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBarER);
}