import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tic_tac_toe/appBar_widget.dart';

class EncounterHistoryScreen extends StatelessWidget {
  const EncounterHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 15, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarWidget(
            title: "Karşılaşma Geçmişi",
            showBackIcon: true,
          ),
          _buildGameList(size),
        ],
      ),
    );
  }

  Expanded _buildGameList(Size size) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Games")
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Geçmişte oynanmış bir oyun yok.'));
          }

          final gameDocs = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.only(top: 0),
            itemCount: gameDocs.length,
            itemBuilder: (context, index) {
              final gameData = gameDocs[index].data() as Map<String, dynamic>;
              final boardSize = gameData['BoardSize'];
              final winner = gameData['Winner'] ?? 'Henüz belirlendi';
              final createdTime =
                  (gameData['createdTime'] as Timestamp).toDate().toLocal();
              final formattedDate =
                  DateFormat('yyyy-MM-dd – kk:mm').format(createdTime);

              return Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(10),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Oyun Adı:", gameData['GameName']),
                      _buildDetailRow("Katılımcılar:",
                          "${gameData['Participant1']} ve ${gameData['Participant2']}"),
                      _buildDetailRow("Tahta Boyutu:", boardSize),
                      _buildDetailRow("Kazanan:", winner),
                      _buildDetailRow(
                          "Oyun Oluşturulma Tarihi:", formattedDate),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
