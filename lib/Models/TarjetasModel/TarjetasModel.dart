class TarjetasModel {
  String? Titular;
  String? Numero;
  String? Vencimiento;

  TarjetasModel({
    this.Titular,
    this.Numero,
    this.Vencimiento,
  });
}

class MediosDePagoModel {
  int? Id;
  int? TipoMedioPago;
  String? Descripcion;
  String? DetalleAdicional;

  MediosDePagoModel({
    this.Id,
    this.TipoMedioPago,
    this.Descripcion,
    this.DetalleAdicional,
  });
}
