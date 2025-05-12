import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final onTap;

  const MenuItem({Key? key, this.icon, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.black54,
              size: 25,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              title!,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 19,
                  color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}
