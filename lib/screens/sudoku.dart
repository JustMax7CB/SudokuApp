import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:sudoku/blokChar.dart';
import 'package:sudoku/boxInner.dart';
import 'package:sudoku/focusClass.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class Sudoku extends StatefulWidget {
  const Sudoku({Key? key}) : super(key: key);

  @override
  State<Sudoku> createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  // our variable

  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;

  @override
  void initState() {
    super.initState();
    generateSudoku();
  }

  void generateSudoku() {
    isFinish = false;
    focusClass = FocusClass();
    tapBoxIndex = null;
    generatePuzzle();
    checkFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              sudokuBoard(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          numPad(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Column(
                          children: [
                            newBtn(),
                            clearBtn(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newBtn() {
    return ElevatedButton(
      onPressed: () => setState(() => generateSudoku()),
      child: const Text("New Game"),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey[400],
      ),
    );
  }

  Widget clearBtn() {
    return ElevatedButton(
      onPressed: () {
        setInput(null);
        print("clear pressed");
      },
      child: const Text("Clear"),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey[400],
      ),
    );
  }

  Widget sudokuBoard() {
    return Padding(
      padding: const EdgeInsets.only(top: 55),
      child: Container(
        margin: const EdgeInsets.all(20),
        // height: 400,
        width: double.maxFinite,
        color: Colors.black, //big spacers
        padding: const EdgeInsets.all(3),
        alignment: Alignment.center,
        child: GridView.builder(
          itemCount: boxInners.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
          ),
          physics: const ScrollPhysics(),
          itemBuilder: (buildContext, index) {
            BoxInner boxInner = boxInners[index];
            return Container(
              color: Colors.grey, //small spacers
              alignment: Alignment.center,
              child: GridView.builder(
                itemCount: boxInner.blokChars.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                physics: const ScrollPhysics(),
                itemBuilder: (buildContext, indexChar) {
                  BlokChar blokChar = boxInner.blokChars[indexChar];
                  Color color = Colors.yellow.shade100;
                  Color colorText = Colors.black;

                  if (isFinish)
                    color = Colors.green;
                  else if (blokChar.isDefault)
                    color = Colors.grey[400]!;
                  else if (blokChar.isFocus) color = Colors.brown.shade100;

                  if (tapBoxIndex == "${index}-${indexChar}")
                    color = Colors.blue.shade100;

                  if (this.isFinish)
                    colorText = Colors.white;
                  else if (blokChar.isExist) colorText = Colors.red;
                  return Container(
                    color: color,
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: blokChar.isDefault
                            ? null
                            : () => setFocus(index, indexChar),
                        child: Text(
                          "${blokChar.text}",
                          style: TextStyle(
                            color: colorText,
                          ),
                        )),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void checkFinish() {
    int totalUnfinish = boxInners
        .map((e) => e.blokChars)
        .expand((element) => element)
        .where((element) => !element.isCorrect)
        .length;

    isFinish = totalUnfinish == 0;
  }

  generatePuzzle() {
    // install plugins sudoku generator to generate one
    boxInners.clear();
    var sudokuGenerator = SudokuGenerator(emptySquares: 54); //54
    // then we populate to get a possible cmbination
    // Quiver for easy populate collection using partition
    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList();
    partition(sudokuGenerator.newSudoku,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList()
        .asMap()
        .entries
        .forEach(
      (entry) {
        List<int> tempListCompletes =
            completes[entry.key].expand((element) => element).toList();
        List<int> tempList = entry.value.expand((element) => element).toList();

        tempList.asMap().entries.forEach((entryIn) {
          int index =
              entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() +
                  (entryIn.key % 9).toInt() ~/ 3;

          if (boxInners.where((element) => element.index == index).isEmpty) {
            boxInners.add(BoxInner(index, []));
          }

          BoxInner boxInner =
              boxInners.where((element) => element.index == index).first;

          boxInner.blokChars.add(BlokChar(
            entryIn.value == 0 ? "" : entryIn.value.toString(),
            index: boxInner.blokChars.length,
            isDefault: entryIn.value != 0,
            isCorrect: entryIn.value != 0,
            correctText: tempListCompletes[entryIn.key].toString(),
          ));
        });
      },
    );

    // complete generating a sudoku puzzle
  }

  Widget numBtn(String num) {
    return ClipOval(
      child: Material(
        color: Colors.blueGrey[400], // Button color
        child: InkWell(
          splashColor: Colors.orange, // Splash color
          onTap: () => setInput(int.parse(num)),
          child: SizedBox(
            width: 54,
            height: 54,
            child: Center(
              child: Text(
                num,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget numPad() {
    return Column(
      children: [
        Row(
          children: [
            numBtn('1'),
            const SizedBox(width: 10),
            numBtn('2'),
            const SizedBox(width: 10),
            numBtn('3'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            numBtn('4'),
            const SizedBox(width: 10),
            numBtn('5'),
            const SizedBox(width: 10),
            numBtn('6'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            numBtn('7'),
            const SizedBox(width: 10),
            numBtn('8'),
            const SizedBox(width: 10),
            numBtn('9'),
          ],
        ),
      ],
    );
  }

  setFocus(int index, int indexChar) {
    tapBoxIndex = "$index-$indexChar";
    focusClass.setData(index, indexChar);
    showFocusCenterLine();
    setState(() {});
  }

  void showFocusCenterLine() {
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    for (var element in boxInners) {
      element.clearFocus();
    }

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach(
        (e) => e.setFocus(focusClass.indexChar!, Direction.Horizontal));

    boxInners
        .where((element) => element.index % 3 == colNoBox)
        .forEach((e) => e.setFocus(focusClass.indexChar!, Direction.Vertical));
  }

  setInput(int? number) {
    // set input data based grid
    // or clear out data
    if (focusClass.indexBox == null) return;
    if (boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text ==
            number.toString() ||
        number == null) {
      boxInners.forEach((element) {
        element.clearFocus();
        element.clearExist();
      });
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setEmpty();
      tapBoxIndex = null;
      isFinish = false;
      showSameInputOnSameLine();
    } else {
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setText("$number");

      showSameInputOnSameLine();

      checkFinish();
    }

    setState(() {});
  }

  void showSameInputOnSameLine() {
    // show duplicate number on same line vertical & horizontal so player know he or she put a wrong value on somewhere

    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    String textInput =
        boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text!;

    boxInners.forEach((element) => element.clearExist());

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Horizontal));

    boxInners.where((element) => element.index % 3 == colNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Vertical));

    List<BlokChar> exists = boxInners
        .map((element) => element.blokChars)
        .expand((element) => element)
        .where((element) => element.isExist)
        .toList();

    if (exists.length == 1) exists[0].isExist = false;
  }
}
