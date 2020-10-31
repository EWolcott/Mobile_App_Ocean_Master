
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oceanmaster/gameobject.dart';


class Raft extends GameObject {

  double speed;  // raft speed
  bool survived = false; // bool to check if end of game reached

  // make the raft appear on the screen
  Raft(double componentSize, Size sz) : super(componentSize, 'raft.png') {
    this.resize(sz);
    speed = sz.longestSide * 0.075;
    super.vx = speed;
    super.vy = speed;
  }
// getter function for completion screen
bool checksurvived(){
  return survived;
}

  // updates the object and checks to see if it has collided with edges of screen. Bounces back if it has.
  //also checks to see if raft has reached top of screen and changes boolean to confirm.
  @override
  void update(double t) {
    this.x += this.vx * t;
    this.y += this.vy * t;
    // Check for collision with the left, and right boundaries
    if (this.x < 0.0) {
      this.x = 0.0;
      this.vx = -this.vx;
    } else if (this.vx >= 0.0 && this.x > (this.sz.width - this.componentSize)) {
      this.x = this.sz.width - this.componentSize;
      this.vx = -this.vx;
    }
    if (this.y < 0.0){
      survived = true;
    } 
  }

 //removes the raft object from the game object list
  @override
  bool destroy() {
    return remove;
  }

  // allows the screen to be resized
  @override
  void resize(Size size) {
    sz = size;
    x = sz.width / 2.0 - componentSize / 2.0;
    y = sz.height - 55 - componentSize;
    vy = 0.0;
    vx = 0.0;
  }
}
