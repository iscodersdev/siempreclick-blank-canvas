
import React, { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Plus, Minus, ShoppingCart } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { getProducto } from "@/services/api";
import { useToast } from "@/components/ui/use-toast";

const VerProducto = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { toast } = useToast();
  const [cantidad, setCantidad] = useState(1);
  
  const { 
    data: producto,
    isLoading,
    error
  } = useQuery({
    queryKey: ['producto', id],
    queryFn: () => getProducto(Number(id)),
    enabled: !!id
  });

  const handleDecrementCantidad = () => {
    if (cantidad > 1) {
      setCantidad(prev => prev - 1);
    }
  };

  const handleIncrementCantidad = () => {
    setCantidad(prev => prev + 1);
  };

  const handleComprar = () => {
    // Mock purchase functionality
    toast({
      title: "Producto agregado",
      description: `${cantidad} ${cantidad > 1 ? 'unidades' : 'unidad'} de ${producto?.Descripcion} agregadas al carrito`,
    });
    
    // Navigate to checkout or cart page
    navigate(`/productos/${id}/compra`);
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
          <h1 className="text-xl font-semibold ml-2">Detalle del Producto</h1>
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

  const imagenes = [
    producto.Foto,
    producto.Foto1,
    producto.Foto2,
    producto.Foto3,
    producto.Foto4,
    producto.Foto5,
  ].filter(Boolean);

  return (
    <div className="p-4">
      <div className="flex items-center mb-4">
        <Button variant="ghost" onClick={() => navigate(-1)} className="p-2">
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <h1 className="text-xl font-semibold ml-2 truncate">
          {producto.Descripcion}
        </h1>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardContent className="p-0 overflow-hidden">
            <div className="aspect-square bg-gray-100 relative">
              {imagenes.length > 0 ? (
                <img 
                  src={`data:image/png;base64,${imagenes[0]}`} 
                  alt={producto.Descripcion} 
                  className="w-full h-full object-contain"
                />
              ) : (
                <div className="w-full h-full flex items-center justify-center">
                  <ShoppingCart className="h-16 w-16 text-gray-400" />
                </div>
              )}
            </div>
            
            {imagenes.length > 1 && (
              <div className="grid grid-cols-5 gap-1 p-1">
                {imagenes.slice(1).map((imagen, index) => (
                  <div 
                    key={index}
                    className="aspect-square bg-gray-100 cursor-pointer"
                  >
                    <img 
                      src={`data:image/png;base64,${imagen}`} 
                      alt={`${producto.Descripcion} ${index + 2}`}
                      className="w-full h-full object-cover"
                    />
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
        
        <div className="space-y-6">
          <Card>
            <CardContent className="p-6">
              <h2 className="text-2xl font-bold mb-2">{producto.Descripcion}</h2>
              <p className="text-3xl font-bold text-primary mb-4">
                ${producto.Precio?.toLocaleString()}
              </p>
              
              <div className="border-t border-b py-4 my-4">
                <p className="text-gray-700 whitespace-pre-line">
                  {producto.DescripcionAmpliada || 'Sin descripción adicional'}
                </p>
              </div>
              
              <div className="flex items-center mb-6">
                <span className="mr-4">Cantidad:</span>
                <div className="flex items-center border rounded-md">
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={handleDecrementCantidad}
                    disabled={cantidad <= 1}
                    className="h-10 w-10"
                  >
                    <Minus className="h-4 w-4" />
                  </Button>
                  
                  <span className="mx-4 w-6 text-center">{cantidad}</span>
                  
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={handleIncrementCantidad}
                    className="h-10 w-10"
                  >
                    <Plus className="h-4 w-4" />
                  </Button>
                </div>
              </div>
              
              <Button 
                className="w-full"
                onClick={handleComprar}
              >
                <ShoppingCart className="mr-2 h-4 w-4" />
                Comprar Ahora
              </Button>
            </CardContent>
          </Card>
          
          <Card>
            <CardContent className="p-6">
              <h3 className="font-semibold mb-2">Formas de pago disponibles</h3>
              <ul className="space-y-2">
                <li className="flex items-center">
                  <div className="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center mr-2">
                    <CreditCard className="h-4 w-4 text-blue-600" />
                  </div>
                  <span>Tarjeta de crédito</span>
                </li>
                <li className="flex items-center">
                  <div className="h-8 w-8 bg-green-100 rounded-full flex items-center justify-center mr-2">
                    <Wallet className="h-4 w-4 text-green-600" />
                  </div>
                  <span>Préstamos</span>
                </li>
              </ul>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
};

// Helper components to avoid importing more Lucide icons
const CreditCard = (props: any) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="24"
    height="24"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
    {...props}
  >
    <rect width="20" height="14" x="2" y="5" rx="2" />
    <line x1="2" x2="22" y1="10" y2="10" />
  </svg>
);

const Wallet = (props: any) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="24"
    height="24"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
    {...props}
  >
    <path d="M21 12V7H5a2 2 0 0 1 0-4h14v4" />
    <path d="M3 5v14a2 2 0 0 0 2 2h16v-5" />
    <path d="M18 12a2 2 0 0 0 0 4h4v-4Z" />
  </svg>
);

export default VerProducto;
