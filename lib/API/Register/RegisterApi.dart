import 'dart:convert';
import 'package:smart/API/Config/config.dart';
import 'package:smart/Models/RegisterModel/RegisterModel.dart';
import 'package:smart/services/alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class organismos {
  List<OrganismosModel> Organismos = [];

  Future<List<OrganismosModel>> GetOrganismos(BuildContext context) async {
    List<OrganismosModel> prestamoLinea = [];
    final url = Uri.http(Config.ApiURL, '/api/musuario/TraeOrganismo');
    final http.Response response =
        await http.post(url, headers: Config.HttpHeaders, body: jsonEncode({}));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["Organismos"].forEach((element) {
        if (element["Id"] > 0) {
          OrganismosModel organismosModel = OrganismosModel(
            Id: element['Id'],
            Nombre: element['Descripcion'],
          );
          Organismos.add(organismosModel);
        }
      });
    }
    return Organismos;
  }
}

Future<void> RegistraPersona(
    BuildContext context,
    int ClubId,
    String DNI,
    String Nombres,
    String Apellido,
    DateTime BirthDate,
    String Mail,
    String Celular,
    String Password1,
    String Password2,
    String Referido,
    String Token) async {
  final url = Uri.http(Config.ApiURL, '/api/musuario/RegistraPersona20');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'TipoPersona': 16,
        'NumeroDocumento': DNI.toString(),
        'Nombres': Nombres,
        'Apellido': Apellido,
        'FechaNacimiento': BirthDate.toString(),
        'Mail': Mail,
        'Celular': Celular,
        'Password1': Password1,
        'Password2': Password2,
        'Referido': Referido,
        "EmpresaId": 1,
        'Token': Token,
      }));
  // print('TipoPersona: ${ClubId.toString()}');
  // print('NumeroDocumento: ${DNI.toString()}');
  // print('Nombres: $Nombres');
  // print('Apellido: $Apellido');
  // print('FechaNacimiento: ${BirthDate.toString()}');
  // print('Mail: $Mail');
  // print('Celular: $Celular');
  // print('Password1: $Password1');
  // print('Password2: $Password2');
  // print('Referido: $Referido');
  // print('Token: $Token');
  var jsonData = jsonDecode(response.body);
  print(response.body);
  //AlertPop.alert(context, body: Text(response.body));
  storage.write(key: 'RegistroStatus', value: jsonData['Status'].toString());
  storage.write(key: 'RegistroMensaje', value: jsonData['Mensaje']);
}

Future<void> PreRegister(BuildContext context, String Mail, int Id) async {
  print(Id);
  final url = Uri.http(Config.ApiURL, '/api/musuario/PreRegistro');
  final http.Response response = await http.post(url,
      headers: Config.HttpHeaders,
      body: jsonEncode({
        'eMail': Mail,
        'OrganismoId': Id,
      }));
  print(response.body);
  storage.write(key: 'PreRegister', value: response.body);
}
