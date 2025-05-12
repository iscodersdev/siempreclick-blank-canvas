
import React from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Package } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { getProveedor, getProductos } from "@/services/api";

const VerProveedor = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  
  const { 
    data: proveedor,
    isLoading: loadingProveedor,
    error: errorProveedor 
  } = useQuery({
    queryKey: ['proveedor', id],
    queryFn: () => getProveedor(Number(id)),
    enabled: !!id
  });

  const { 
    data: productos,
    isLoading: loadingProductos,
    error: errorProductos 
  } = useQuery({
    queryKey: ['productos'],
    queryFn: getProductos,
    enabled: !!id
  });

  // Filter products if we had a relationship between providers and products
  // For now, we're just showing all products
  const proveedorProductos = productos || [];

  const isLoading = loadingProveedor || loadingProductos;
  const hasError = errorProveedor || errorProductos;

  const handleViewProduct = (productId: number) => {
    navigate(`/productos/${productId}`);
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-full">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (hasError || !proveedor) {
    return (
      <div className="p-4">
        <div className="flex items-center mb-4">
          <Button variant="ghost" onClick={() => navigate(-1)} className="p-2">
            <ArrowLeft className="h-5 w-5" />
          </Button>
          <h1 className="text-xl font-semibold ml-2">Detalle del Proveedor</h1>
        </div>
        
        <Card>
          <CardContent className="p-6 text-center">
            <p className="text-red-500">No se pudo cargar la información del proveedor</p>
            <Button 
              variant="outline" 
              className="mt-4"
              onClick={() => navigate("/proveedores")}
            >
              Volver a Proveedores
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
        <h1 className="text-xl font-semibold ml-2">{proveedor.Nombre}</h1>
      </div>

      <div className="grid gap-6">
        <Card>
          <CardContent className="p-6">
            <div className="flex flex-col md:flex-row md:items-center gap-6">
              <div className="w-24 h-24 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 mx-auto md:mx-0">
                {proveedor.Foto ? (
                  <img 
                    src={`data:image/png;base64,${proveedor.Foto}`} 
                    alt={proveedor.Nombre} 
                    className="h-full w-full object-cover"
                  />
                ) : (
                  <div className="h-full w-full flex items-center justify-center bg-gray-200">
                    <Package className="h-12 w-12 text-gray-500" />
                  </div>
                )}
              </div>
              
              <div className="flex-1">
                <h2 className="text-xl font-bold text-center md:text-left">{proveedor.Nombre}</h2>
                <p className="text-gray-500 mb-4 text-center md:text-left">{proveedor.RazonSocial}</p>
                
                <dl className="grid grid-cols-1 md:grid-cols-2 gap-y-2 gap-x-4">
                  <dt className="text-sm font-medium text-gray-500">CUIT:</dt>
                  <dd className="text-sm">{proveedor.CUIT || '-'}</dd>
                  
                  <dt className="text-sm font-medium text-gray-500">Domicilio:</dt>
                  <dd className="text-sm">{proveedor.Domicilio || '-'}</dd>
                </dl>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Productos Disponibles</CardTitle>
          </CardHeader>
          <CardContent>
            {proveedorProductos.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
                {proveedorProductos.map((producto: any) => (
                  <Card 
                    key={producto.Id} 
                    className="hover:shadow-md transition-shadow cursor-pointer overflow-hidden"
                    onClick={() => handleViewProduct(producto.Id)}
                  >
                    <div className="aspect-[4/3] bg-gray-100 relative">
                      {producto.Foto ? (
                        <img 
                          src={`data:image/png;base64,${producto.Foto}`} 
                          alt={producto.Descripcion} 
                          className="w-full h-full object-cover"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center">
                          <Package className="h-12 w-12 text-gray-400" />
                        </div>
                      )}
                    </div>
                    <CardContent className="p-3">
                      <h3 className="font-medium truncate">{producto.Descripcion}</h3>
                      <p className="text-sm text-gray-500 line-clamp-2">
                        {producto.DescripcionAmpliada || 'Sin descripción adicional'}
                      </p>
                      <p className="font-bold mt-2">${producto.Precio?.toLocaleString()}</p>
                    </CardContent>
                  </Card>
                ))}
              </div>
            ) : (
              <div className="text-center py-6">
                <p className="text-gray-500">Este proveedor no tiene productos disponibles</p>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default VerProveedor;
