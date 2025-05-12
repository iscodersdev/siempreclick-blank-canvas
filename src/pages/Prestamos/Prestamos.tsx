
import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { CreditCard, ChevronRight, Plus } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { getPrestamos } from "@/services/api";
import { useToast } from "@/components/ui/use-toast";

const Prestamos = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const { data: prestamos, isLoading, error } = useQuery({
    queryKey: ['prestamos'],
    queryFn: getPrestamos,
  });

  useEffect(() => {
    if (error) {
      toast({
        title: "Error",
        description: "No se pudieron cargar los préstamos",
        variant: "destructive",
      });
    }
  }, [error, toast]);

  const handleNewLoan = () => {
    navigate("/prestamos/nuevo");
  };

  const handleViewLoan = (id: number) => {
    navigate(`/prestamos/${id}`);
  };

  return (
    <div className="container mx-auto p-4">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Mis Préstamos</h1>
        <Button onClick={handleNewLoan}>
          <Plus className="mr-2 h-4 w-4" /> Nuevo Préstamo
        </Button>
      </div>

      {isLoading ? (
        <div className="flex justify-center my-8">
          <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
        </div>
      ) : error ? (
        <Card>
          <CardContent className="p-6 text-center">
            <p className="text-red-500">Error al cargar los préstamos</p>
            <Button 
              variant="outline" 
              className="mt-4"
              onClick={() => window.location.reload()}
            >
              Reintentar
            </Button>
          </CardContent>
        </Card>
      ) : prestamos && prestamos.length > 0 ? (
        <div className="grid gap-4">
          {prestamos.map((prestamo: any) => (
            <Card key={prestamo.Id} className="hover:shadow-md transition-shadow">
              <CardContent className="p-0">
                <div 
                  className="p-4 flex items-center cursor-pointer" 
                  onClick={() => handleViewLoan(prestamo.Id)}
                >
                  <div className="bg-blue-100 p-3 rounded-full mr-4">
                    <CreditCard className="h-6 w-6 text-blue-600" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold">Préstamo #{prestamo.Id}</h3>
                    <p className="text-sm text-gray-500">
                      {new Date(prestamo.FechaOtorgamiento).toLocaleDateString()}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-lg">
                      ${prestamo.MontoTotal.toLocaleString()}
                    </p>
                    <p className="text-xs text-gray-500">
                      {prestamo.CantidadCuotas} cuotas
                    </p>
                  </div>
                  <ChevronRight className="ml-2 h-5 w-5 text-gray-400" />
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        <Card>
          <CardContent className="py-8 text-center">
            <CreditCard className="h-12 w-12 mx-auto mb-4 text-gray-400" />
            <h3 className="text-xl font-medium mb-2">No tienes préstamos activos</h3>
            <p className="text-gray-500 mb-4">Solicita tu primer préstamo ahora</p>
            <Button onClick={handleNewLoan}>
              Solicitar Préstamo
            </Button>
          </CardContent>
        </Card>
      )}
    </div>
  );
};

export default Prestamos;
