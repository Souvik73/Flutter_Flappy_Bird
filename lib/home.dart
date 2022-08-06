import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flappy_bird/barriers.dart';
import 'package:flutter_flappy_bird/bird.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static double birdYaxis = 0;
  double time = 0, height = 0;
  double initialHeight = birdYaxis;
  bool gameStarted = false;

  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.8;

  double barrierOneSize = 100;
  double barrierTwoSize = 100;

  double score = 0;
  double best = 0;

  // static List<double> barrierX = [2, 2+1.5];
  // static double barrierwidth = 0.5;
  // List<List<double>> barrierHeight = [
  //   [0.6, 0.4],
  //   [0.4, 0.6],
  // ];

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdYaxis = 0;
      gameStarted = false;
      time = 0;
      initialHeight = birdYaxis;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.8;
    });
  }

  void startGame() {
    gameStarted = true;
    Timer.periodic(const Duration(milliseconds: 70), (timer) {
      time += 0.04;

      height = -4.9 * time * time + 3 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });

      setState(() {
        score += time * 1.2;
        if (barrierXone < -2) {
          barrierXone += 3.5;
          barrierOneSize = barrierOneSize == 100 ? 200 : 100;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
          barrierTwoSize = barrierOneSize == 100 ? 200 : 100;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      if (birdIsDead()) {
        if (score > best) {
          setState(() {
            best = score;
          });
        }
        setState(() {
          score = 0;
        });

        timer.cancel();
        _showDialog();
        gameStarted = false;
      }
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Center(
            child: Text(
              "G A M E  O V E R",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  color: Colors.white,
                  child: const Text(
                    "PLAY AGAIN",
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  

  bool birdIsDead() {
    if (birdYaxis > 1 || birdYaxis < -1) {
      return true;
    }
    // double playHeight = 2*MediaQuery.of(context).size.height/3;
    // playHeight /=2;
    // double checkOne = (playHeight-barrierOneSize)/playHeight;
    // if(birdYaxis > checkOne && barrierXone==0){
    //   return true;
    // }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(2*MediaQuery.of(context).size.height/3);
        if (gameStarted == true) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(
                      milliseconds: 0,
                    ),
                    color: Colors.blue,
                    child: const MyBird(),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: const Duration(
                      milliseconds: 0,
                    ),
                    child: MyBarrier(
                      size: barrierOneSize,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: const Duration(
                      milliseconds: 0,
                    ),
                    child: MyBarrier(
                      size: barrierTwoSize,
                    ),
                  ),
                  Container(
                    alignment: const Alignment(0.0, -0.35),
                    child: gameStarted
                        ? const Text("")
                        : const Text(
                            "T A P  T O  P L A Y",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  color: Colors.brown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Score",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            score.ceil().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Best",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            best.ceil().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
