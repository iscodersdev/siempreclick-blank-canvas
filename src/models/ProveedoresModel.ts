
export interface ProveedoresModel {
  Id?: number;
  Nombre?: string;
  CUIT?: string;
  RazonSocial?: string;
  Domicilio?: string;
  Foto?: string; // Base64 string for image data
}

export interface SubProductoModel {
  Id?: number;
  ProductoId?: number;
  NombreSubProducto?: string;
}

export interface RubrosModel {
  Id?: number;
  Nombre?: string;
  Descripcion?: string;
  Activo?: boolean;
  VerEnAPP?: boolean;
  IconoAPP?: string; // Base64 string for image data
}

export interface ProductosModel {
  Id?: number;
  Descripcion?: string;
  Precio?: number;
  DescripcionAmpliada?: string;
  Foto?: string; // Base64 string for image data
  Foto1?: string;
  Foto2?: string;
  Foto3?: string;
  Foto4?: string;
  Foto5?: string;
}

export interface ProductosCompradosModel {
  Id?: number;
  FechaAnulacion?: string;
  EstadoDescripcion?: string;
  TipoCompraDescripcion?: string;
  FechaCompra?: string;
  ProductoId?: number;
  Descripcion?: string;
  Precio?: number;
  DescripcionAmpliada?: string;
  Foto?: string; // Base64 string for image data
}

export interface ProductosCompradosFinanciamientoModel {
  Id?: number;
  MontoPrestado?: number;
  CantidadCuotas?: number;
  MontoCuota?: number;
  CFT?: number;
}
