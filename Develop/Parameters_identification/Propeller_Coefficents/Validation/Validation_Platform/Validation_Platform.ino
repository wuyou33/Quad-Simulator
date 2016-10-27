/* Brushless settings*/
#include <Servo.h>
int BL_Pin = 3;           //Pin where ESC is attached 
Servo BL;                 //Define "BL" servo
float th;

/* Load Cell settings*/
int INA_Pin = A1;         //Pin where INA is attached 
float OS = 0;             //Offset initialization
float sens = 1.398/0.86;  //Sensitivity [kg/V]
float SF = sens * 9.81;   //Conversion from kg to N
float T;                  //Thrust [kg]

/* Desired parameters */
float m = 6.0312;
float q = 80.4859;
float Kt = 2.4620*pow(10,-5);

void setup() {
  /*Serial and brushless initialization*/
  Serial.begin(9600);
  BL.attach(BL_Pin);
  delay(10);
  BL.writeMicroseconds(1000);
  delay(3000);
  OS = SF * ReadINA(INA_Pin);
  Serial.println("Press any button to start the test\n");
  do {
    delay(1);
  } while (Serial.available() == 0);
  Serial.println("WARNING: Rotating propeller is dangerous!\n");
  int i;
  for (i = 0; i < 5; i++) {
    Serial.print("t-");
    Serial.println(5 - i);
    delay(1000);
  }
  Serial.println("");
  Serial.print("Thrust_r [N]");
  Serial.print("\t");
  Serial.print("Thrust_o [N]");
  Serial.println("\t");
  
  /*Data acquisition*/
  Serial.print(0);
  delay(1000);
  Serial.print("\t");
  T = SF * ReadINA(INA_Pin) - OS;
  Serial.println(T);
  
  for (i = 1; i <= 10; i++) { 
    th = (sqrt(i/Kt) - q) / m;
    BL.writeMicroseconds(1000 + 10*th); //I increment throttle at step of 1N
    Serial.print(i);
    delay(3000);
    Serial.print("\t");
    T = SF * ReadINA(INA_Pin) - OS;
    Serial.println(T);
  }
  BL.writeMicroseconds(1000);
  Serial.println("");
  Serial.println("TEST COMPLETED!");
}

void loop() {
}

float ReadINA(int pin){
  int i;
  float store = 0; 
  for(i=0; i<100; i++){
    store += analogRead(pin);
  }
  int Value = store/i;
  float Volt = (5.0/1023.0) * Value;
  return Volt;
}
