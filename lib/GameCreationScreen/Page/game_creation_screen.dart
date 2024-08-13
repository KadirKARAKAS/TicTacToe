import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/FirstOpeningPage/Page/first_opening_page.dart';
import 'package:tic_tac_toe/appBar_widget.dart';
import 'package:tic_tac_toe/constant.dart';

class GameCreationScreen extends StatefulWidget {
  const GameCreationScreen({super.key});

  @override
  State<GameCreationScreen> createState() => _GameCreationScreenState();
}

class _GameCreationScreenState extends State<GameCreationScreen> {
  final TextEditingController _gameNameController = TextEditingController();
  final TextEditingController _participant1Controller = TextEditingController();
  final TextEditingController _participant2Controller = TextEditingController();
  Color _boardColor = Colors.white;

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
          AppBarWidget(title: "Oyun Oluşturma"),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _gameNameController,
                  decoration: const InputDecoration(
                    labelText: "Oyun Adı",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Tahta Arka Plan Rengi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        _boardColor = Colors.white;
                      }),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.red,
                        child: _boardColor == Colors.white
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        _boardColor = Colors.blue;
                      }),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.blue,
                        child: _boardColor == Colors.blue
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        _boardColor = Colors.green;
                      }),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.green,
                        child: _boardColor == Colors.green
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _participant1Controller,
                  decoration: const InputDecoration(
                    labelText: "Katılımcı 1",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _participant2Controller,
                  decoration: const InputDecoration(
                    labelText: "Katılımcı 2",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String gameName = _gameNameController.text;
                      String participant1 = _participant1Controller.text;
                      String participant2 = _participant2Controller.text;
                      print('Oyun Adı: $gameName');
                      print('Tahta Rengi: $_boardColor');
                      print('Katılımcı 1: $participant1');
                      print('Katılımcı 2: $participant2');
                      await addGameToDatabase();
                    },
                    child: const Text("Oyun Oluştur"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addGameToDatabase() async {
    String gameName = _gameNameController.text;
    String participant1 = _participant1Controller.text;
    String participant2 = _participant2Controller.text;

    final gameData = {
      "GameName": gameName,
      "BoardColor": _boardColor.value, // Renk bilgisini int olarak saklıyoruz
      "Participant1": participant1,
      "Participant2": participant2,
      'createdTime': DateTime.now(),
    };

    // Yeni bir belge oluşturmak için `add()` yöntemini kullanın.
    final docRef = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Games")
        .add(gameData);

    // Oluşturulan belgeye docID ekleyin.
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

    Future.delayed(Duration(milliseconds: 500), () async {
      print("GETDATALİST VERİLERİ BEKLENİYOR..........");
      await pastMatches.isEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )
          : setState(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirstOpeningPage(),
                ),
              );
            });
    });
  }
}
