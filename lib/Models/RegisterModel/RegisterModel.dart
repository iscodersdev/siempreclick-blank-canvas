class OrganismosModel {
  int? Id;
  String? Nombre;
  OrganismosModel({this.Nombre, this.Id});
}

class TipoPersonaModel {
  final String? Descripcion;
  final int? Id;

  TipoPersonaModel._({this.Descripcion, this.Id});

  factory TipoPersonaModel.fromJson(Map<String, dynamic> json) {
    return new TipoPersonaModel._(
        Descripcion: json['Descripcion'], Id: json['Id']);
  }
}
