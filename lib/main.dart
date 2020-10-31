// Exam 2 
// Mobile Application Development
// Created By Ethan Wolcott
// 4/24/2020
// This game was inspired by Kent Jone's Asteroids game, with help from
// https://blog.geekyants.com/building-a-2d-game-in-flutter-a-comprehensive-guide-913f647846bc
// music provided by Royalty free music from https://www.fesliyanstudios.com


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:oceanmaster/game.dart';
import 'package:oceanmaster/video.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.images.loadAll([
    'shark.png', 'raft.png', 'ocean.mp4', 'blood.png' // all the image and video assets to be loaded
  ]);

  Flame.audio.loadAll([
    'bgm.mp3', 'groan.mp3' // all the audio assets to be loaded
  ]);
  
  var sz = await Flame.util.initialDimensions();

  Game game = new Game(sz);

  runApp(
MaterialApp(
      
      home: SafeArea(
        child: Scaffold(
          // Stack widget for visibility order
          body: Stack(
            children: [
              // call the video element to place behind game
             BackgroundVideo(),
              GameWrapper(game)// call game
              
             
            ],
            
          ),
        ),
      ),
    ));


  Flame.util.addGestureRecognizer(
    new HorizontalDragGestureRecognizer  ()
      ..onStart = (details) {
        // call a game handler for the tap down event here
        game.tapInput(details.globalPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        // call a game handler for the tap up event here
        game.dragInput( details.globalPosition );
      }
    );


}

class GameWrapper extends StatelessWidget {
  final Game game;
  GameWrapper(this.game);
  @override 
  Widget build(BuildContext context) {
    return game.widget;
  }
}

