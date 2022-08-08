import 'package:flutter/material.dart';
import 'package:sudoku/dividers/dividers.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sudoku"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(top: 80, left: 15, right: 15),
          child: SudokuBoard(),
        ),
      ),
    );
  }
}

class SudokuBoard extends StatelessWidget {
  const SudokuBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (index) {
        return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.2,
              ),
            ),
            child: Sudoku9Box());
      }),
    );
  }
}

class Sudoku9Box extends StatelessWidget {
  const Sudoku9Box({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(
        9,
        (index) {
          return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.45,
                ),
              ),
              child: SudokuCell(val: (index + 1).toString()));
        },
      ),
    );
  }
}

class SudokuCell extends StatefulWidget {
  SudokuCell({Key? key, required this.val}) : super(key: key);
  String val = '';
  @override
  State<SudokuCell> createState() => _SudokuCellState(val: val);
}

class _SudokuCellState extends State<SudokuCell> {
  String val = '';
  _SudokuCellState({required this.val});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            val,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
