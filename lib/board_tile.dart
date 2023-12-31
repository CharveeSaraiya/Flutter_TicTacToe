// import 'dart:js_util';

import 'package:flutter/material.dart';
//import 'package:tic_tac/tile_state.dart';
import 'package:tictactoe/tile_state.dart';

class BoardTile extends StatelessWidget {
  final TileState? tileState;
  final double? dimension;
  final VoidCallback? onPressed;

  BoardTile({Key? key, this.tileState, this.dimension, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: dimension,
        height: dimension,
        child: FlatButton(
          onPressed: onPressed,
          child: _widgetForTileState(),
        ));
  }

  Widget _widgetForTileState() {
    Widget? widget;
    print(tileState);
    switch (tileState!) {
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;

      case TileState.CROSS:
        {
          widget = Image.asset('images/x.png');
        }
        break;

      case TileState.CIRCLE:
        {
          widget = Image.asset('images/o.png');
        }
        break;
      case TileState.NONE:
        // TODO: Handle this case.
        break;
      case TileState.DRAW:
        // TODO: Handle this case.
        break;
    }
    return widget!;
  }
}
