import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/rendering.dart';
import 'package:oceanmaster/raft.dart';
import 'package:oceanmaster/shark.dart';
import 'package:oceanmaster/gameobject.dart';


double touchPositionDx = 0.0;
double touchPositionDy = 0.0;

class Game extends BaseGame {
  
  Size sz;
  Raft raft;
  Shark shark;
  bool endgame = false;
  bool death = false;

  List<GameObject> objectsList = <GameObject>[];
  
  Game(this.sz) {
    raft = Raft(40.0, sz);  // build the raft
    add( raft );      // add raft 
    objectsList.add(raft);     
  }

var bgm = Flame.audio.loop('bgm.mp3', volume: 50); //loop background music



    // now this file will be loaded from assets/audio/explosion.mp3
double creationTimer = 0.0; // controls the spawn rate for sharks

  // Render the canvas and display endgame message if raft reaches top of the screen
  void render(Canvas canvas) {
    super.render(canvas);
    if(endgame == true){
    String text = "YOU MADE IT!";
    TextPainter textPainter = Flame.util.text(text, color: Colors.orange, fontSize: 56.0);
    textPainter.paint(canvas, Offset(sz.width/36, sz.height/2 ));
    }
     if(death == true){
    String text = "FAILURE";
    TextPainter textPainter = Flame.util.text(text, color: Colors.red, fontSize: 90.0);
    textPainter.paint(canvas, Offset(sz.width/32, sz.height/2 ));
    }
  }

  //imports the rectangles for objects and compares their position for collsions
  bool collides( Rect a, Rect b )  { 
    if ( a.left > b.right || b.left > a.right ) return false;
    if ( a.top > b.bottom || b.top > a.bottom ) return false;
    return true;
  }
double mocktimer = 0.0; //displays failure message

  /// Update the canvas and game
  void update(double t) {
     // spawn new sharks every 1.2 seconds
    creationTimer += t;
    if ( creationTimer >= 1.2 ) {
      creationTimer = 0.0;
      shark = Shark(40.0, sz);
      objectsList.add(shark);
      add(shark);
    }
    //displays failure message
    if (death == true){
    mocktimer += t;
    if ( mocktimer >= 1.5 ) {
      death = false;
      mocktimer = 0.0;
    }
    }
    // Check for collisions between objects
    for ( var i=0; i < objectsList.length; i++ ) {
      for ( var j = i+1; j < objectsList.length; j++ ) {
        //check for endgame reached
        if (objectsList[i] is Raft && (objectsList[i] as Raft).checksurvived() == true){
         endgame = true; 
        }
        Rect a = objectsList[i].toRect();
        Rect b = objectsList[j].toRect();
        // check for collision between 
        if ( collides(a,b) ) {
           if ( (objectsList[i] is Raft) && (objectsList[j] is Shark) && (objectsList[j] as Shark).checkbf() == false) {
            (objectsList[j] as Shark).explodes(this);
            objectsList[i].remove = true;
            raft = Raft(40.0, sz);  // builds a new raft
            add( raft );      // Add a raft component
            objectsList[i] = raft;
            death = true; //throw the raft into the objects list
            Flame.audio.play('groan.mp3', volume: 25); //death rattle
            break;
          }
          else if ( (objectsList[i] is Shark) && (objectsList[j] is Shark) ) {
            (objectsList[i] as Shark).exchangeMomentum(objectsList[j] as Shark); //used Kent Jone's function to make the sharks more exciting
          }
        }
      }
    }

    // remove items from lists
    objectsList.removeWhere( (o) => o.remove );
    super.update(t);
  }

  void tapInput(Offset position) { //track the touch inputs to direct raft
    touchPositionDx = position.dx;
    touchPositionDy = position.dy;
    // direct raft
    if ( (touchPositionDx - raft.x) > 0 ) {
      raft.vx = raft.vx.abs();
    } else if ( (touchPositionDx - raft.x) < 0 ) {
      raft.vx = -raft.vx.abs(); 
    }
    if ( (touchPositionDy - raft.y) > 0 ) {
      raft.vy = raft.vy.abs();
    } else if ( (touchPositionDy - raft.y) < 0 ) {
      raft.vy = -raft.vy.abs(); 
    }
  }

  void dragInput(Offset position) {
    touchPositionDx = position.dx;
    touchPositionDy = position.dy;
    // direct raft
    if ( (touchPositionDx - raft.x) > 0 ) {
      raft.vx = raft.vx.abs();
    } else if ( (touchPositionDx - raft.x) < 0 ) {
      raft.vx = -raft.vx.abs(); 
    }
    if ( (touchPositionDy - raft.y) > 0 ) {
      raft.vy = raft.vy.abs();
    } else if ( (touchPositionDy - raft.y) < 0 ) {
      raft.vy = -raft.vy.abs(); 
    }
  }

  // The Flame Game engine will update objects if the screen is resized
  void resize(Size size) {
    // Set the dimensions of the screen to the new dimensions
    this.sz = size;
  }

}