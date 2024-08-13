import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl paketini import edin
import 'package:tic_tac_toe/appBar_widget.dart';
import 'package:tic_tac_toe/constant.dart';

class EncounterHistoryPage extends StatefulWidget {
  const EncounterHistoryPage({super.key});

  @override
  State<EncounterHistoryPage> createState() => _EncounterHistoryPageState();
}

class _EncounterHistoryPageState extends State<EncounterHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(
            title: "Karşılaşma Geçmişi",
            showBackIcon: true,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: pastMatches.length,
              itemBuilder: (context, index) {
                final match = pastMatches[index];
                return ListTile(
                  title: Text('Oyun: ${match['GameName'] ?? 'Bilinmiyor'}'),
                  subtitle: Text(
                    'Tarih: ${_formatDate(match['createdTime'])}\n'
                    'Katılımcı 1: ${match['Participant1'] ?? 'Bilinmiyor'}\n'
                    'Katılımcı 2: ${match['Participant2'] ?? 'Bilinmiyor'}',
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showMatchDetailDialog(context, match);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Bilinmiyor';

    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return dateFormat.format(dateTime);
  }

  void _showMatchDetailDialog(
      BuildContext context, Map<String, dynamic> match) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Maç Detayları',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildDetailText(
                    'Oyun Adı: ${match['GameName'] ?? 'Bilinmiyor'}'),
                _buildDetailText('Tarih: ${_formatDate(match['createdTime'])}'),
                _buildDetailText(
                    'Katılımcı 1: ${match['Participant1'] ?? 'Bilinmiyor'}'),
                _buildDetailText(
                    'Katılımcı 2: ${match['Participant2'] ?? 'Bilinmiyor'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Kapat',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }
}
