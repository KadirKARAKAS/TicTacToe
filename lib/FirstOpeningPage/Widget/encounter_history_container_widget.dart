import 'package:flutter/material.dart';
import 'package:tic_tac_toe/EncounterHistory/Page/encounter_history_page.dart';

class EncounterHistoryContainerWidget extends StatelessWidget {
  const EncounterHistoryContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EncounterHistoryPage(),
          ),
        );
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/leaderboard.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Karşılaşma Geçmişi",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(0, 0, 15, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
