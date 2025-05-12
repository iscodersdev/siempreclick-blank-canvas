import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RecetaPage extends StatefulWidget {
  const RecetaPage({Key? key}) : super(key: key);

  @override
  State<RecetaPage> createState() => _RecetaPageState();
}
class Medicamento {
  String nombre;
  String cantidad;

  Medicamento({required this.nombre, required this.cantidad});
}
class _RecetaPageState extends State<RecetaPage> {
  final List<Medicamento> medicamentos = [
    Medicamento(nombre: 'Amoxicilina 500', cantidad: 'Cantidad: 24 Comprimidos'),
    Medicamento(nombre: 'Diclofenac 700', cantidad: 'Cantidad: 8 Comprimidos'),
  ];

  final formatCurrency = new NumberFormat.currency(locale: 'id', symbol: "\$");
  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFF5E00),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.clear, color: Colors.white,),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: fullWidth / 2,
            decoration: const BoxDecoration(
              color: Color(0xffFF5E00),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Transform(
                    transform: Matrix4.identity()..scale(-1.0, 1.0),
                    alignment: Alignment.center,
                    child: Image.asset('assets/Images/cut.png'),
                  ),
                ),
                Positioned(
                  top: -10,
                  right: 20,
                  child: Image.asset(
                    'assets/Images/logo3.png',
                    scale: 10,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Text(
                          'Receta electrónica',
                          style: GoogleFonts.raleway(
                              color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                        const SizedBox(height: 7,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Profesional: ',
                              style: GoogleFonts.raleway(
                                  color: Colors.white, fontWeight: FontWeight.w500,fontSize: 18),
                            ),
                            Text(
                              'Dr. Jose Manuel Garcia',
                              style: GoogleFonts.raleway(
                                  color: Colors.white, fontWeight: FontWeight.w400,fontStyle: FontStyle.italic,fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Número: ',
                              style: GoogleFonts.raleway(
                                  color: Colors.white, fontWeight: FontWeight.w500,fontSize: 18),
                            ),
                            Text(
                              '4912879121-0',
                              style: GoogleFonts.raleway(
                                  color: Colors.white, fontWeight: FontWeight.w300,fontStyle: FontStyle.italic,fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Prescripción',
            style: GoogleFonts.raleway(
                color: Color(0xffFF5E00), fontWeight: FontWeight.bold,fontSize: 20),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: medicamentos.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 10,
                    child: ListTile(
                      subtitle: Text(
                        medicamentos[index].cantidad,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                      title: Text(
                        medicamentos[index].nombre,
                        style: GoogleFonts.raleway(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        // Acción al presionar la tarjeta si es necesario
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.raleway(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${formatCurrency.format(10000.00)}',
                  style: GoogleFonts.raleway(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              margin: const EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
              padding: const EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xffFF5E00))
              ),
              child: Row(
                children: [
                  const Icon(
                      Icons.receipt_long_rounded,
                      size: 20.0,
                      color: Color(0xffFF5E00)
                  ),
                  Text(
                    '  Pago Próximo de Haberes',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        color: const Color(0xffFF5E00),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              margin: const EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
              padding: const EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xffFF5E00))
              ),
              child: Row(
                children: [
                  const Icon(
                      Icons.monetization_on_outlined,
                      size: 20.0,
                      color: Color(0xffFF5E00)
                  ),
                  Text(
                    '  Pago con Préstamo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        color: const Color(0xffFF5E00),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              margin: const EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
              padding: const EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xffFF5E00))
              ),
              child: Row(
                children: [
                  const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 20.0,
                      color: Color(0xffFF5E00)
                  ),
                  Text(
                    '  Pago con Billetera',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        color: const Color(0xffFF5E00),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
