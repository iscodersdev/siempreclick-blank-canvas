
import React, { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft, FileText, Download } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { getPrestamo } from "@/services/api";
import { useToast } from "@/components/ui/use-toast";

const VerPrestamo = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const { data: prestamo, isLoading, error } = useQuery({
    queryKey: ['prestamo', id],
    queryFn: () => getPrestamo(Number(id)),
    enabled: !!id,
  });

  const handleViewLegajo = () => {
    navigate(`/prestamos/${id}/legajo`);
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-full">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (error || !prestamo) {
    return (
      <div className="p-4">
        <div className="flex items-center mb-4">
          <Button variant="ghost" onClick={() => navigate(-1)} className="p-2">
            <ArrowLeft className="h-5 w-5" />
          </Button>
          <h1 className="text-xl font-semibold ml-2">Detalle del Préstamo</h1>
        </div>
        
        <Card>
          <CardContent className="p-6 text-center">
            <p className="text-red-500">No se pudo cargar el préstamo</p>
            <Button 
              variant="outline" 
              className="mt-4"
              onClick={() => navigate("/prestamos")}
            >
              Volver a Préstamos
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
        <h1 className="text-xl font-semibold ml-2">Detalle del Préstamo #{id}</h1>
      </div>

      <div className="grid gap-4">
        <Card>
          <CardHeader>
            <CardTitle>Información General</CardTitle>
          </CardHeader>
          <CardContent>
            <dl className="grid grid-cols-2 gap-x-4 gap-y-2">
              <dt className="text-sm font-medium text-gray-500">Monto Total:</dt>
              <dd className="text-sm font-semibold">${prestamo.MontoTotal?.toLocaleString()}</dd>
              
              <dt className="text-sm font-medium text-gray-500">Fecha de Otorgamiento:</dt>
              <dd className="text-sm">
                {new Date(prestamo.FechaOtorgamiento).toLocaleDateString()}
              </dd>
              
              <dt className="text-sm font-medium text-gray-500">Cuotas:</dt>
              <dd className="text-sm">{prestamo.CantidadCuotas}</dd>
              
              <dt className="text-sm font-medium text-gray-500">Valor Cuota:</dt>
              <dd className="text-sm font-semibold">${prestamo.MontoCuota?.toLocaleString()}</dd>
              
              <dt className="text-sm font-medium text-gray-500">Estado:</dt>
              <dd className="text-sm">
                <span className={`inline-block px-2 py-1 rounded-full text-xs font-medium ${
                  prestamo.Estado === "Aprobado" ? "bg-green-100 text-green-800" : 
                  prestamo.Estado === "Pendiente" ? "bg-yellow-100 text-yellow-800" : 
                  "bg-red-100 text-red-800"
                }`}>
                  {prestamo.Estado}
                </span>
              </dd>
            </dl>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader>
            <CardTitle>Cuotas</CardTitle>
          </CardHeader>
          <CardContent>
            {prestamo.Cuotas && prestamo.Cuotas.length > 0 ? (
              <div className="divide-y">
                {prestamo.Cuotas.map((cuota: any, index: number) => (
                  <div key={index} className="py-3 flex justify-between items-center">
                    <div>
                      <p className="font-medium">Cuota {cuota.NumeroCuota}</p>
                      <p className="text-sm text-gray-500">
                        Vencimiento: {new Date(cuota.FechaVencimiento).toLocaleDateString()}
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="font-bold">${cuota.Monto.toLocaleString()}</p>
                      <p className={`text-xs ${
                        cuota.Estado === "Pagada" ? "text-green-600" : 
                        cuota.Estado === "Pendiente" ? "text-yellow-600" : 
                        "text-red-600"
                      }`}>
                        {cuota.Estado}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-center text-gray-500 py-4">No hay información de cuotas disponible</p>
            )}
          </CardContent>
        </Card>
        
        <div className="flex space-x-4 mt-2">
          <Button 
            variant="outline" 
            className="flex-1"
            onClick={handleViewLegajo}
          >
            <FileText className="mr-2 h-4 w-4" />
            Ver Legajo Electrónico
          </Button>
          
          <Button className="flex-1">
            <Download className="mr-2 h-4 w-4" />
            Descargar Comprobante
          </Button>
        </div>
      </div>
    </div>
  );
};

export default VerPrestamo;
