
import { MovimientosModel } from "../models/MovimientosModel";
import { ProveedoresModel, ProductosModel } from "../models/ProveedoresModel";

// Use the base URL from the Flutter config
const API_URL = "http://portalsmartclick.com.ar"; 

// Helper function for API requests
const fetchAPI = async <T>(endpoint: string, options: RequestInit = {}): Promise<T> => {
  try {
    const response = await fetch(`${API_URL}${endpoint}`, {
      headers: {
        "Content-Type": "application/json",
        // Add auth headers here if needed
      },
      ...options,
    });
    
    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(`API Error: ${response.status} - ${errorData.Mensaje || 'Unknown error'}`);
    }
    
    return response.json();
  } catch (error) {
    console.error("API fetch error:", error);
    throw error;
  }
};

// Auth API
export const login = async (email: string, password: string) => {
  return fetchAPI("/api/musuario/login20", {
    method: "POST",
    body: JSON.stringify({ 
      Mail: email, 
      Password: password,
      EmpresaId: 1
    }),
  });
};

export const register = async (userData: any) => {
  return fetchAPI("/api/musuario/GenerarUsuarioApp", {
    method: "POST",
    body: JSON.stringify(userData),
  });
};

export const recuperarContraseña = async (email: string) => {
  return fetchAPI("/api/musuario/RecuperaPassword", {
    method: "POST",
    body: JSON.stringify({ eMail: email }),
  });
};

// Movements API
export const getMovimientos = async (): Promise<MovimientosModel[]> => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI<MovimientosModel[]>(`/api/mmovimientos/ConsultarMovimientos?uat=${uat}`);
};

// Providers API
export const getProveedores = async (): Promise<ProveedoresModel[]> => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI<ProveedoresModel[]>(`/api/mproveedores/ConsultarProveedores?uat=${uat}`);
};

export const getProveedor = async (id: number): Promise<ProveedoresModel> => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI<ProveedoresModel>(`/api/mproveedores/ConsultarProveedor?uat=${uat}&ProveedorId=${id}`);
};

// Products API
export const getProductos = async (): Promise<ProductosModel[]> => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI<ProductosModel[]>(`/api/mproductos/ConsultarProductos?uat=${uat}`);
};

export const getProducto = async (id: number): Promise<ProductosModel> => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI<ProductosModel>(`/api/mproductos/ConsultarProducto?uat=${uat}&ProductoId=${id}`);
};

// Loans API
export const getPrestamos = async (): Promise<any[]> => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI<any[]>(`/api/mprestamos/ConsultarPrestamos?uat=${uat}`);
};

export const getPrestamo = async (id: number): Promise<any> => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI<any>(`/api/mprestamos/ConsultarPrestamo?uat=${uat}&PrestamoId=${id}`);
};

export const solicitarPrestamo = async (prestamoData: any) => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI(`/api/mprestamos/SolicitarPrestamo?uat=${uat}`, {
    method: "POST",
    body: JSON.stringify(prestamoData),
  });
};

export const getLegajoPrestamo = async (id: number): Promise<any> => {
  const user = JSON.parse(localStorage.getItem("user") || "{}");
  const uat = user.UAT || "";
  return fetchAPI<any>(`/api/mprestamos/DescargaLegajoElectronico?uat=${uat}&PrestamoId=${id}`);
};
