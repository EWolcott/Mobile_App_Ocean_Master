
import 'package:flutter/material.dart';
import 'package:flame/components/component.dart';
import 'package:flutter/rendering.dart';


class GameObject extends SpriteComponent {
  
  double componentSize; // object size
  Size sz; // object boundaries
  bool remove; // destroy object boolean
  double vx, vy; // velocity vectors

  GameObject(double componentSize, String imagePath) : super.square(componentSize, imagePath) {
    this.componentSize = componentSize;
    this.remove = false;
  }

}