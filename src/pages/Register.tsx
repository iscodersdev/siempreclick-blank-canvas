
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Register = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    nombre: "",
    apellido: "",
    email: "",
    telefono: "",
    password: "",
    confirmPassword: ""
  });
  const [loading, setLoading] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleRegister = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    
    // Simulate registration - replace with actual registration later
    setTimeout(() => {
      setLoading(false);
      navigate("/");
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
          <p className="text-gray-600">Cree su cuenta para continuar</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle className="text-center">Registro</CardTitle>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleRegister} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label htmlFor="nombre" className="text-sm font-medium text-gray-700">
                    Nombre
                  </label>
                  <Input
                    id="nombre"
                    name="nombre"
                    type="text"
                    placeholder="Nombre"
                    value={formData.nombre}
                    onChange={handleChange}
                    required
                  />
                </div>
                
                <div className="space-y-2">
                  <label htmlFor="apellido" className="text-sm font-medium text-gray-700">
                    Apellido
                  </label>
                  <Input
                    id="apellido"
                    name="apellido"
                    type="text"
                    placeholder="Apellido"
                    value={formData.apellido}
                    onChange={handleChange}
                    required
                  />
                </div>
              </div>
              
              <div className="space-y-2">
                <label htmlFor="email" className="text-sm font-medium text-gray-700">
                  Email
                </label>
                <Input
                  id="email"
                  name="email"
                  type="email"
                  placeholder="Email"
                  value={formData.email}
                  onChange={handleChange}
                  required
                />
              </div>
              
              <div className="space-y-2">
                <label htmlFor="telefono" className="text-sm font-medium text-gray-700">
                  Teléfono
                </label>
                <Input
                  id="telefono"
                  name="telefono"
                  type="tel"
                  placeholder="Teléfono"
                  value={formData.telefono}
                  onChange={handleChange}
                  required
                />
              </div>
              
              <div className="space-y-2">
                <label htmlFor="password" className="text-sm font-medium text-gray-700">
                  Contraseña
                </label>
                <Input
                  id="password"
                  name="password"
                  type="password"
                  placeholder="Contraseña"
                  value={formData.password}
                  onChange={handleChange}
                  required
                />
              </div>
              
              <div className="space-y-2">
                <label htmlFor="confirmPassword" className="text-sm font-medium text-gray-700">
                  Confirmar Contraseña
                </label>
                <Input
                  id="confirmPassword"
                  name="confirmPassword"
                  type="password"
                  placeholder="Confirmar Contraseña"
                  value={formData.confirmPassword}
                  onChange={handleChange}
                  required
                />
              </div>
              
              <Button type="submit" className="w-full" disabled={loading}>
                {loading ? "Registrando..." : "Registrarse"}
              </Button>
              
              <div className="text-center mt-4">
                <a href="/" className="text-sm text-blue-600 hover:underline">
                  ¿Ya tiene cuenta? Inicie sesión
                </a>
              </div>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Register;
