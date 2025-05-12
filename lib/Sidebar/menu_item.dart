import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItemss extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final onTap;

  const MenuItemss({Key? key, this.icon, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 25),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                icon,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(
                width: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  title!,
                  style: GoogleFonts.raleway(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
