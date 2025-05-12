
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
      
      // Based on LoginApi.dart, we need to make a POST request to the login endpoint
      const response = await fetch("http://portalsmartclick.com.ar/api/musuario/login20", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          Mail: email,
          Password: password,
          EmpresaId: 1
        }),
      });

      const data: LoginResponse = await response.json();
      
      if (data.Status === 200 && data.Usuario) {
        // Login successful
        const userData: User = {
          id: data.Usuario.Id,
          name: data.Usuario.Nombre,
          email: data.Usuario.Email,
          UAT: data.Usuario.UAT,
        };
        
        localStorage.setItem("user", JSON.stringify(userData));
        setUser(userData);
      } else {
        // Login failed
        toast.error(data.Mensaje || "Error al iniciar sesión");
        throw new Error(data.Mensaje || "Error al iniciar sesión");
      }
    } catch (error) {
      console.error("Login error:", error);
      toast.error("No se pudo conectar con el servidor");
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
