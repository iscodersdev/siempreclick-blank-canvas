
import React, { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { getProveedores } from "@/services/api";
import { Search, Package } from "lucide-react";

const Proveedores = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  
  const { data: proveedores, isLoading, error } = useQuery({
    queryKey: ['proveedores'],
    queryFn: getProveedores,
  });

  const filteredProveedores = proveedores?.filter((prov: any) => 
    prov.Nombre?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    prov.RazonSocial?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handleViewProveedor = (id: number) => {
    navigate(`/proveedores/${id}`);
  };

  return (
    <div className="container mx-auto p-4">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
        <h1 className="text-2xl font-bold">Proveedores</h1>
        
        <div className="relative w-full md:w-auto">
          <Search className="absolute left-2 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
          <Input
            type="text"
            placeholder="Buscar proveedores"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-8 w-full md:w-[250px]"
          />
        </div>
      </div>

      {isLoading ? (
        <div className="flex justify-center my-8">
          <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
        </div>
      ) : error ? (
        <Card>
          <CardContent className="p-6 text-center">
            <p className="text-red-500">Error al cargar los proveedores</p>
            <Button 
              variant="outline" 
              className="mt-4"
              onClick={() => window.location.reload()}
            >
              Reintentar
            </Button>
          </CardContent>
        </Card>
      ) : filteredProveedores && filteredProveedores.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {filteredProveedores.map((proveedor: any) => (
            <Card 
              key={proveedor.Id} 
              className="hover:shadow-md transition-shadow cursor-pointer"
              onClick={() => handleViewProveedor(proveedor.Id)}
            >
              <CardContent className="p-4">
                <div className="flex items-center">
                  <div className="h-12 w-12 rounded-full bg-gray-200 mr-3 overflow-hidden flex-shrink-0">
                    {proveedor.Foto ? (
                      <img 
                        src={`data:image/png;base64,${proveedor.Foto}`} 
                        alt={proveedor.Nombre} 
                        className="h-full w-full object-cover"
                      />
                    ) : (
                      <div className="h-full w-full flex items-center justify-center bg-gray-200">
                        <Package className="h-6 w-6 text-gray-500" />
                      </div>
                    )}
                  </div>
                  <div>
                    <h3 className="font-medium">{proveedor.Nombre}</h3>
                    <p className="text-sm text-gray-500">{proveedor.RazonSocial}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        <Card>
          <CardContent className="py-8 text-center">
            <Package className="h-12 w-12 mx-auto mb-4 text-gray-400" />
            <h3 className="text-xl font-medium mb-2">No se encontraron proveedores</h3>
            <p className="text-gray-500">
              {searchTerm 
                ? "No hay resultados para tu búsqueda" 
                : "No hay proveedores disponibles en este momento"}
            </p>
          </CardContent>
        </Card>
      )}
    </div>
  );
};

export default Proveedores;
