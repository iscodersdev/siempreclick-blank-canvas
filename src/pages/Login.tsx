
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Login = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    
    // Simulate authentication - replace with actual auth later
    setTimeout(() => {
      setLoading(false);
      navigate("/home");
    }, 1000);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100 p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <img 
            src="/assets/Images/smart_logo.png" 
            alt="SiempreClick Logo" 
            className="h-16 mx-auto mb-4"
          />
          <h1 className="text-2xl font-bold text-gray-800">SiempreClick</h1>
          <p className="text-gray-600">Inicie sesión para continuar</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle className="text-center">Iniciar Sesión</CardTitle>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleLogin} className="space-y-4">
              <div className="space-y-2">
                <label htmlFor="email" className="text-sm font-medium text-gray-700">
                  Usuario
                </label>
                <Input
                  id="email"
                  type="text"
                  placeholder="Ingrese su usuario"
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
              
              <Button type="submit" className="w-full" disabled={loading}>
                {loading ? "Iniciando sesión..." : "Iniciar Sesión"}
              </Button>
              
              <div className="text-center mt-4">
                <a href="/register" className="text-sm text-blue-600 hover:underline">
                  ¿No tiene cuenta? Regístrese
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
