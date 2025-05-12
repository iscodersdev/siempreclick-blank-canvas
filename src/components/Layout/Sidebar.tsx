
import React, { useState } from "react";
import { Link } from "react-router-dom";
import { 
  Home, 
  CreditCard, 
  DollarSign, 
  FileText,
  Package, 
  Settings, 
  Menu,
  X
} from "lucide-react";

const Sidebar = () => {
  const [expanded, setExpanded] = useState(false);

  const toggleSidebar = () => {
    setExpanded(!expanded);
  };

  return (
    <div className={`fixed top-0 left-0 h-full bg-white shadow-lg transition-all duration-300 z-50 ${expanded ? 'w-64' : 'w-16'}`}>
      <div className="flex items-center justify-between p-4 border-b">
        {expanded ? (
          <h2 className="text-xl font-bold text-gray-800">SiempreClick</h2>
        ) : null}
        <button onClick={toggleSidebar} className="p-2 rounded-md hover:bg-gray-100">
          {expanded ? <X size={20} /> : <Menu size={20} />}
        </button>
      </div>
      
      <nav className="p-2">
        <ul className="space-y-2">
          <NavItem to="/" icon={<Home />} text="Inicio" expanded={expanded} />
          <NavItem to="/prestamos" icon={<CreditCard />} text="Préstamos" expanded={expanded} />
          <NavItem to="/movimientos" icon={<FileText />} text="Movimientos" expanded={expanded} />
          <NavItem to="/proveedores" icon={<Package />} text="Proveedores" expanded={expanded} />
          <NavItem to="/transferir" icon={<DollarSign />} text="Transferir" expanded={expanded} />
          <NavItem to="/settings" icon={<Settings />} text="Configuración" expanded={expanded} />
        </ul>
      </nav>
    </div>
  );
};

interface NavItemProps {
  to: string;
  icon: React.ReactNode;
  text: string;
  expanded: boolean;
}

const NavItem = ({ to, icon, text, expanded }: NavItemProps) => (
  <li>
    <Link
      to={to}
      className="flex items-center p-2 rounded-md hover:bg-gray-100 text-gray-700 hover:text-gray-900"
    >
      <span className="mr-3">{icon}</span>
      {expanded && <span>{text}</span>}
    </Link>
  </li>
);

export default Sidebar;
