
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { toast } from "sonner";
import { useAuth } from "@/contexts/AuthContext";
import { Eye, EyeOff } from "lucide-react";
import { recuperarContraseña } from "@/services/api";

const Login = () => {
  const navigate = useNavigate();
  const { login } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [remember, setRemember] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!email || !password) {
      toast.error("Por favor complete todos los campos");
      return;
    }
    
    setLoading(true);
    
    try {
      // Store the remember me setting in localStorage
      localStorage.setItem("rememberUser", remember ? "true" : "false");
      
      await login(email, password);
      navigate("/home");
    } catch (error) {
      console.error("Login error:", error);
      // Error toast is already shown in the AuthContext
    } finally {
      setLoading(false);
    }
  };

  const handleRecuperarContraseña = async () => {
    if (!email) {
      toast.error("Debe ingresar un Correo Electrónico para Recuperar Contraseña");
      return;
    }

    try {
      setLoading(true);
      await recuperarContraseña(email);
      toast.success("Se ha enviado un correo para recuperar su contraseña");
    } catch (error) {
      console.error("Password recovery error:", error);
      toast.error("No se pudo procesar su solicitud de recuperación de contraseña");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col bg-white">
      {/* Green background section with logo */}
      <div className="bg-[#39a67b] h-64 flex items-center justify-center relative">
        <img 
          src="/assets/Images/siempreclickLogo.png" 
          alt="SiempreClick Logo" 
          className="h-28 absolute"
          style={{ top: '50px' }}
        />
      </div>
      
      {/* White rounded card section */}
      <div className="flex-grow bg-white rounded-t-3xl -mt-10 px-6 pt-8 pb-4">
        <div className="max-w-md mx-auto">
          <h1 className="text-lg font-bold text-[#39a67b] mb-1">SOMOS SIEMPRECLICK</h1>
          <h2 className="text-3xl font-bold mb-1">Bienvenid@!</h2>
          <p className="text-gray-600 mb-8">Ingresa tu usuario para entrar a la App</p>
          
          {loading ? (
            <div className="flex flex-col items-center justify-center py-12">
              <div className="w-12 h-12 rounded-full border-4 border-[#39a67b] border-t-transparent animate-spin mb-4"></div>
              <p className="text-gray-500">Aguarde por favor...</p>
            </div>
          ) : (
            <Card className="shadow-none border-none">
              <CardContent className="p-0">
                <form onSubmit={handleLogin} className="space-y-6">
                  <div>
                    <div className="flex items-center border-b border-gray-300 py-2">
                      <span className="text-gray-500 mr-3">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                          <rect width="20" height="16" x="2" y="4" rx="2" />
                          <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
                        </svg>
                      </span>
                      <Input
                        id="email"
                        type="text"
                        placeholder="Correo Electrónico"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        className="border-none focus-visible:ring-0 text-base"
                        required
                      />
                    </div>
                  </div>
                  
                  <div>
                    <div className="flex items-center border-b border-gray-300 py-2 relative">
                      <span className="text-gray-500 mr-3">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                          <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                          <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                        </svg>
                      </span>
                      <Input
                        id="password"
                        type={showPassword ? "text" : "password"}
                        placeholder="Contraseña"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        className="border-none focus-visible:ring-0 text-base pr-10"
                        required
                      />
                      <button 
                        type="button"
                        className="absolute right-2 text-gray-500"
                        onClick={() => setShowPassword(!showPassword)}
                      >
                        {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                      </button>
                    </div>
                  </div>
                  
                  <div className="flex justify-between items-center">
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        id="remember"
                        checked={remember}
                        onChange={(e) => setRemember(e.target.checked)}
                        className="mr-2 h-4 w-4 rounded border-gray-300 text-[#39a67b] focus:ring-[#39a67b]"
                      />
                      <label htmlFor="remember" className="text-gray-600 select-none">
                        Recordarme
                      </label>
                    </div>
                    
                    <button
                      type="button"
                      onClick={handleRecuperarContraseña}
                      className="text-gray-800 font-semibold hover:underline text-sm"
                    >
                      Recuperar Contraseña
                    </button>
                  </div>
                  
                  <Button 
                    type="submit" 
                    className="w-full bg-transparent text-[#f68712] hover:bg-transparent border border-[#f68712] rounded-full font-bold py-6"
                    disabled={loading}
                  >
                    Ingresar
                  </Button>
                  
                  <div className="text-center">
                    <div className="flex justify-center items-center gap-1">
                      <span className="text-gray-600">¿No tienes Usuario?</span>
                      <a href="/register" className="text-gray-800 font-semibold hover:underline">
                        Registrarme
                      </a>
                    </div>
                  </div>
                </form>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
};

export default Login;
