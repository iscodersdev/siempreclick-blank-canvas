import 'dart:typed_data';

class ProveedoresModel {
  int? Id;
  String? Nombre;
  String? CUIT;
  String? RazonSocial;
  String? Domicilio;
  Uint8List? Foto;

  ProveedoresModel({
    this.Id,
    this.Nombre,
    this.CUIT,
    this.Foto,
    this.Domicilio,
    this.RazonSocial,
  });
}
class SubProductoModel {
  int? Id;
  int? ProductoId;
  String? NombreSubProducto;
  SubProductoModel({
    this.Id,
    this.ProductoId,
    this.NombreSubProducto,
  });
}
class RubrosModel {
  int? Id;
  String? Nombre;
  String? Descripcion;
  bool? Activo;
  bool? VerEnAPP;
  Uint8List? IconoAPP;
  RubrosModel({
    this.Id,
    this.Descripcion,
    this.Nombre,
    this.Activo,
    this.VerEnAPP,
    this.IconoAPP,
  });
}
class ProductosModel {
  int? Id;
  String? Descripcion;
  double? Precio;
  String? DescripcionAmpliada;
  Uint8List? Foto;
  Uint8List? Foto1;
  Uint8List? Foto2;
  Uint8List? Foto3;
  Uint8List? Foto4;
  Uint8List? Foto5;

  ProductosModel({
    this.Id,
    this.Descripcion,
    this.DescripcionAmpliada,
    this.Precio,
    this.Foto,
    this.Foto1,
    this.Foto2,
    this.Foto3,
    this.Foto4,
    this.Foto5,
  });
}

class ProductosCompradosModel {
  int? Id;
  String? FechaAnulacion;
  String? EstadoDescripcion;
  String? TipoCompraDescripcion;
  String? FechaCompra;
  int? ProductoId;
  String? Descripcion;
  double? Precio;
  String? DescripcionAmpliada;
  Uint8List? Foto;

  ProductosCompradosModel({
    this.Id,
    this.EstadoDescripcion,
    this.TipoCompraDescripcion,
    this.FechaAnulacion,
    this.FechaCompra,
    this.DescripcionAmpliada,
    this.Descripcion,
    this.Precio,
    this.Foto,
    this.ProductoId,
  });
}

class ProductosCompradosFinanciamientoModel {
  int? Id;
  double? MontoPrestado;
  int? CantidadCuotas;
  double? MontoCuota;
  double? CFT;

  ProductosCompradosFinanciamientoModel({
    this.Id,
    this.MontoPrestado,
    this.CFT,
    this.CantidadCuotas,
    this.MontoCuota,
  });
}
