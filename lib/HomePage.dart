import 'dart:async';
import 'package:flappy_birds/barrier.dart';
import 'package:flappy_birds/bird.dart';
import 'package:flutter/material.dart';
import 'coverscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bird variables
  static double birdY = 0;
  double initialPos = birdY;
  double time = 0;
  double height = 0;
  double gravity = -4.9; // how strong the gravity is
  double velocity = 3.5; // how strong the jump is
  double birdWidth = 0.1; // out of 2, 2 being the entire width of the screen
  double birdHeight = 0.1; // out of 2, 2 being the entire height of the screen
  static double barrierXone = 1.5;
  double barrierXtwo = barrierXone + 2;
  static int score = 0;
  static int bestScore = 0;
  Timer? scoreTimer;

  //game setting
  bool gameHasStarted = false;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  get barrierPassed => null;

  void begin() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      // A real physical jump is the same as an upside down parabola
      //so this is a simple quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
        // barrierXone -= 0.05;
        // barrierXtwo -= 0.05;
      });
      setState(() {
        if (barrierXone < -2) {
          barrierXone += 3.5;
        } else {
          barrierXone -= 0.05;
        }
      });
      setState(() {
        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      //check if bird is dead
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }

      // keep the map moving (move barriers)
      moveMap();

      // keep time going
      time += 0.1;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      // keep barriers moving
      setState(() {
        barrierX[i] -= 0.005;
      });

      // if barrier exits the left part of the screen, keep it looping
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
      score++;
    }
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 2 + 1.5];
      score = 0;
    });
  }

  void _showDialog() {
    if (score > bestScore) {
      bestScore = score + 2;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: Center(
              child: Text(
                "G A M E  O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your Time: $score",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  "Best Time: $bestScore",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      "PLAY AGAIN",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    //check if the bird is hitting the top or the bottom of the screen
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    // hits barriers
    //check if bord is within x coordinates and y coordinates of barries
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : begin,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Color.fromARGB(255, 170, 214, 250),
                child: Center(
                  child: Stack(
                    children: [
                      BlueBird(
                        birdY: birdY,
                        birdHeight: birdHeight,
                        birdWidth: birdWidth,
                      ),

                      //tap to play
                      MyCoverScreen(gameHasStarted: gameHasStarted),

                      // Top barrier 0
                      AnimatedContainer(
                        alignment: Alignment(barrierXone, 1.1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: 200.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXone, -1.1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: 200.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXtwo, 1.1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: 150.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXtwo, -1.1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: 250.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$score',
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'T I M E',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$bestScore',
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'B E S T',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
