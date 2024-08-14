import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/FirstOpeningPage/Page/first_opening_page.dart';
import 'package:tic_tac_toe/GameCreationScreen/Page/game_creation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;
  final Color boardColor;
  final String boardSize;
  final String gameID;

  GameScreen({
    Key? key,
    required this.player1,
    required this.player2,
    required this.boardColor,
    required this.boardSize,
    required this.gameID,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;
  late int _size;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _size = int.parse(widget.boardSize.split('x')[0]);
    _board = List.generate(_size, (_) => List.generate(_size, (_) => ""));
    _currentPlayer = "X";
    _winner = "";
    _gameOver = false;
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  Future<void> _handleGameEnd(String result) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Games")
          .doc(widget.gameID)
          .update({'Winner': result});
    } catch (e) {
      print("Oyun sonucu güncellenirken hata oluştu: $e");
    }
  }

  void _showResultDialog(String title, String description, String result) {
    AwesomeDialog(
      context: context,
      dialogType: title == 'Kazanan' ? DialogType.success : DialogType.info,
      animType: AnimType.scale,
      title: title,
      desc: description,
      btnOkText: "Yeniden Oyna",
      btnCancelText: "Oyundan Çık",
      btnOkOnPress: () {
        _handleGameEnd(result);
        _resetGame();
      },
      btnCancelOnPress: () {
        _handleGameEnd(result);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FirstOpeningPage(),
            ));
      },
    ).show();
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }

    setState(() {
      _board[row][col] = _currentPlayer;

      if (_checkWinner(row, col)) {
        _winner = _currentPlayer;
        _gameOver = true;
        String winnerName =
            _currentPlayer == "X" ? widget.player1 : widget.player2;
        _showResultDialog(
          'Kazanan',
          'Kazanan: $winnerName',
          _winner == "X"
              ? "${widget.player1} KAZANDI!"
              : "${widget.player2} KAZANDI!",
        );
      } else if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "Draw";
        _showResultDialog(
          'Beraberlik',
          'Oyun Beraber!',
          "Beraberlik",
        );
      } else {
        _currentPlayer = _currentPlayer == "X" ? "O" : "X";
      }
    });
  }

  bool _checkWinner(int row, int col) {
    String player = _board[row][col];

    if (_board[row].every((cell) => cell == player)) return true;
    if (_board.every((r) => r[col] == player)) return true;

    bool diagonal1 = true;
    bool diagonal2 = true;

    for (int i = 0; i < _size; i++) {
      if (_board[i][i] != player) diagonal1 = false;
      if (_board[i][_size - 1 - i] != player) diagonal2 = false;
    }

    return diagonal1 || diagonal2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 25, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 100),
            _buildCurrentPlayerInfo(),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: widget.boardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(5),
              child: _buildGrid(),
            ),
            SizedBox(height: 15),
            _buildActionButtons(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: _size * _size,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _size,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ _size;
        int col = index % _size;
        return GestureDetector(
          onTap: () => _makeMove(row, col),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                _board[row][col],
                style: TextStyle(
                  fontSize:
                      250 / double.parse(widget.boardSize.split("x").first),
                  fontWeight: FontWeight.bold,
                  color: _board[row][col] == "X"
                      ? Color(0xFFE25041)
                      : Color(0xFF1CBD9E),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentPlayerInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Oynama Sırası: ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              _currentPlayer == "X"
                  ? "${widget.player1} ($_currentPlayer)"
                  : "${widget.player2} ($_currentPlayer)",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: _currentPlayer == "X"
                    ? Color(0xFFE25041)
                    : Color(0xFF1CBD9E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton("Sıfırla!", _resetGame),
        _buildActionButton("Yeni Oyun!", () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameCreationScreen(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
