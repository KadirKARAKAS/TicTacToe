import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/GameCreationScreen/Widget/color_change_widget.dart';
import 'package:tic_tac_toe/GameScreen/Page/game_screen.dart';
import 'package:tic_tac_toe/appBar_widget.dart';

class GameCreationScreen extends StatefulWidget {
  const GameCreationScreen({super.key});

  @override
  State<GameCreationScreen> createState() => _GameCreationScreenState();
}

class _GameCreationScreenState extends State<GameCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gameNameController = TextEditingController();
  final TextEditingController _participant1Controller = TextEditingController();
  final TextEditingController _participant2Controller = TextEditingController();
  Color _boardColor = Colors.red; // renk varsayılan olarak kırmızı seçili
  String _boardSize = "3x3"; // tahta varsayılan olarak 3x3 seçili

  @override
  void dispose() {
    _gameNameController.dispose();
    _participant1Controller.dispose();
    _participant2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 25, 1),
      body: Column(
        children: [
          AppBarWidget(
            title: "Oyun Oluşturma",
            showBackIcon: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGameNameWidget(size),
                    const SizedBox(height: 20),
                    _buildBoardColorPicker(),
                    const SizedBox(height: 20),
                    _buildBoardSizeDropdown(),
                    const SizedBox(height: 20),
                    _buildParticipantNameField(
                        size, _participant1Controller, "1. Katılımcı"),
                    const SizedBox(height: 20),
                    _buildParticipantNameField(
                        size, _participant2Controller, "2. Katılımcı"),
                    const SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _addGameToDatabase();
                          }
                        },
                        child: _buildStartGameButton(size),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameNameWidget(Size size) {
    return Container(
      width: size.width,
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
      child: TextFormField(
        controller: _gameNameController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 6, top: 5),
          border: InputBorder.none,
          hintText: "Oyun Adı",
          labelStyle: TextStyle(color: Colors.black54),
        ),
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen oyun adını girin';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBoardColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tahta Arka Plan Rengi",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        ColorPickerWidget(
          selectedColor: _boardColor,
          onColorSelected: (color) {
            setState(() {
              _boardColor = color;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBoardSizeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Oyun Tahtası Boyutu",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _boardSize,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
          ),
          items: ["3x3", "4x4", "5x5"]
              .map((size) => DropdownMenuItem(
                    value: size,
                    child: Text(size),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _boardSize = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildParticipantNameField(
      Size size, TextEditingController controller, String labelText) {
    return Container(
      width: size.width,
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
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 6, top: 5),
          border: InputBorder.none,
          hintText: labelText,
          labelStyle: TextStyle(color: Colors.black54),
        ),
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen katılımcı adını girin';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildStartGameButton(Size size) {
    return Container(
      width: size.width / 2.5,
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
          "Oyunu Başlat",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _addGameToDatabase() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );

    try {
      String gameName = _gameNameController.text;
      String participant1 = _participant1Controller.text;
      String participant2 = _participant2Controller.text;

      final gameData = {
        "GameName": gameName,
        "BoardColor": _boardColor.value,
        "BoardSize": _boardSize,
        "Participant1": participant1,
        "Participant2": participant2,
        "Winner": "",
        'createdTime': DateTime.now(),
      };

      final docRef = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Games")
          .add(gameData);

      String gameID = docRef.id;
      await docRef.update({'docId': gameID});

      _gameNameController.clear();
      _participant1Controller.clear();
      _participant2Controller.clear();

      Navigator.of(context).pop();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            player1: participant1,
            player2: participant2,
            boardColor: _boardColor,
            boardSize: _boardSize,
            gameID: gameID,
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hata'),
          content: Text('Bir hata oluştu. Lütfen tekrar deneyin.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }
}
