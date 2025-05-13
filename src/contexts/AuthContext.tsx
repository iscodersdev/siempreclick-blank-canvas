
import React, { createContext, useContext, useState, useEffect } from "react";
import { toast } from "sonner";

interface User {
  id: string;
  name: string;
  email: string;
  UAT?: string; // Adding UAT field which appears in the Flutter app
}

interface LoginResponse {
  Status: number;
  Mensaje?: string;
  Usuario?: {
    Id: string;
    Nombre: string;
    Email: string;
    UAT: string;
  };
}

interface AuthContextType {
  user: User | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check if user is already logged in
    const checkAuthStatus = async () => {
      try {
        // Get stored user data
        const storedUser = localStorage.getItem("user");
        if (storedUser) {
          setUser(JSON.parse(storedUser));
        }
      } catch (error) {
        console.error("Auth check error:", error);
      } finally {
        setLoading(false);
      }
    };

    checkAuthStatus();
  }, []);

  const login = async (email: string, password: string) => {
    try {
      setLoading(true);
      
      // Updated API call with HTTPS and proper CORS handling
      const response = await fetch("https://portalsmartclick.com.ar/api/musuario/login20", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
          'Access-Control-Expose-Headers': 'Access-Control-*',
          'Access-Control-Allow-Headers': 'Access-Control-*, Origin, X-Requested-With, Content-Type, Accept'
        },
        mode: 'cors',
        body: JSON.stringify({
          Mail: email,
          Password: password,
          EmpresaId: 1
        }),
      });

      // Add debugging information
      console.log("Login response status:", response.status);
      
      const data: LoginResponse = await response.json();
      console.log("Login response data:", data);
      
      // Replicate the Flutter app logic
      if (data.Status === 200 && data.Usuario) {
        // Login successful
        const userData: User = {
          id: data.Usuario.Id,
          name: data.Usuario.Nombre,
          email: data.Usuario.Email,
          UAT: data.Usuario.UAT,
        };
        
        // Save user data in local storage (similar to Flutter's secure storage)
        localStorage.setItem("user", JSON.stringify(userData));
        
        // Also store route info like the Flutter app does
        localStorage.setItem("routePrestamos", "0");
        
        setUser(userData);
        toast.success(`¡Bienvenido, ${userData.name || 'Usuario'}!`);
      } else {
        // Login failed
        toast.error(data.Mensaje || "Error al iniciar sesión");
        throw new Error(data.Mensaje || "Error al iniciar sesión");
      }
    } catch (error) {
      console.error("Login error:", error);
      
      // More specific error message based on the type of error
      if (error instanceof TypeError && error.message.includes('Failed to fetch')) {
        toast.error("No se pudo conectar con el servidor. Verifique su conexión a Internet o inténtelo más tarde.");
      } else {
        toast.error("No se pudo conectar con el servidor");
      }
      
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    localStorage.removeItem("user");
    setUser(null);
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        login,
        logout,
        isAuthenticated: !!user,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
};
