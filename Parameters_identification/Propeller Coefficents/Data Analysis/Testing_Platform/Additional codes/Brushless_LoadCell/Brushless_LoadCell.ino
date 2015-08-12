/* Brushless */
#include <Servo.h>
int BL_Pin = 3;
Servo BL; 
int input;
int vel;
int idle = 54;
int i;
/* Load Cell*/
int INA_Pin = A1;
float OS = 0;
float SF = 1.033/0.67; //Scale Factor [kg/V];
float T;

void setup(){  
  Serial.begin(9600);
  OS = ReadINA(INA_Pin);
  
  Serial.print("Throttle[%]");
  Serial.print("\t");
  Serial.println("Thrust[kg]");
  
  BL.attach(BL_Pin);
  delay(10);
  BL.write(idle);
  delay(3000);
  
  for(i = 0; i <= 10; i++){
    BL.write(idle+1+7*i);
    Serial.print(i*10);
    delay(2000);
    Serial.print("\t");
    T = SF * ReadINA(INA_Pin);
    Serial.println(T);
    }
    
  BL.write(idle);
}

void loop(){

}

float ReadINA(int pin){
  int i;
  float store = 0;
  for(i=0; i<100; i++){
   store += analogRead(pin);
  }
  int Value = store/i;
  float Volt = (5.0/1023.0) * Value - OS;
  return Volt;
}
