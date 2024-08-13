import 'package:flutter/material.dart';

class StartGameContainerWidget extends StatelessWidget {
  const StartGameContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("helloo");
      },
      child: Container(
        width: 150,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.green,
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              "Karşılaşma Oluştur",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )),
      ),
    );
  }
}
