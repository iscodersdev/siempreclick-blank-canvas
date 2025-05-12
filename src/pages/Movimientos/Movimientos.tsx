
import React, { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { useQuery } from "@tanstack/react-query";
import { getMovimientos } from "@/services/api";
import { ArrowUpRight, ArrowDownRight, Search } from "lucide-react";
import { Input } from "@/components/ui/input";

const Movimientos = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const { data: movimientos, isLoading, error } = useQuery({
    queryKey: ['movimientos'],
    queryFn: getMovimientos,
  });

  const filteredMovimientos = movimientos?.filter((mov: any) => 
    mov.TipoMovimiento?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const formatDate = (dateString?: string) => {
    if (!dateString) return "";
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('es-AR', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date);
  };

  const getMovementIcon = (tipo?: string) => {
    if (!tipo) return <ArrowUpRight className="h-5 w-5 text-green-500" />;
    
    const tipoLower = tipo.toLowerCase();
    
    if (tipoLower.includes('ingreso') || tipoLower.includes('recibido')) {
      return <ArrowDownRight className="h-5 w-5 text-green-500" />;
    } else {
      return <ArrowUpRight className="h-5 w-5 text-red-500" />;
    }
  };

  return (
    <div className="container mx-auto p-4">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
        <h1 className="text-2xl font-bold">Movimientos</h1>
        
        <div className="relative w-full md:w-auto">
          <Search className="absolute left-2 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
          <Input
            type="text"
            placeholder="Buscar movimientos"
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
            <p className="text-red-500">Error al cargar los movimientos</p>
            <Button 
              variant="outline" 
              className="mt-4"
              onClick={() => window.location.reload()}
            >
              Reintentar
            </Button>
          </CardContent>
        </Card>
      ) : filteredMovimientos && filteredMovimientos.length > 0 ? (
        <Card>
          <CardHeader>
            <CardTitle>Historial de movimientos</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="divide-y">
              {filteredMovimientos.map((movimiento: any, index: number) => (
                <div key={index} className="py-4 flex items-center">
                  <div className="mr-4">
                    <div className="h-10 w-10 rounded-full bg-gray-100 flex items-center justify-center">
                      {getMovementIcon(movimiento.TipoMovimiento)}
                    </div>
                  </div>
                  <div className="flex-1">
                    <h3 className="font-medium">{movimiento.TipoMovimiento || "Movimiento"}</h3>
                    <p className="text-sm text-gray-500">{formatDate(movimiento.Fecha)}</p>
                  </div>
                  <div>
                    <span className={`font-bold ${
                      movimiento.TipoMovimiento?.toLowerCase().includes("ingreso") 
                        ? "text-green-600" 
                        : "text-red-600"
                    }`}>
                      {movimiento.TipoMovimiento?.toLowerCase().includes("ingreso") ? "+" : "-"}
                      ${movimiento.Monto?.toLocaleString() || "0"}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      ) : (
        <Card>
          <CardContent className="py-8 text-center">
            <Search className="h-12 w-12 mx-auto mb-4 text-gray-400" />
            <h3 className="text-xl font-medium mb-2">No se encontraron movimientos</h3>
            <p className="text-gray-500">
              {searchTerm 
                ? "No hay resultados para tu búsqueda" 
                : "Aún no tienes movimientos en tu cuenta"}
            </p>
          </CardContent>
        </Card>
      )}
    </div>
  );
};

export default Movimientos;
