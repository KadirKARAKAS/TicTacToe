import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tic_tac_toe/appBar_widget.dart';

class FirstOpeningPage extends StatefulWidget {
  const FirstOpeningPage({super.key});

  @override
  State<FirstOpeningPage> createState() => FirstOpeningPageState();
}

class FirstOpeningPageState extends State<FirstOpeningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(252, 251, 249, 1),
        body: Column(
          children: [
            AppBarWidget(),
            Column(
              children: [
                Text("TicTacToe oyununa hoşgeldiniz!"),
                Text(
                    "Lütfen başlamak için yeni bir oyun oluşturun veya geçmiş oyunlarınızı inceleyin!"),
              ],
            ),

            InkWell(
              onTap: () {
                print(FirebaseAuth.instance.currentUser!.uid);
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.red,
              ),
            ),

            // Container(
            //   width: 150,
            //   height: 45,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(13),
            //     color: Colors.green,
            //   ),
            // )
          ],
        ));
  }
}
