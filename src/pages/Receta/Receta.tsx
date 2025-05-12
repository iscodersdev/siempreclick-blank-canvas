
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { X, Receipt, Wallet, CreditCard } from "lucide-react";

interface Medicamento {
  nombre: string;
  cantidad: string;
}

const Receta = () => {
  const navigate = useNavigate();
  const [medicamentos] = useState<Medicamento[]>([
    { nombre: "Amoxicilina 500", cantidad: "Cantidad: 24 Comprimidos" },
    { nombre: "Diclofenac 700", cantidad: "Cantidad: 8 Comprimidos" },
  ]);
  
  // Format currency helper
  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('es-AR', {
      style: 'currency',
      currency: 'ARS',
    }).format(amount);
  };

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="bg-[#FF5E00] text-white">
        <div className="container px-4 py-6">
          <div className="flex justify-between items-start">
            <Button 
              variant="ghost" 
              className="text-white p-2 hover:bg-[#FF7E30]" 
              onClick={() => navigate(-1)}
            >
              <X className="h-5 w-5" />
            </Button>
            <img
              src="/assets/Images/logo3.png"
              alt="Logo"
              className="h-12 w-auto"
            />
          </div>
          
          <div className="mt-4 mb-10">
            <h1 className="text-2xl font-bold">Receta electrónica</h1>
            <div className="mt-2">
              <p className="flex">
                <span className="font-medium mr-1">Profesional:</span>
                <span className="italic">Dr. Jose Manuel Garcia</span>
              </p>
              <p className="flex">
                <span className="font-medium mr-1">Número:</span>
                <span className="italic">4912879121-0</span>
              </p>
            </div>
          </div>
        </div>
        {/* Wave effect at bottom of header */}
        <div className="h-6 bg-white rounded-t-3xl relative -mb-5"></div>
      </div>

      {/* Content */}
      <div className="flex-1 px-4">
        <h2 className="text-center text-xl font-bold text-[#FF5E00] mb-4">
          Prescripción
        </h2>
        
        <div className="mb-4">
          {medicamentos.map((med, index) => (
            <Card key={index} className="mb-3 shadow-lg rounded-xl">
              <CardContent className="p-4">
                <h3 className="text-lg font-bold">{med.nombre}</h3>
                <p className="text-gray-600">{med.cantidad}</p>
              </CardContent>
            </Card>
          ))}
        </div>

        <div className="flex justify-between items-center p-4 mb-4">
          <span className="text-xl font-bold">Total:</span>
          <span className="text-xl font-bold">{formatCurrency(10000)}</span>
        </div>

        <div className="space-y-3 mb-6">
          <Button
            variant="outline"
            className="w-full border-[#FF5E00] text-[#FF5E00] flex items-center"
          >
            <Receipt className="mr-2 h-5 w-5" />
            Pago Próximo de Haberes
          </Button>
          
          <Button
            variant="outline"
            className="w-full border-[#FF5E00] text-[#FF5E00] flex items-center"
          >
            <CreditCard className="mr-2 h-5 w-5" />
            Pago con Préstamo
          </Button>
          
          <Button
            variant="outline"
            className="w-full border-[#FF5E00] text-[#FF5E00] flex items-center"
          >
            <Wallet className="mr-2 h-5 w-5" />
            Pago con Billetera
          </Button>
        </div>
      </div>
    </div>
  );
};

export default Receta;
