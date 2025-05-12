
import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { X } from "lucide-react";
import QRCode from "react-qr-code";

const RecibirDinero = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [showQR, setShowQR] = useState(false);
  const [cvuData, setCvuData] = useState<{ CVU: string } | null>(null);

  useEffect(() => {
    const fetchCVU = async () => {
      try {
        // In a real implementation, this would call the actual API
        // Similar to the GetCVU function in BilleteraApi.dart
        const user = JSON.parse(localStorage.getItem("user") || "{}");
        
        // Simulate API call
        setTimeout(() => {
          // Mock CVU data
          setCvuData({ CVU: "0000000000000000000000" });
          setLoading(false);
        }, 1000);
      } catch (error) {
        console.error("Error fetching CVU:", error);
        setLoading(false);
      }
    };

    fetchCVU();
  }, []);

  const handleGenerateQR = () => {
    setLoading(true);
    // Simulate loading
    setTimeout(() => {
      setShowQR(true);
      setLoading(false);
    }, 1000);
  };

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="bg-[#f68712] text-white py-12 relative">
        <Button 
          variant="ghost" 
          className="absolute top-4 left-4 text-white p-2 hover:bg-[#f79a3a]"
          onClick={() => navigate(-1)}
        >
          <X className="h-6 w-6" />
        </Button>
        
        <div className="text-center mt-8">
          <h1 className="text-3xl font-bold">Recibir Dinero</h1>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 p-6">
        {loading ? (
          <div className="h-full flex items-center justify-center">
            <div className="flex flex-col items-center">
              <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary mb-4"></div>
              <p className="text-gray-500">Cargando...</p>
            </div>
          </div>
        ) : showQR ? (
          <div className="flex flex-col items-center mt-10">
            <p className="text-xl mb-10">Codigo QR generado con exito!</p>
            
            <div className="bg-[#e3e8ff] w-full max-w-md rounded-xl p-6">
              <div className="bg-white rounded-xl p-4 mb-4 flex justify-center">
                {cvuData && (
                  <QRCode 
                    value={cvuData.CVU} 
                    size={200} 
                    style={{ height: "auto", maxWidth: "100%", width: "200px" }}
                  />
                )}
              </div>
              
              {cvuData && (
                <p className="text-center text-gray-600">CVU: {cvuData.CVU}</p>
              )}
            </div>
          </div>
        ) : (
          <div className="flex flex-col items-center mt-10">
            <p className="text-xl mb-10">Seleccione el metodo de pago:</p>
            
            <div className="bg-[#e3e8ff] w-full max-w-md rounded-xl p-8">
              <div className="grid grid-cols-2 gap-6">
                <div className="flex flex-col items-center">
                  <button 
                    onClick={handleGenerateQR}
                    className="h-20 w-20 bg-white rounded-xl flex items-center justify-center mb-2"
                  >
                    <svg 
                      xmlns="http://www.w3.org/2000/svg" 
                      fill="none" 
                      viewBox="0 0 24 24" 
                      stroke="currentColor" 
                      className="h-12 w-12 text-[#3375bb]"
                    >
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1v-2a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1z" />
                    </svg>
                  </button>
                  <p className="text-gray-600">Generar QR</p>
                </div>
                
                <div className="flex flex-col items-center">
                  <button className="h-20 w-20 bg-white rounded-xl flex items-center justify-center mb-2">
                    <svg 
                      xmlns="http://www.w3.org/2000/svg" 
                      fill="none" 
                      viewBox="0 0 24 24" 
                      stroke="currentColor" 
                      className="h-12 w-12 text-[#3375bb]"
                    >
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
                    </svg>
                  </button>
                  <p className="text-gray-600">Link de Pago</p>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default RecibirDinero;
