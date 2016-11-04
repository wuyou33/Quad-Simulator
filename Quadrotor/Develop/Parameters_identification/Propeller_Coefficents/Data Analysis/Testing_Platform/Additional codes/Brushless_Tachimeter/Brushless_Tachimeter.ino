/* Brushless */
#include <Servo.h>
int BL_Pin = 3;
Servo BL; 
int input;
int vel;
int idle = 54;
int i;
/* Tachimeter*/
int IR_Pin = 7;
float OME;
float L = 1.75;
float R = 12.5;
float k = (L / R) / 3.14;

void setup(){  
  Serial.begin(9600);
  pinMode(IR_Pin, INPUT);
  
  Serial.print("Throttle[%]");
  Serial.print("\t");
  Serial.println("Omega[rad/s]");
  
  BL.attach(BL_Pin);
  delay(10);
  BL.write(idle);
  delay(3000);
  
  for(i = 0; i <= 10; i++){
    BL.write(idle+1+7*i);
    Serial.print(i*10);
    delay(2000);
    Serial.print("\t");  
    OME = ReadTACHI(IR_Pin);
    Serial.println(OME);
    }
    
  BL.write(idle);
}

void loop(){

}

float ReadTACHI(int pin){
  int T_low = 0;
  float T = 0;
  float f = 0;
  int i = 0;
  float OME;
  
  for(i = 0; i <10 ; i++){
    T_low = pulseIn(pin, LOW);
    T = T_low / (1000*k);
    f += 1000/T;
    }
  f = f/10;
  
  OME = f * 3.14;
  
  return OME;
}
