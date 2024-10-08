import 'package:flutter/material.dart';

class CenterTextWidget extends StatelessWidget {
  const CenterTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "TicTacToe oyununa hoşgeldiniz!",
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Lütfen başlamak için yeni bir oyun oluşturun veya geçmiş oyunlarınızı inceleyin!",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
