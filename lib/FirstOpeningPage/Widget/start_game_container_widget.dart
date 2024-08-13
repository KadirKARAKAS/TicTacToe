import 'package:flutter/material.dart';

import '../../GameCreationScreen/Page/game_creation_screen.dart';

class StartGameContainerWidget extends StatelessWidget {
  const StartGameContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameCreationScreen(),
            ));
      },
      child: Container(
        width: size.width / 1.25,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              blurStyle: BlurStyle.inner,
              color: Colors.grey,
              offset: Offset(4, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              "Karşılaşma Oluştur",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(0, 0, 15, 1)),
            )),
      ),
    );
  }
}
