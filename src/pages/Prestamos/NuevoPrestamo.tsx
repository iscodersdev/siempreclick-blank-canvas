
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ArrowLeft, Check, X } from "lucide-react";
import { useToast } from "@/components/ui/use-toast";
import { solicitarPrestamo } from "@/services/api";

const NuevoPrestamo = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    monto: "",
    cuotas: "12",
    motivo: ""
  });
  const [step, setStep] = useState(1);

  // Cuota calculation simulation
  const calculatedCuota = formData.monto && formData.cuotas 
    ? (Number(formData.monto) / Number(formData.cuotas) * 1.25).toFixed(2)
    : "0.00";

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleContinue = () => {
    if (!formData.monto || Number(formData.monto) <= 0) {
      toast({
        title: "Error",
        description: "Por favor ingresa un monto válido",
        variant: "destructive",
      });
      return;
    }
    
    setStep(2);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    
    try {
      // In a real app this would call the API
      await solicitarPrestamo({
        Monto: Number(formData.monto),
        CantidadCuotas: Number(formData.cuotas),
        Motivo: formData.motivo
      });
      
      toast({
        title: "Solicitud enviada",
        description: "Tu solicitud de préstamo ha sido enviada correctamente",
      });
      
      navigate("/prestamos");
    } catch (error) {
      console.error("Error soliciting loan:", error);
      toast({
        title: "Error",
        description: "No se pudo procesar la solicitud. Intenta nuevamente más tarde.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  const handleBack = () => {
    if (step > 1) {
      setStep(step - 1);
    } else {
      navigate(-1);
    }
  };

  return (
    <div className="p-4">
      <div className="flex items-center mb-4">
        <Button variant="ghost" onClick={handleBack} className="p-2">
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <h1 className="text-xl font-semibold ml-2">Solicitar Préstamo</h1>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>
            {step === 1 ? "Información del Préstamo" : "Confirmar Solicitud"}
          </CardTitle>
        </CardHeader>
        <CardContent>
          {step === 1 ? (
            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="monto">Monto a solicitar</Label>
                <div className="relative">
                  <span className="absolute left-3 top-1/2 transform -translate-y-1/2">$</span>
                  <Input
                    id="monto"
                    name="monto"
                    type="number"
                    placeholder="10000"
                    className="pl-7"
                    value={formData.monto}
                    onChange={handleChange}
                  />
                </div>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="cuotas">Cantidad de cuotas</Label>
                <select
                  id="cuotas"
                  name="cuotas"
                  value={formData.cuotas}
                  onChange={handleChange}
                  className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                >
                  <option value="3">3 cuotas</option>
                  <option value="6">6 cuotas</option>
                  <option value="12">12 cuotas</option>
                  <option value="18">18 cuotas</option>
                  <option value="24">24 cuotas</option>
                </select>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="motivo">Motivo del préstamo</Label>
                <Input
                  id="motivo"
                  name="motivo"
                  placeholder="Ingrese el motivo (opcional)"
                  value={formData.motivo}
                  onChange={handleChange}
                />
              </div>
              
              <Button 
                onClick={handleContinue} 
                className="w-full mt-4"
                disabled={!formData.monto || Number(formData.monto) <= 0}
              >
                Continuar
              </Button>
            </div>
          ) : (
            <div className="space-y-6">
              <div className="space-y-4">
                <dl className="grid grid-cols-2 gap-x-4 gap-y-2">
                  <dt className="text-sm font-medium text-gray-500">Monto solicitado:</dt>
                  <dd className="text-sm font-semibold">${Number(formData.monto).toLocaleString()}</dd>
                  
                  <dt className="text-sm font-medium text-gray-500">Cuotas:</dt>
                  <dd className="text-sm">{formData.cuotas}</dd>
                  
                  <dt className="text-sm font-medium text-gray-500">Valor de cuota:</dt>
                  <dd className="text-sm font-semibold">${calculatedCuota}</dd>
                  
                  <dt className="text-sm font-medium text-gray-500">Total a pagar:</dt>
                  <dd className="text-sm font-semibold">
                    ${(Number(calculatedCuota) * Number(formData.cuotas)).toFixed(2)}
                  </dd>
                </dl>
              </div>
              
              <div className="flex flex-col space-y-2">
                <Button 
                  onClick={handleSubmit} 
                  className="w-full"
                  disabled={loading}
                >
                  {loading ? (
                    <>
                      <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                      Procesando...
                    </>
                  ) : (
                    <>
                      <Check className="mr-2 h-4 w-4" />
                      Confirmar y Enviar
                    </>
                  )}
                </Button>
                
                <Button 
                  variant="outline" 
                  onClick={handleBack}
                  disabled={loading}
                >
                  <X className="mr-2 h-4 w-4" />
                  Cancelar
                </Button>
              </div>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
};

export default NuevoPrestamo;
