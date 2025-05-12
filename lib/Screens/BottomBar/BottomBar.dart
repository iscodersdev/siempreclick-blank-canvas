import 'package:smart/Screens/HomeScreen/Home.dart';
import 'package:smart/Screens/Mis%20Datos/MisDatos.dart';
import 'package:smart/Screens/Movimientos/Movimientos.dart';
import 'package:smart/Screens/Prestamos/Prestamos.dart';
import 'package:smart/Screens/Proveedores/Proveedores.dart';
import 'package:smart/Screens/QRPago/QRPago.dart';
import 'package:smart/Screens/Tarjetas/Tarjetas.dart';
import 'package:smart/Screens/mas/Mas.dart';
import 'package:smart/route/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:smart/Widgets/Navegacion.dart';

final GlobalKey<_HomePageState> homePageKey = GlobalKey<_HomePageState>();

class HomePage extends StatefulWidget implements NavigationStates {
  @override
  _HomePageState createState() => _HomePageState();
}

List<Widget> _buildScreens() {
  return [
    HomeScreenPage(),
    WalletPage(),
    ProveedoresPage(),
    PrestamosPage(),
    MasPage(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      activeColorPrimary: Color(0xffFF5E00),
      title: 'Inicio',
      textStyle: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.w500),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.account_balance_wallet_outlined),
      activeColorPrimary: Color(0xffFF5E00),
      title: 'Billetera',
      textStyle: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.w500),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(MdiIcons.shoppingOutline),
      activeColorPrimary: Color(0xffFF5E00),
      title: 'Productos',
      textStyle: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.w500),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    // PersistentBottomNavBarItem(
    //   activeColorSecondary: Colors.white,
    //   icon: Icon(
    //     MdiIcons.qrcode,
    //     color: Colors.white,
    //     size: 35,
    //   ),
    //   activeColorPrimary: Color(0xffFF5E00),
    //   inactiveColorSecondary: Colors.white,
    //   inactiveColorPrimary: CupertinoColors.systemGrey,
    // ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.monetization_on_outlined,
      ),
      activeColorPrimary: Color(0xffFF5E00),
      title: 'Prestamos',
      textStyle: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.w500),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.menu,
      ),
      activeColorPrimary: Color(0xffFF5E00),
      title: 'Mas',
      textStyle: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.w500),
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];
}

final storage = FlutterSecureStorage();

class _HomePageState extends State<HomePage> {
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  void setPage(int index) {
    setState(() {
      _controller?.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarHeight: 70,
      confineToSafeArea: true,
      onItemSelected: (index) {
        setState(() {
          _controller!.index = index;
        });
      },
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      // hideNavigationBarWhenKeyboardShows:
      //     true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      //popAllScreensOnTapOfSelectedTab: true,
      //popActionScreens: PopActionScreensType.all,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
        )
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
