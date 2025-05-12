import 'package:smart/Screens/BottomBar/BottomBar.dart';
import 'package:smart/Screens/Login/Login.dart';
import 'package:smart/Screens/Registro/RegisterPage.dart';
import 'package:smart/Sidebar/Sidebar.dart';
import 'package:flutter/material.dart';

import '../Screens/Prestamos/NuevoPrestamo.dart';
import '../Screens/Prestamos/Prestamos.dart';

final tipo = Null;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case '/Home':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/Register':
        return MaterialPageRoute(
          builder: (_) => RegisterPage(),
        );
      case '/NuevoPrestamo':
        return MaterialPageRoute(
          builder: (_) => NuevoPrestamoPage(),
        );
//      case '/VerNoticia':
//        return PageTransition(child: NoticiaPage(), type: PageTransitionType.rightToLeft);
//      case '/Votaciones':
//        return PageTransition(child: VotacionesPage(), type: PageTransitionType.rightToLeft);

    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('error')),
      );
    });
  }
}
