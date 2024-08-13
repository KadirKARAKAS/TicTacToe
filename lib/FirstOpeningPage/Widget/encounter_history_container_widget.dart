import 'package:flutter/material.dart';

class EncounterHistoryContainerWidget extends StatelessWidget {
  const EncounterHistoryContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("geçmiş");
      },
      child: Container(
        width: 150,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.red,
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              "Karşılaşma Geçmişi",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )),
      ),
    );
  }
}
