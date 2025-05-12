import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;
import 'package:smart/Models/noticia/Noticia.dart';
import 'package:smart/services/alert.dart';
import 'Config/config.dart';

class NoticiasServices {
  List<NoticiaModel> novedades = [];
  Future<List<NoticiaModel>> getNovedades(
      BuildContext context, String UAT, int UltimoId) async {
    final url = Uri.http(Config.ApiURL, '/api/mNovedades/TraeNovedades');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
          'UltimoId': UltimoId
        }));
    var jsonData = jsonDecode(response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["Novedades"].forEach((element) {
        if (element["Titulo"] != null) {
          NoticiaModel noticiaModel = NoticiaModel(
              Id: element['Id'],
              Titulo: element['Titulo'],
              Fecha: element['Fecha'],
              Texto: element["Texto"],
              Imagen:
                  (element['Imagen'] != null && element['Imagen'].length > 23)
                      ? base64Decode(element['Imagen']
                          .replaceFirst('data:image/jpeg;base64,', ''))
                      : null);
          novedades.add(noticiaModel);
        }
      });
    }
    return novedades;
  }
}
