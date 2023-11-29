import 'package:flutter/material.dart';
import 'package:note_blocks/left_overs/attempt.dart';
import 'package:note_blocks/left_overs/attempt2.dart';
import 'package:note_blocks/attempt3.dart';
import 'package:note_blocks/left_overs/home_screen.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner:  false,
      home: Home3(),
    );
  }
}