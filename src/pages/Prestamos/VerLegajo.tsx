
import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Download } from "lucide-react";
import { useToast } from "@/components/ui/use-toast";

const VerLegajo = () => {
  const [loading, setLoading] = useState(true);
  const [pdfUrl, setPdfUrl] = useState<string | null>(null);
  const [downloadUrl, setDownloadUrl] = useState<string | null>(null);
  const { id } = useParams();
  const navigate = useNavigate();
  const { toast } = useToast();

  useEffect(() => {
    const fetchLegajo = async () => {
      try {
        // In a real implementation, this would come from the prestamos API
        // Similar to PrestamosApi.dart's getLegajo method
        const user = JSON.parse(localStorage.getItem("user") || "{}");
        const uat = user.UAT;
        
        if (!uat || !id) {
          throw new Error("Falta información de usuario o préstamo");
        }

        // Mock implementation for now
        // In production this would call the real API endpoint
        const apiUrl = `http://portalsmartclick.com.ar/api/mprestamos/DescargaLegajoElectronico?uat=${uat}&PrestamoId=${id}`;
        
        // Simulate fetching the PDF data
        setTimeout(() => {
          // Mock data - in real implementation this would be actual PDF data
          const mockBase64Pdf = "base64pdfdata";
          
          // Create a blob from the base64 data
          const byteCharacters = atob(mockBase64Pdf);
          const byteArrays = [];
          for (let i = 0; i < byteCharacters.length; i++) {
            byteArrays.push(byteCharacters.charCodeAt(i));
          }
          const byteArray = new Uint8Array(byteArrays);
          const blob = new Blob([byteArray], { type: 'application/pdf' });
          
          // Create URL for the PDF viewer
          const url = URL.createObjectURL(blob);
          setPdfUrl(url);
          setDownloadUrl(apiUrl);
          setLoading(false);
        }, 1500);
      } catch (error) {
        console.error("Error fetching legajo:", error);
        toast({
          title: "Error",
          description: "No se pudo cargar el legajo electrónico",
          variant: "destructive",
        });
        setLoading(false);
      }
    };

    fetchLegajo();
  }, [id, toast]);

  return (
    <div className="h-full flex flex-col">
      <div className="flex items-center mb-4">
        <Button variant="ghost" onClick={() => navigate(-1)} className="p-2">
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <h1 className="text-xl font-semibold ml-2">Legajo Electrónico</h1>
      </div>

      {loading ? (
        <div className="flex-1 flex items-center justify-center">
          <div className="flex flex-col items-center">
            <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary mb-4"></div>
            <p className="text-gray-500">Cargando documento...</p>
          </div>
        </div>
      ) : (
        <Card className="flex-1 flex flex-col">
          <CardContent className="flex-1 p-0 relative">
            {pdfUrl ? (
              <iframe
                src={pdfUrl}
                className="w-full h-full min-h-[500px] border-none"
                title="PDF Viewer"
              />
            ) : (
              <div className="w-full h-full flex items-center justify-center">
                <p>No se pudo cargar el documento</p>
              </div>
            )}
          </CardContent>
        </Card>
      )}

      {downloadUrl && !loading && (
        <div className="mt-4 flex justify-center">
          <Button onClick={() => window.open(downloadUrl, "_blank")}>
            <Download className="mr-2 h-4 w-4" /> 
            Descargar Documento
          </Button>
        </div>
      )}
    </div>
  );
};

export default VerLegajo;
