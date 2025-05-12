import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/API/Config/config.dart';
import 'package:smart/Models/Proveedores%20Model/ProveedoresModel.dart';
import 'package:smart/services/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Proveedores {
  Future<List<ProveedoresModel>> getProveedores(
      BuildContext context, String UAT) async {
    List<ProveedoresModel> proveedores = [];
    final url = Uri.http(Config.ApiURL, '/api/MProductos/TraeProveedores');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    // AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["Proveedores"].forEach((element) {
        if (element["Id"] != null) {
          ProveedoresModel proveedoresModel = ProveedoresModel(
              Id: element['Id'],
              Nombre: element['Nombre'],
              CUIT: element['CUIT'],
              RazonSocial: element['RazonSocial'],
              Domicilio: element['Domicilio'],
              Foto: (element['Foto'] != null && element['Foto'].length > 23)
                  ? base64Decode(element['Foto']
                      .replaceFirst('data:image/jpeg;base64,', ''))
                  : null);
          proveedores.add(proveedoresModel);
        }
      });
    }
    return proveedores;
  }

  Future<List<ProductosModel>> getProductos(
      BuildContext context, String UAT, String Proveedores, int paginaInicio, int paginaFinal) async {
    List<ProductosModel> productos = [];
    final url = Uri.http(Config.ApiURL, '/api/MProductos/TraeProductos');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
          'ProveedoresId': 1,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (jsonData['Status'] == 200) {

      List<dynamic> _prods = jsonData["Productos"];
        try{
          for(int i = paginaInicio ; i < paginaFinal; i++){
            var element = _prods[i];
            if (element["Id"] != null) {
              ProductosModel productosModel = ProductosModel(
                  Id: element['Id'],
                  Descripcion: element['Descripcion'],
                  DescripcionAmpliada: element['DescripcionAmpliada'],
                  Precio: element['Precio'],
                  Foto: (element['Foto'] != null && element['Foto'].length > 23)
                      ? base64Decode(element['Foto']
                      .replaceFirst('data:image/jpeg;base64,', ''))
                      : null,
                  Foto1: (element['Foto1'] != null && element['Foto1'].length > 23)
                      ? base64Decode(element['Foto1']
                      .replaceFirst('data:image/jpeg;base64,', ''))
                      : null,
                  Foto2: (element['Foto2'] != null && element['Foto2'].length > 23)
                      ? base64Decode(element['Foto2']
                      .replaceFirst('data:image/jpeg;base64,', ''))
                      : null,
                  Foto3: (element['Foto3'] != null && element['Foto3'].length > 23)
                      ? base64Decode(element['Foto3']
                      .replaceFirst('data:image/jpeg;base64,', ''))
                      : null,
                  Foto4: (element['Foto4'] != null && element['Foto4'].length > 23)
                      ? base64Decode(element['Foto4']
                      .replaceFirst('data:image/jpeg;base64,', ''))
                      : null,
                  Foto5: (element['Foto5'] != null && element['Foto5'].length > 23)
                      ? base64Decode(element['Foto5']
                      .replaceFirst('data:image/jpeg;base64,', ''))
                      : null);
              productos.add(productosModel);
            }
          }

        }catch (e){
          print("NO HAY MÁS PRODUCTOS PARA CARGAR $e");
          _mostrarSnackBar(context, "No se encontraron más productos.", 500);
        }
    } return productos;

  }
  Future<List<ProductosModel>> getProductosPorRubro(
      BuildContext context, String UAT,int Id) async {
    List<ProductosModel> productos = [];
    final url = Uri.http(Config.ApiURL, '/api/MProductos/TraeProductosPorRubro');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
          'ProveedoresId': 1,
          'RubroId':Id,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (jsonData['Status'] == 200) {
      jsonData["Productos"].forEach((element) {
        if (element["Id"] != null) {
          ProductosModel productosModel = ProductosModel(
              Id: element['Id'],
              Descripcion: element['Descripcion'],
              DescripcionAmpliada: element['DescripcionAmpliada'],
              Precio: element['Precio'],
              Foto: (element['Foto'] != null && element['Foto'].length > 23)
                  ? base64Decode(element['Foto']
                  .replaceFirst('data:image/jpeg;base64,', ''))
                  : null,
              Foto1: (element['Foto1'] != null && element['Foto1'].length > 23)
                  ? base64Decode(element['Foto1']
                  .replaceFirst('data:image/jpeg;base64,', ''))
                  : null,
              Foto2: (element['Foto2'] != null && element['Foto2'].length > 23)
                  ? base64Decode(element['Foto2']
                  .replaceFirst('data:image/jpeg;base64,', ''))
                  : null,
              Foto3: (element['Foto3'] != null && element['Foto3'].length > 23)
                  ? base64Decode(element['Foto3']
                  .replaceFirst('data:image/jpeg;base64,', ''))
                  : null,
              Foto4: (element['Foto4'] != null && element['Foto4'].length > 23)
                  ? base64Decode(element['Foto4']
                  .replaceFirst('data:image/jpeg;base64,', ''))
                  : null,
              Foto5: (element['Foto5'] != null && element['Foto5'].length > 23)
                  ? base64Decode(element['Foto5']
                  .replaceFirst('data:image/jpeg;base64,', ''))
                  : null);
          productos.add(productosModel);
        }
      });
    }
    return productos;
  }
  Future<List<ProductosModel>> getProductosHome(
      BuildContext context, String UAT, String Proveedores) async {
    List<ProductosModel> productos = [];
    final url = Uri.http(Config.ApiURL, '/api/MProductos/TraeProductos');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (jsonData['Status'] == 200) {
      int elementosAConsiderar = 4; // Define cuántos elementos quieres considerar
      for (int i = 0; i < jsonData["Productos"].length && i < elementosAConsiderar; i++) {
        var element = jsonData["Productos"][i];
        if (element["Id"] != null) {
          ProductosModel productosModel = ProductosModel(
              Id: element['Id'],
              Descripcion: element['Descripcion'],
              DescripcionAmpliada: element['DescripcionAmpliada'],
              Precio: element['Precio'],
              Foto: (element['Foto'] != null && element['Foto'].length > 23)
                  ? base64Decode(element['Foto']
                  .replaceFirst('data:image/jpeg;base64,', ''))
                  : null);
          productos.add(productosModel);
        }
      }
    }
    return productos;

  }
  Future<List<RubrosModel>> getRubros(BuildContext context, String UAT) async {
    List<RubrosModel> rubros = [];
    final url =
    Uri.http(Config.ApiURL, '/api/MProductos/TraeRubros');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (jsonData['Status'] == 200) {
      jsonData["Rubros"].forEach((element) {
        if (element["Id"] != null) {
          RubrosModel rubrosModel =  RubrosModel(
            Id: element['Id'],
            Nombre: element['Nombre'],
            Descripcion: element['Descripcion'],
            Activo:  element['Activo'],
            VerEnAPP:  element['VerEnAPP'],
            IconoAPP: (element['IconoAPP'] != null && element['IconoAPP'].length > 23)
                ? base64Decode(element['IconoAPP']
                .replaceFirst('data:image/jpeg;base64,', ''))
                : null,
          );
          rubros.add(rubrosModel);
        }
      });
    }
    return rubros;
  }
  Future<List<ProductosCompradosModel>> getProductosComprados(
      BuildContext context, String UAT) async {
    List<ProductosCompradosModel> productosComprados = [];
    final url =
        Uri.http(Config.ApiURL, '/api/MProductos/TraeProductosComprados');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (jsonData['Status'] == 200) {
      jsonData["Compras"].forEach((element) {
        if (element["Id"] != null) {
          //var producto = jsonDecode(element['Producto'].toString());
          //print(producto);
          ProductosCompradosModel productosCompradosModel =
              ProductosCompradosModel(
            Id: element['Id'],
            FechaCompra: element['FechaCompra'],
            EstadoDescripcion: element['EstadoDescripcion'],
            TipoCompraDescripcion: element['TipoCompraDescripcion'],
            Precio: element['Precio'],
            DescripcionAmpliada: element['DescripcionAmpliada'],
            FechaAnulacion: element['FechaAnulacion'],
            Foto: (element['Foto'] != null && element['Foto'].length > 23)
                ? base64Decode(
                    element['Foto'].replaceFirst('data:image/jpeg;base64,', ''))
                : null,
            Descripcion: element['Descripcion'],
            ProductoId: element['ProductoID'],
          );
          productosComprados.add(productosCompradosModel);
        }
      });
    }
    return productosComprados;
  }

  final storage = FlutterSecureStorage();
  Future<List<ProductosCompradosFinanciamientoModel>>
      getPlanesDisponiblesComprar(
          BuildContext context, String UAT, int Id,) async {
    List<ProductosCompradosFinanciamientoModel> prestamoLinea = [];
    final url =
        Uri.http(Config.ApiURL, '/api/MProductos/compraporfinanciamiento');
    final http.Response response = await http.post(url,
        headers: Config.HttpHeaders,
        body: jsonEncode({
          'UAT': UAT,
          'ProductoId': Id,
          //'SubProductoId':SubId == null?null:SubId,
        }));
    var jsonData = jsonDecode(response.body);
    print(response.body);
    storage.write(key: 'planesProd', value: response.body);
    //AlertPop.alert(context, body: Text(response.body));
    if (jsonData['Status'] == 200) {
      jsonData["PlanesDisponibles"].forEach((element) {
        if (element["Id"] > 0) {
          ProductosCompradosFinanciamientoModel
              productosCompradosFinanciamientoModelModel =
              ProductosCompradosFinanciamientoModel(
            Id: element['Id'],
            CFT: element['CFT'],
            MontoPrestado: element['MontoPrestado'],
            CantidadCuotas: element['CantidadCuotas'],
            MontoCuota: element['MontoCuota'],
          );
          prestamoLinea.add(productosCompradosFinanciamientoModelModel);
          storage.write(key: 'montosdispprod', value: '0');
        }
      });
    } else {
      storage.write(key: 'montosdispprod', value: '1');
      // AlertPop.alert(context, body: Text(jsonData['Mensaje']));
    }
    return prestamoLinea;
  }
}
_mostrarSnackBar(BuildContext context, String _mensaje, int _status) {
  final snackBarER = SnackBar(
    elevation: 5.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    backgroundColor: _status == 200 ? Colors.green[400] : Colors.grey[400],
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