
import React from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { DollarSign, CreditCard, ArrowUpRight, ArrowDownRight, BarChart3 } from "lucide-react";

const Home = () => {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-800">Dashboard</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard 
          title="Saldo Actual" 
          value="$5,240.00" 
          icon={<DollarSign className="h-8 w-8 text-green-500" />}
          trend="up" 
          percentage="8.2"
        />
        <StatCard 
          title="Préstamos Activos" 
          value="2" 
          icon={<CreditCard className="h-8 w-8 text-blue-500" />}
          trend="none"
        />
        <StatCard 
          title="Movimientos" 
          value="24" 
          icon={<BarChart3 className="h-8 w-8 text-purple-500" />}
          trend="up" 
          percentage="12.5"
        />
        <StatCard 
          title="Pagos Pendientes" 
          value="$1,200.00" 
          icon={<DollarSign className="h-8 w-8 text-red-500" />}
          trend="down" 
          percentage="3.1"
        />
      </div>
      
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <Card className="col-span-1 lg:col-span-2">
          <CardHeader>
            <CardTitle>Actividad Reciente</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {['Pago recibido', 'Préstamo aprobado', 'Transferencia realizada', 'Compra completada'].map((activity, i) => (
                <div key={i} className="flex items-center justify-between p-3 border-b last:border-0">
                  <div>
                    <p className="font-medium">{activity}</p>
                    <p className="text-sm text-gray-500">Hace {i + 1} {i === 0 ? 'hora' : 'horas'}</p>
                  </div>
                  <span className={`text-${i % 2 === 0 ? 'green' : 'blue'}-500 font-medium`}>
                    {i % 2 === 0 ? '+$420.00' : i === 1 ? '$2,500.00' : '-$350.00'}
                  </span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader>
            <CardTitle>Acciones Rápidas</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 gap-4">
              <QuickAction icon={<DollarSign />} label="Transferir" />
              <QuickAction icon={<CreditCard />} label="Préstamos" />
              <QuickAction icon={<DollarSign />} label="Pagar" />
              <QuickAction icon={<DollarSign />} label="Recargar" />
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

interface StatCardProps {
  title: string;
  value: string;
  icon: React.ReactNode;
  trend?: "up" | "down" | "none";
  percentage?: string;
}

const StatCard = ({ title, value, icon, trend, percentage }: StatCardProps) => (
  <Card>
    <CardContent className="p-6">
      <div className="flex justify-between items-start">
        <div>
          <p className="text-sm font-medium text-gray-500">{title}</p>
          <p className="text-2xl font-bold mt-1">{value}</p>
          
          {trend && trend !== "none" && percentage && (
            <div className="flex items-center mt-2">
              {trend === "up" ? (
                <ArrowUpRight className="h-4 w-4 text-green-500 mr-1" />
              ) : (
                <ArrowDownRight className="h-4 w-4 text-red-500 mr-1" />
              )}
              <span className={`text-sm font-medium text-${trend === "up" ? "green" : "red"}-500`}>
                {percentage}%
              </span>
            </div>
          )}
        </div>
        
        {icon}
      </div>
    </CardContent>
  </Card>
);

interface QuickActionProps {
  icon: React.ReactNode;
  label: string;
}

const QuickAction = ({ icon, label }: QuickActionProps) => (
  <button className="flex flex-col items-center justify-center p-4 border rounded-md hover:bg-gray-50 transition-colors">
    <div className="h-10 w-10 flex items-center justify-center bg-blue-100 rounded-full text-blue-600 mb-2">
      {icon}
    </div>
    <span className="text-sm font-medium">{label}</span>
  </button>
);

export default Home;
