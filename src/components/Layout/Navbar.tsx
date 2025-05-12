
import React from "react";
import { BellIcon, UserCircle } from "lucide-react";

const Navbar = () => {
  return (
    <header className="bg-white border-b shadow-sm">
      <div className="flex items-center justify-between px-4 py-3">
        <div>
          <h1 className="text-xl font-semibold text-gray-800">SiempreClick</h1>
        </div>
        
        <div className="flex items-center space-x-4">
          <button className="p-2 rounded-full hover:bg-gray-100">
            <BellIcon className="w-5 h-5 text-gray-600" />
          </button>
          
          <div className="flex items-center space-x-2">
            <span className="text-sm font-medium text-gray-700">Usuario</span>
            <UserCircle className="w-8 h-8 text-gray-600" />
          </div>
        </div>
      </div>
    </header>
  );
};

export default Navbar;
