import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 140),
              child: Image.asset(
                "assets/logo.png",
                width: MediaQuery.of(context).size.width,
                height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  btn("Play", context),
                  btn("Score", context),
                  btn("Contact", context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget btn(String text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 50),
    child: SizedBox(
      width: 200,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue[300],
          elevation: 6.0,
        ),
        onPressed: () {
          print("${text} button pressed");
          if (text == "Play") {
            Navigator.pushNamed(context, '/game');
          }
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
