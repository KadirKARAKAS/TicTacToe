import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 65,
      child: Align(
          alignment: Alignment.center,
          child: Text(
            "TicTacToe",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          )),
    );
  }
}
