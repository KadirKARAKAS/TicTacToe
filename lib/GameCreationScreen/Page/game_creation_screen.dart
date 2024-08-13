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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 30, 1),
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
                  //--- OYUN ADI ---
                  Container(
                    width: size.width / 1,
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
                        contentPadding: EdgeInsets.only(left: 10, top: 5),
                        hintText: "Oyun Adı",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Oyun adı boş olamaz';
                        }
                        return null;
                      },
                    ),
                  ),
                  //--- OYUN ADI BİTİŞ ---

                  const SizedBox(height: 20),
                  //--- ARKA PLAN RENK SEÇME  ---

                  const Text(
                    "Tahta Arka Plan Rengi",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                  //--- ARKA PLAN RENK SEÇME BİTİŞ  ---

                  const SizedBox(height: 20),

                  // --- 1. OYUNCU ADI ---
                  Container(
                    width: size.width / 1,
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
                      controller: _participant1Controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, top: 5),
                        hintText: "1. Oyuncuyu Giriniz",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Katılımcı 1 adı boş olamaz';
                        }
                        return null;
                      },
                    ),
                  ),
                  // --- 1. OYUNCU ADI BİTİŞ ---

                  const SizedBox(height: 20),
                  // --- 2. OYUNCU ADI  ---

                  Container(
                    width: size.width / 1,
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
                      controller: _participant2Controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, top: 5),
                        hintText: "2. Oyuncuyu Giriniz",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Katılımcı 2 adı boş olamaz';
                        }
                        return null;
                      },
                    ),
                  ),
                  // --- 2. OYUNCU ADI BİTİŞ ---

                  const SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          addGameToDatabase();
                        }
                      },
                      child: Container(
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
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w600),
                            )),
                      ),
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
