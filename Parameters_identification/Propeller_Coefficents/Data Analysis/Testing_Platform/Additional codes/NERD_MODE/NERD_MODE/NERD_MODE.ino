/* Brushless */
#include <Servo.h>
int BL_Pin = 3;
Servo BL; 
int idle = 54;
int i;

// TONES  =======================================================
// Start by defining the relationship between note and throttle
#define c 61  
#define d 69
#define e 76 
#define f 82 
#define g 93 
#define a 103 
#define b 116  
#define C 124
// Define a special note, 'R', to represent a rest
#define R idle

// MELODY and TIMING  ===========================================
//  melody[] is an array of notes, accompanied by beats[], 
//  which sets each note's relative length (higher #, longer note) 

//Tetris
//int melody[] = { C, g, a,  b, a, g,  f, R, f, a,  C, b, a, g,  a,  b,  C,  a,  f, R,  f};
//int beats[]  = {10, 5, 5, 10, 5, 5, 10, 1, 5, 5, 10, 5, 5, 15, 5, 10, 10, 10, 10, 1, 10}; 

//Fra Martino
int melody[] = {c, d, e, c,  c, d, e, c,  d, f,  g,  d, f,  g,  g, a, g, f, d,  c,   g, a, g, f,  d,  c,  d,  f,  c,   d,  f,  c };
int beats[]  = {5, 5, 5, 5,  5, 5, 5, 5,  5, 5, 10,  5, 5, 10,  5, 5, 5, 5, 10, 10,  5, 5, 5, 5, 10, 10,  10, 10, 10,  10, 10, 10 }; 


int MAX_COUNT = sizeof(melody); // Melody length, for looping.

void setup(){    
  BL.attach(BL_Pin);
  delay(10);
  BL.write(idle);
  delay(3000);
  
  for(i = 0; i < MAX_COUNT; i++){
    BL.write(melody[i]);
    delay(100*beats[i]);
    }
    
  BL.write(idle);
}

void loop(){

}

