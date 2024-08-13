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
      backgroundColor: const Color.fromRGBO(252, 251, 249, 1),
      body: Column(
        children: [
          AppBarWidget(
            title: "TicTacToe",
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
