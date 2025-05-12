import 'dart:convert';

import 'dart:typed_data';

class NoticiaModel {
  int? Id;
  String? Titulo;
  String? Fecha;
  String? Texto;
  String? tiempoLectura;
  Uint8List? Imagen;

  NoticiaModel({
    this.Id,
    this.Titulo,
    this.Fecha,
    this.Texto,
    this.tiempoLectura,
    this.Imagen,
  });

  String? resumen() {
    return this.Texto!.length > 150
        ? this.Texto!.substring(0, 150) + '...'
        : this.Texto;
  }

  String calcularTiempoLectura() {
    final int? ppm = 160;
    final int? cantPalabas = this.Texto!.split(' ').length;
    final double? tiempo = (cantPalabas! / ppm!);
    if (tiempo! >= 1)
      return (tiempo).round().toString() + ' minutos';
    else
      return (tiempo * 60).round().toString() + ' segundos';
  }
}
