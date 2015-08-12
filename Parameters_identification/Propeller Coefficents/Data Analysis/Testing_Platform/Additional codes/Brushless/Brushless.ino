/* Brushless */
#include <Servo.h>
int BL_Pin = 3;
Servo BL; 
int input;
int vel;
int idle = 54;
int i;

void setup(){  
  Serial.begin(9600);
  
  Serial.println("Throttle[%]");
  
  BL.attach(BL_Pin);
  delay(10);
  BL.write(idle);
  delay(3000);
  
  for(i = 0; i <= 10; i++){
    BL.write(idle+1+7*i);
    Serial.println(i*10);
    delay(2000);
    }
    
  BL.write(idle);
}

void loop(){
//
//    if(Serial.available() > 0){
//    input = Serial.read();
//    
//    if(input == 115){  //'s' Stoppa il motore
//      vel = 54;
//    }
//    if(input == 43){  //'+' Incrementa
//      vel++;
//    }
//    if(input == 45){  //'-' Decrementa
//      vel--;
//    }
//    
//    if(vel < 0){
//      vel = 0;
//    }
//    if(vel > 180){
//      vel = 180;
//    }
//    
//    Serial.println(vel);    
//    BL.write(vel);
//  } 
//  
}
