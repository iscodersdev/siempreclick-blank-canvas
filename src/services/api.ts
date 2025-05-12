
import { MovimientosModel } from "../models/MovimientosModel";
import { ProveedoresModel, ProductosModel } from "../models/ProveedoresModel";

const API_URL = "https://api.siempreclick.com"; // Replace with actual API URL

// Helper function for API requests
const fetchAPI = async <T>(endpoint: string, options: RequestInit = {}): Promise<T> => {
  const response = await fetch(`${API_URL}${endpoint}`, {
    headers: {
      "Content-Type": "application/json",
      // Add auth headers here
    },
    ...options,
  });
  
  if (!response.ok) {
    throw new Error(`API Error: ${response.status}`);
  }
  
  return response.json();
};

// Auth API
export const login = async (username: string, password: string) => {
  return fetchAPI("/login", {
    method: "POST",
    body: JSON.stringify({ username, password }),
  });
};

export const register = async (userData: any) => {
  return fetchAPI("/register", {
    method: "POST",
    body: JSON.stringify(userData),
  });
};

// Movements API
export const getMovimientos = async (): Promise<MovimientosModel[]> => {
  return fetchAPI<MovimientosModel[]>("/movimientos");
};

// Providers API
export const getProveedores = async (): Promise<ProveedoresModel[]> => {
  return fetchAPI<ProveedoresModel[]>("/proveedores");
};

export const getProveedor = async (id: number): Promise<ProveedoresModel> => {
  return fetchAPI<ProveedoresModel>(`/proveedores/${id}`);
};

// Products API
export const getProductos = async (): Promise<ProductosModel[]> => {
  return fetchAPI<ProductosModel[]>("/productos");
};

export const getProducto = async (id: number): Promise<ProductosModel> => {
  return fetchAPI<ProductosModel>(`/productos/${id}`);
};

// Loans API
export const getPrestamos = async (): Promise<any[]> => {
  return fetchAPI<any[]>("/prestamos");
};

export const getPrestamo = async (id: number): Promise<any> => {
  return fetchAPI<any>(`/prestamos/${id}`);
};

export const solicitarPrestamo = async (prestamoData: any) => {
  return fetchAPI("/prestamos", {
    method: "POST",
    body: JSON.stringify(prestamoData),
  });
};
