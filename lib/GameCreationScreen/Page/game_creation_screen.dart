import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/GameCreationScreen/Widget/color_change_widget.dart';
import 'package:tic_tac_toe/GameScreen/Page/game_screen.dart';
import 'package:tic_tac_toe/appBar_widget.dart';
import 'package:tic_tac_toe/constant.dart';

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
  Color _boardColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _boardColor = Colors.red;
  }

  @override
  void dispose() {
    _gameNameController.dispose();
    _participant1Controller.dispose();
    _participant2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(252, 251, 249, 1),
      body: Column(
        children: [
          AppBarWidget(
            title: "Oyun Oluşturma",
            showBackIcon: true,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _gameNameController,
                    decoration: const InputDecoration(
                      labelText: "Oyun Adı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Oyun adı boş olamaz';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Tahta Arka Plan Rengi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  const SizedBox(height: 20),
                  // Text(
                  //   "Kare Rengi",
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 10),
                  // ColorPickerWidget(
                  //   selectedColor: _boardColor,
                  //   onColorSelected: (color) {
                  //     setState(() {
                  //       _boardColor = color;
                  //     });
                  //   },
                  // ),
                  TextFormField(
                    controller: _participant1Controller,
                    decoration: const InputDecoration(
                      labelText: "Katılımcı 1",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Katılımcı 1 adı boş olamaz';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _participant2Controller,
                    decoration: const InputDecoration(
                      labelText: "Katılımcı 2",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Katılımcı 2 adı boş olamaz';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addGameToDatabase();
                        }
                      },
                      child: const Text("Oyun Oluştur"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addGameToDatabase() async {
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
        "BoardColor": _boardColor.value, // Renk bilgisini int olarak alıyorum
        "Participant1": participant1,
        "Participant2": participant2,
        'createdTime': DateTime.now(),
      };

      final docRef = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Games")
          .add(gameData);

      await docRef.update({'docId': docRef.id});

      _gameNameController.clear();
      _participant1Controller.clear();
      _participant2Controller.clear();

      final gamesRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Games")
          .orderBy('createdTime', descending: true);

      final querySnapshot = await gamesRef.get();
      pastMatches.clear();
      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Games")
            .doc(doc.id)
            .update({'docId': doc.id});
        pastMatches.add(doc.data());
      }

      Navigator.of(context).pop();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
              player1: participant1,
              player2: participant2,
              boardColor: _boardColor),
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
