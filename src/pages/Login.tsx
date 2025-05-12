
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { toast } from "sonner";
import { useAuth } from "@/contexts/AuthContext";

const Login = () => {
  const navigate = useNavigate();
  const { login } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [remember, setRemember] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!email || !password) {
      toast.error("Por favor complete todos los campos");
      return;
    }
    
    setLoading(true);
    
    try {
      await login(email, password);
      navigate("/home");
    } catch (error) {
      console.error("Login error:", error);
      // Error toast is already shown in the AuthContext
    } finally {
      setLoading(false);
    }
  };

  const handleRecuperarContraseña = () => {
    if (!email) {
      toast.error("Debe ingresar un Correo Electrónico para Recuperar Contraseña");
      return;
    }

    // Implement password recovery functionality
    toast.info("Se ha enviado un correo para recuperar su contraseña");
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100 p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <img 
            src="/assets/Images/siempreclickLogo.png" 
            alt="SiempreClick Logo" 
            className="h-28 mx-auto mb-4"
          />
          <h1 className="text-2xl font-bold text-[#39a67b]">SOMOS SIEMPRECLICK</h1>
          <p className="text-2xl font-bold">Bienvenid@!</p>
          <p className="text-gray-600 mt-1">Ingresa tu usuario para entrar a la App</p>
        </div>
        
        <Card className="shadow-lg rounded-xl">
          <CardContent className="p-6">
            <form onSubmit={handleLogin} className="space-y-4">
              <div className="space-y-2">
                <label htmlFor="email" className="text-sm font-medium text-gray-700">
                  Correo Electrónico
                </label>
                <Input
                  id="email"
                  type="text"
                  placeholder="Ingrese su correo electrónico"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </div>
              
              <div className="space-y-2">
                <label htmlFor="password" className="text-sm font-medium text-gray-700">
                  Contraseña
                </label>
                <Input
                  id="password"
                  type="password"
                  placeholder="Ingrese su contraseña"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
              </div>
              
              <div className="flex justify-between items-center">
                <div className="flex items-center">
                  <input
                    type="checkbox"
                    id="remember"
                    checked={remember}
                    onChange={(e) => setRemember(e.target.checked)}
                    className="mr-2"
                  />
                  <label htmlFor="remember" className="text-sm text-gray-600">
                    Recordarme
                  </label>
                </div>
                
                <button
                  type="button"
                  onClick={handleRecuperarContraseña}
                  className="text-sm font-semibold text-gray-800 hover:underline"
                >
                  Recuperar Contraseña
                </button>
              </div>
              
              <Button 
                type="submit" 
                className="w-full bg-[#FF5E00] hover:bg-[#f68712] text-white font-semibold rounded-full" 
                disabled={loading}
              >
                {loading ? "Iniciando sesión..." : "Ingresar"}
              </Button>
              
              <div className="text-center mt-4">
                <p className="text-gray-600 inline">¿No tienes Usuario? </p>
                <a href="/register" className="text-gray-800 font-semibold hover:underline">
                  Registrarme
                </a>
              </div>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Login;
