
import React, { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Check } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { getProducto } from "@/services/api";
import { useToast } from "@/components/ui/use-toast";

const CompraCuotas = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { toast } = useToast();
  const [cuotasSeleccionadas, setCuotasSeleccionadas] = useState(3);
  const [loading, setLoading] = useState(false);
  
  const { 
    data: producto,
    isLoading,
    error
  } = useQuery({
    queryKey: ['producto', id],
    queryFn: () => getProducto(Number(id)),
    enabled: !!id
  });

  const opcionesCuotas = [
    { cantidad: 3, interes: 1.15 },
    { cantidad: 6, interes: 1.25 },
    { cantidad: 12, interes: 1.40 },
    { cantidad: 18, interes: 1.55 }
  ];

  const cuotaSeleccionada = opcionesCuotas.find(
    opcion => opcion.cantidad === cuotasSeleccionadas
  );

  const precioTotal = producto?.Precio 
    ? producto.Precio * (cuotaSeleccionada?.interes || 1) 
    : 0;
    
  const valorCuota = precioTotal / (cuotaSeleccionada?.cantidad || 1);

  const handleSubmit = () => {
    setLoading(true);
    
    // Simulate API call
    setTimeout(() => {
      toast({
        title: "Compra realizada",
        description: `Has comprado ${producto?.Descripcion} en ${cuotasSeleccionadas} cuotas de $${valorCuota.toFixed(2)}`,
      });
      navigate("/miscompras");
      setLoading(false);
    }, 1500);
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-full">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (error || !producto) {
    return (
      <div className="p-4">
        <div className="flex items-center mb-4">
          <Button variant="ghost" onClick={() => navigate(-1)} className="p-2">
            <ArrowLeft className="h-5 w-5" />
          </Button>
          <h1 className="text-xl font-semibold ml-2">Financiar Compra</h1>
        </div>
        
        <Card>
          <CardContent className="p-6 text-center">
            <p className="text-red-500">No se pudo cargar la información del producto</p>
            <Button 
              variant="outline" 
              className="mt-4"
              onClick={() => navigate(-1)}
            >
              Volver
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="p-4">
      <div className="flex items-center mb-4">
        <Button variant="ghost" onClick={() => navigate(-1)} className="p-2">
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <h1 className="text-xl font-semibold ml-2">Financiar Compra</h1>
      </div>

      <div className="grid gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Resumen del Producto</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex items-center">
              <div className="h-16 w-16 bg-gray-100 rounded overflow-hidden mr-4">
                {producto.Foto ? (
                  <img 
                    src={`data:image/png;base64,${producto.Foto}`} 
                    alt={producto.Descripcion} 
                    className="h-full w-full object-cover"
                  />
                ) : (
                  <div className="h-full w-full bg-gray-200"></div>
                )}
              </div>
              
              <div className="flex-1">
                <h3 className="font-medium">{producto.Descripcion}</h3>
                <p className="text-sm text-gray-500">Precio: ${producto.Precio?.toLocaleString()}</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Seleccionar Cuotas</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {opcionesCuotas.map(opcion => {
                const total = producto.Precio * opcion.interes;
                const cuota = total / opcion.cantidad;
                
                return (
                  <div 
                    key={opcion.cantidad}
                    className={`border rounded-lg p-4 cursor-pointer transition-colors ${
                      cuotasSeleccionadas === opcion.cantidad 
                        ? 'border-primary bg-primary/5' 
                        : 'hover:bg-gray-50'
                    }`}
                    onClick={() => setCuotasSeleccionadas(opcion.cantidad)}
                  >
                    <div className="flex justify-between items-center mb-2">
                      <span className="font-medium">{opcion.cantidad} cuotas</span>
                      
                      {cuotasSeleccionadas === opcion.cantidad && (
                        <div className="h-5 w-5 bg-primary rounded-full flex items-center justify-center">
                          <Check className="h-3 w-3 text-white" />
                        </div>
                      )}
                    </div>
                    
                    <p className="text-lg font-bold">${cuota.toFixed(2)}/mes</p>
                    <p className="text-xs text-gray-500">
                      Total: ${total.toLocaleString()} 
                      <span className="ml-1">
                        (Interés: {((opcion.interes - 1) * 100).toFixed(0)}%)
                      </span>
                    </p>
                  </div>
                );
              })}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Resumen de la Financiación</CardTitle>
          </CardHeader>
          <CardContent>
            <dl className="grid grid-cols-2 gap-x-4 gap-y-2">
              <dt className="text-sm font-medium text-gray-500">Precio original:</dt>
              <dd className="text-sm font-semibold">${producto.Precio?.toLocaleString()}</dd>
              
              <dt className="text-sm font-medium text-gray-500">Cuotas:</dt>
              <dd className="text-sm">{cuotasSeleccionadas}</dd>
              
              <dt className="text-sm font-medium text-gray-500">Interés:</dt>
              <dd className="text-sm">
                {((cuotaSeleccionada?.interes || 1) - 1) * 100}%
              </dd>
              
              <dt className="text-sm font-medium text-gray-500">Total a pagar:</dt>
              <dd className="text-sm font-semibold">${precioTotal.toLocaleString()}</dd>
              
              <dt className="text-sm font-medium text-gray-500">Valor por cuota:</dt>
              <dd className="text-sm font-semibold">${valorCuota.toFixed(2)}</dd>
            </dl>
            
            <Button 
              className="w-full mt-6"
              onClick={handleSubmit}
              disabled={loading}
            >
              {loading ? (
                <>
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                  Procesando...
                </>
              ) : (
                'Confirmar Compra'
              )}
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default CompraCuotas;
