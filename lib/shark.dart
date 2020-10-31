
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oceanmaster/game.dart';
import 'package:oceanmaster/gameobject.dart';

import 'dart:math';

// Create a random number generator object
var rng = Random();


class Shark extends GameObject {
  
  bool bloodchunk;  // track if blood chunk for collision purposes

  // Create shark object and place on screen
  Shark(double componentSize, sz) : super(componentSize, 'shark.png')  {
    this.bloodchunk = false;
    // Set random x position within screen for sporadic spawning purposes
    super.x =  rng.nextDouble() * (sz.width - componentSize);
    super.y = 0;
    super.vy = rng.nextDouble() * 60.0 + 16.0;
    super.vx = 0.0;
    super.sz = sz;
  }

  // Create blood chunk
  Shark.makechunk( double x, double y, double vx, double vy, double componentSize, Size sz) : super(componentSize, 'blood.png' ) {
    this.bloodchunk = true;
    // Set the x,y position and the velocity for this asteroid
    super.x =  x;
    super.y =  y;    
    super.vy = vy;
    super.vx = vx;
    super.sz = sz;
  }

  bool checkbf(){
    return bloodchunk;
  }

  //updates the object every game loop
  @override 
  void update(double t) {
    x += vx * 2 * t;
    y += vy * 2 * t;
    if ( y > max( sz.width, sz.height) ) {
      remove = true; //removes object if it leaves the bounds of the screen
    }
  }
  
  // removes shark object from object list
  @override 
  bool destroy() {
    return remove;
  }

  // allows the objects to be resized according to screen
  @override
  void resize(Size size) {
    // Set the sz of the screen to the new sz
    this.sz = size;
  }

  // chunk velocities
  double randomv( double x )   { 	return ( (0.1 * x) - ( rng.nextDouble() * 0.20 * x)) + x;   }

  // chunk size
  double randomsz( )   { 	return rng.nextDouble() * 13.0 + 7.0;   }


  // turn the shark into bloodchunks on collision with raft
  void explodes(Game controller) 
  {
    // Mark for removal
    this.remove = true;
    if ( this.bloodchunk ) return;

    // mark this as a fragment to prevent it from blowing up again!
    this.bloodchunk = true; 

    //Chunk velocity variables
    double w = width/2.0;
    double h = height/2.0;
  	double fx = x + w;
		double fy = y + h;
		double fvx = vx;
		double fvy = vy;  
    double sin45 = sin(pi/4.0);

    double chunkVelocity = 10.0 * rng.nextDouble() + 5.0;
	
  //add a series of bloodchunks to the objectslist and assign them separate velocities on separate axis.
		fvx = vx - randomv(chunkVelocity) * sin45;
		fvy = vy - randomv(chunkVelocity) * sin45;
    Shark frag = new Shark.makechunk(fx+fvx, fy+fvy, fvx, fvy, randomsz(), this.sz );
		controller.add( frag );
    controller.objectsList.add(frag);

		fvx = vx;
		fvy = vy - randomv(chunkVelocity);
    frag = new Shark.makechunk(fx+fvx, fy+fvy, fvx, fvy, randomsz(), this.sz );
		controller.add( frag );
    controller.objectsList.add(frag);

		fvx = vx + randomv(chunkVelocity) * sin45;
		fvy = vy - randomv(chunkVelocity) * sin45;
    frag = new Shark.makechunk(fx+fvx, fy+fvy, fvx, fvy,randomsz() , this.sz );
		controller.add( frag );
    controller.objectsList.add(frag);

		fvx = vx;
		fvy = vy + randomv(chunkVelocity);
    frag = new Shark.makechunk(fx+fvx, fy+fvy, fvx, fvy, randomsz(), this.sz );
		controller.add( frag );
    controller.objectsList.add(frag);
  }

  //this function was provided entirely by Kent Jone's Asteroids game. I didn't need it for the game to function, but it made the sharks more fun.
  void exchangeMomentum( GameObject o )//allows the sharks and blood objects to move once collided.
  //makes the sharks more interesting, and moves them out of the way when player dies.
  {
    // dont exchange momentum with dead objects
    if ( o.remove ) return;

    // we currently assume all objects have the same mass...
    // and an elastic collision. Would be easy to change to a more realistic collision
    double tvx, tvy;
    tvx = o.vx; o.vx = vx; vx = tvx;
    tvy = o.vy; o.vy = vy; vy = tvy;  
    
    // Modify the objects positions so they are not intersecting
    double overlapx = width - (x - o.x).abs();
    double overlapy = height - (y - o.y).abs();
    if ( overlapx > 0.0 && overlapy > 0.0 )
    {
      if ( overlapx < overlapy )
      {
        if ( x < o.x )
        {	o.x += overlapx/2;
          x -= overlapx/2;
        }
        else
        {	x += overlapx/2;
          o.x -= overlapx/2;
        }
      }
      else
    {
          if ( y < o.y )
          {	o.y += overlapy/2;
            y -= overlapy/2;
          }
          else
          {	y += overlapy/2;
            o.y -= overlapy/2;
          }
      }
    }
  }
}