import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class PrestamosModel {
  int? Id;
  double? MontoCuota;
  String? Producto;
  String? Fecha;
  double? MontoPrestado;
  double? MontoCuotaAmpliado;
  double? Saldo;
  double? CuotasRestantes;
  double? CFT;
  int? CantidadCuotas;
  String? Estado;
  bool? Anulable;
  bool? Confirmable;
  bool? Transferido;
  String? Color;

  PrestamosModel({
    this.Confirmable,
    this.MontoCuota,
    this.MontoCuotaAmpliado,
    this.CFT,
    this.Transferido,
    this.CantidadCuotas,
    this.Fecha,
    this.Color,
    this.Anulable,
    this.CuotasRestantes,
    this.Id,
    this.MontoPrestado,
    this.Producto,
    this.Estado,
    this.Saldo,
  });
}

class PrestamoRenglonModel {
  int? Id;
  String? Concepto;
  String? Fecha;
  double? Credito;
  double? Saldo;
  double? Debito;

  PrestamoRenglonModel({
    this.Fecha,
    this.Debito,
    this.Id,
    this.Credito,
    this.Concepto,
    this.Saldo,
  });
}

class PrestamoLineasModel {
  int? Id;
  String? Nombre;
  double? MontoMinimo;
  double? MontoMaximo;
  double? Intervalo;

  PrestamoLineasModel({
    this.Id,
    this.Nombre,
    this.Intervalo,
    this.MontoMaximo,
    this.MontoMinimo,
  });
}

class PlanesDisponibles {
  int? Id;
  double? MontoPrestado;
  int? CantidadCuotas;
  double? MontoCuota;
  double? CFT;

  PlanesDisponibles({
    this.Id,
    this.MontoPrestado,
    this.CFT,
    this.CantidadCuotas,
    this.MontoCuota,
  });
}

class PreCancelaciones {
  int? PrestamoId;
  String? Entidad;
  String? NumeroConvenio;
  double? ImporteCuota;
  bool? Precancelar;

  PreCancelaciones({
    this.PrestamoId,
    this.Entidad,
    this.NumeroConvenio,
    this.ImporteCuota,
    this.Precancelar,
  });
  PreCancelaciones.fromJson(Map<String, dynamic> json)
      : PrestamoId = json['PrestamoId'],
        Entidad = json['Entidad'],
        NumeroConvenio = json['NumeroConvenio'],
        ImporteCuota = json['ImporteCuota'],
        Precancelar = json['Precancelar'];
  Map<String, dynamic> toJson() {
    return {
      'PrestamoId': PrestamoId,
      'Entidad': Entidad,
      'NumeroConvenio': NumeroConvenio,
      'ImporteCuota': ImporteCuota,
      'Precancelar': Precancelar,
    };
  }
}
