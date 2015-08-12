/* Brushless settings*/
#include <Servo.h>
int BL_Pin = 3;           //Pin where ESC is attached 
Servo BL;                 //Define "BL" servo

void setup() {
  /*Initialization*/
  Serial.begin(9600);
  BL.attach(BL_Pin);
  delay(10);
  BL.writeMicroseconds(1000);
  delay(3000);

  Serial.println("Press any button to start the calibration (remove the propeller)\n");
  do {
    delay(1);
  } while (Serial.available() == 0);
  Serial.println("Unplug the battery from the ESC\n");
  delay(3000);    
  BL.writeMicroseconds(2000);
  Serial.println("Plug it in again\n");
  delay(4000);
  BL.writeMicroseconds(1000);
  Serial.println("Done\n");
}

void loop() {
  // put your main code here, to run repeatedly:

}
