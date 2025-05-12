
import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";

const Index = () => {
  const navigate = useNavigate();

  useEffect(() => {
    // Check if user is logged in
    const isLoggedIn = false; // Replace with actual auth check
    if (isLoggedIn) {
      navigate("/home");
    } else {
      navigate("/");
    }
  }, [navigate]);

  return (
    <div className="min-h-screen w-full flex items-center justify-center bg-white">
      <div className="text-center">
        <h1 className="text-4xl font-bold mb-2 text-gray-800">SiempreClick</h1>
        <p className="text-lg text-gray-500">Cargando...</p>
      </div>
    </div>
  );
};

export default Index;
