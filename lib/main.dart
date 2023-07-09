import 'package:flutter/material.dart';
//import 'package:tic_tac/board_tile.dart';
//import 'package:tic_tac/tile_state.dart';
import 'package:tictactoe/tile_state.dart';
import 'package:tictactoe/board_tile.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9, TileState.EMPTY);
  var _currentTurn = TileState.CROSS;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Center(
          child:
              Stack(children: [Image.asset('images/board.png'), _boardTiles()]),
        ),
      ),
    );
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tileDimension = boardDimension / 3;

      return Container(
          width: boardDimension,
          height: boardDimension,
          child: Column(
              children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value;

            return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                //   print(innerEntry.key );
                // print( innerEntry.value.toString());

                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;
                //  print(tileIndex);
                return BoardTile(
                  tileState: tileState,
                  dimension: tileDimension,
                  onPressed: () => _updateTileStateForIndex(tileIndex),
                );
              }).toList(),
            );
          }).toList()));
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    //print("hello");
    // print(selectedIndex);
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      TileState? winner = _findWinner();
      // print("After find Winner ${winner}");
      //print(winner);
      if (winner == TileState.DRAW) {
        print('Winner is: $winner');
        _showWinnerDialog(winner!);
      }

      if (winner != TileState.NONE) {
        print('Winner is: $winner');
        _showWinnerDialog(winner!);
      }
    }
  }

  TileState? _findWinner() {
    // ignore: prefer_function_declarations_over_variables
    TileState Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          // print("find Winner ${a} ${b} ${c} ");
          // print ((_boardState[a] == _boardState[b]) &&
          //     (_boardState[b] == _boardState[c]));
          // print(_boardState[a]);
          return _boardState[a];
        }
      }
      return TileState.NONE;
    };
    int cnt = 0;
    for (int i = 0; i < _boardState.length; i++) {
      if (_boardState[i] == TileState.CIRCLE ||
          _boardState[i] == TileState.CROSS) cnt++;
    }
    if (cnt == 9) {
      return TileState.DRAW;
    }
    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];
    print(checks);
//int cnt=0;
    TileState winner = TileState.NONE;

    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != TileState.EMPTY && checks[i] != TileState.NONE) {
        winner = checks[i];
        break;
      }
    }
    return winner;
  }

  void _showWinnerDialog(TileState tileState) {
    //GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    // final context = navigatorKey.currentState!.overlay!.context;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title:
                (tileState == TileState.DRAW) ? Text("Draw") : Text('Winner'),
            content: Image.asset((tileState == TileState.CROSS
                ? 'images/x.png'
                : tileState == TileState.CIRCLE
                    ? 'images/o.png'
                    : 'images/Draw.png')),
            actions: [
              FlatButton(
                  onPressed: () {
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: Text('New Game'))
            ],
          );
        });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
