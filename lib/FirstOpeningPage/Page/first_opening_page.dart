import 'package:flutter/material.dart';
import 'package:tic_tac_toe/FirstOpeningPage/Widget/center_text_widget.dart';
import 'package:tic_tac_toe/FirstOpeningPage/Widget/encounter_history_container_widget.dart';
import 'package:tic_tac_toe/FirstOpeningPage/Widget/start_game_container_widget.dart';
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
      backgroundColor: Color.fromRGBO(0, 0, 15, 1),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/homePageLogo.png",
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  CenterTextWidget(),
                  const SizedBox(height: 20),
                  StartGameContainerWidget(),
                  const SizedBox(height: 20),
                  EncounterHistoryContainerWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
