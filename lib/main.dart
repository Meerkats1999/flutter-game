import 'package:first_game/ui/game.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Bullshit Game",
    home: Game(),
  ));
}