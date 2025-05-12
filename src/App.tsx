import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider, useAuth } from "./contexts/AuthContext";

// Layouts
import MainLayout from "./components/Layout/MainLayout";

// Pages
import Login from "./pages/Login";
import Register from "./pages/Register";
import Home from "./pages/Home";
import NotFound from "./pages/NotFound";
import Movimientos from "./pages/Movimientos/Movimientos";
import Prestamos from "./pages/Prestamos/Prestamos";
import VerPrestamo from "./pages/Prestamos/VerPrestamo";
import VerLegajo from "./pages/Prestamos/VerLegajo";
import NuevoPrestamo from "./pages/Prestamos/NuevoPrestamo";
import Proveedores from "./pages/Proveedores/Proveedores";
import VerProveedor from "./pages/Proveedores/VerProveedor";
import VerProducto from "./pages/Productos/VerProducto";
import CompraCuotas from "./pages/Productos/CompraCuotas";
import RecibirDinero from "./pages/RecibirDinero/RecibirDinero";
import Receta from "./pages/Receta/Receta";

const queryClient = new QueryClient();

// Protected route component
const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const { isAuthenticated, loading } = useAuth();

  if (loading) {
    return <div>Loading...</div>;
  }

  if (!isAuthenticated) {
    return <Navigate to="/" replace />;
  }

  return <>{children}</>;
};

const AppRoutes = () => {
  return (
    <Routes>
      <Route path="/" element={<Login />} />
      <Route path="/register" element={<Register />} />
      
      {/* Protected Routes */}
      <Route path="/" element={
        <ProtectedRoute>
          <MainLayout />
        </ProtectedRoute>
      }>
        <Route path="/home" element={<Home />} />
        <Route path="/movimientos" element={<Movimientos />} />
        
        {/* Prestamos Routes */}
        <Route path="/prestamos" element={<Prestamos />} />
        <Route path="/prestamos/nuevo" element={<NuevoPrestamo />} />
        <Route path="/prestamos/:id" element={<VerPrestamo />} />
        <Route path="/prestamos/:id/legajo" element={<VerLegajo />} />
        
        {/* Proveedores Routes */}
        <Route path="/proveedores" element={<Proveedores />} />
        <Route path="/proveedores/:id" element={<VerProveedor />} />
        
        {/* Productos Routes */}
        <Route path="/productos/:id" element={<VerProducto />} />
        <Route path="/productos/:id/compra" element={<CompraCuotas />} />
        
        {/* Other Routes */}
        <Route path="/recibir-dinero" element={<RecibirDinero />} />
        <Route path="/receta" element={<Receta />} />
      </Route>
      
      {/* 404 Route */}
      <Route path="*" element={<NotFound />} />
    </Routes>
  );
};

const App = () => (
  <QueryClientProvider client={queryClient}>
    <AuthProvider>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <AppRoutes />
        </BrowserRouter>
      </TooltipProvider>
    </AuthProvider>
  </QueryClientProvider>
);

export default App;
