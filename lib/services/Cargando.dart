import 'package:flutter/material.dart';

class Cargando extends StatelessWidget {
  const Cargando({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: 15,
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ));
  }
}
