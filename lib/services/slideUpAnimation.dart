import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../Screens/Prestamos/Prestamos.dart';

class TransferenciaOkAnimation extends StatefulWidget {
  @override
  _TransferenciaOkAnimationState createState() => _TransferenciaOkAnimationState();
}

class _TransferenciaOkAnimationState extends State<TransferenciaOkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Configura la animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_controller);

    // Inicia la animación
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/Home');
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 35,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SlideTransition(
            position: _animation,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.6,
              color: Colors.green[500],
              child: Center(
                child: SizedBox(
                    height: 250,
                    width: 250,
                    child: LottieBuilder.network(
                      'https://assets5.lottiefiles.com/packages/lf20_rc5d0f61.json',
                      repeat: false,
                    )),
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.7,
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.7,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Su solicitud fue cargada con exito!',
                      style: GoogleFonts.raleway(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Gracias por elegirnos!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                          fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Revisá el estado de tu prestamo en la casilla de prestamos.',
                      style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PrestamosPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 35, right: 35, top: 5, bottom: 5),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.arrow_left,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Volver',
                                    style: GoogleFonts.raleway(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
