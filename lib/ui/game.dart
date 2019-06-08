import 'dart:math';
import 'package:first_game/systems/systems.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

systems s = systems();

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  Animation<double> bA, tA;
  AnimationController bC, tC;
  double bYP = 0, tYP = 0, bXP = 0, tXP = 0, x = 0;
  int c = 1;
  int eG = 0;
  var r = Random();

  @override
  Widget build(BuildContext context) {
    if (bXP > tXP - 0.15 && bXP < tXP + 0.15) {
      if (bYP < tYP) {
        setState(() {
          c++;
          if (r.nextBool())
            tXP = r.nextDouble();
          else
            tXP = -r.nextDouble();
        });
        bC.reset();
        i();
      }
    }

    if (eG == 1 && bA.value == 1) {
      bXP = x;
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                'images/field.jpeg',
                width: 500,
                height: 1200,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: 500,
              height: 1200,
              child: eG != 1
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "Box Shooter",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                              ),
                            ),
                          ),
                          Text(
                            "Score: ${c - 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              it();
                              eG = 1;
                              c = 1;
                              i();
                            },
                            child: Icon(
                              (eG == 2) ? Icons.refresh : Icons.play_arrow,
                              color: Colors.white,
                              size: 60,
                            ),
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment(0.8, -0.9),
                                child: Text(
                                  "${c - 1}",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              StreamBuilder(
                                initialData: 1,
                                stream: s.bSG,
                                builder: (context, s) {
                                  bYP = s.data;
                                  return Align(
                                    alignment: Alignment(bXP, s.data),
                                    child: Image.asset(
                                      'images/shell.png',
                                      width: 40,
                                      height: 40,
                                    )
                                  );
                                },
                              ),
                              Align(
                                  alignment: Alignment(tXP, tYP),
                                  child: Image.asset(
                                    'images/creep.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill,
                                  ))
                            ],
                          ),
                        ),
                        StreamBuilder(
                          initialData: 0.0,
                          stream: s.hSG,
                          builder: (context, s) {
                            x = s.data;
                            return Align(
                              alignment: Alignment(s.data, 1),
                              child: Image.asset(
                                'images/tank.jpg',
                                height: 40,
                                width: 40,
                              ),
                            );
                          },
                        )
                      ],
                    ),
            )
          ],
        ));
  }

  void it() {
    bC =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    accelerometerEvents.listen((AccelerometerEvent e) {
      if ((-x * 5 - e.x).abs() > 0.1) {
        if (e.x < -5)
          s.addValue(1);
        else if (e.x > 5)
          s.addValue(-1);
        else {
          x = -double.parse(e.x.toStringAsFixed(1)) / 5;
          s.addValue(x);
        }
      }
    });
    i();
  }

  void i() {
    bYP = 1;
    tYP = -1;
    bA = Tween(begin: 1.0, end: -1.0).animate(bC)
      ..addStatusListener((e) {
        if (e == AnimationStatus.completed) {
          bC.reset();
          bC.forward();
        }
      })
      ..addListener(() {
        s.bS.add(bA.value);
      });

    bC.forward();
    tC = AnimationController(
        duration: Duration(milliseconds: c < 45 ? 10000 - (c * 200) : 1000),
        vsync: this);
    tA = Tween(begin: -1.0, end: 1.0).animate(tC)
      ..addListener(() {
        setState(() {
          tYP = tA.value;
        });
        if (tA.value == 1) {
          eG = 2;
        }
      });
    tC.forward();
  }
}
