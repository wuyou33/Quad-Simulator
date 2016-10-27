/* Brushless settings*/
#include <Servo.h>
int BL_Pin = 3;           //Pin where ESC is attached 
Servo BL;                 //Define "BL" servo

/* Load Cell settings*/
int INA_Pin = A1;         //Pin where INA is attached 
float OS = 0;             //Offset initialization
float sens = 1.398/0.86;  //Sensitivity [kg/V]
float SF = sens * 9.81;   //Conversion from kg to N
float T;                  //Thrust [kg]

/* Data to be acquired */
int t0;
int throttle[600];
float thrust[600];
float time[600];

void setup() {
  /*Initialization*/
  Serial.begin(9600);
  BL.attach(BL_Pin);
  delay(10);
  BL.writeMicroseconds(1000);
  delay(1000);
  OS = ReadINA(INA_Pin);
 
  /*GUI*/  
  Serial.println("Press any button to start the test\n");
  do {
    delay(1);
  } while (Serial.available() == 0);
  Serial.println("WARNING: Rotating propeller is dangerous!\n");
  int i = 0;
  for (i = 0; i < 5; i++) {
    Serial.print("t-");
    Serial.println(5 - i);
    delay(1000);
    }
  Serial.println("");
  Serial.print("Time [ms]");
  Serial.print("\t");
  Serial.print("Throttle [%]");
  Serial.print("\t");
  Serial.print("Thrust [N]");
  Serial.println("\t");
  
  BL.writeMicroseconds(1100);
  
  /*Data acquisition*/
  delay(1000);
  t0 = millis();
  for (i = 0; i < 100; i++) {
    throttle[i] = 10;
    time[i] = millis() - t0;
    BL.writeMicroseconds(1000 + 10 * throttle[i]);
    delay(1);
    thrust[i] = SF * ReadINA(INA_Pin);
    }
  for (i = 0; i < 500; i++) {
    throttle[i+100] = 30;
    time[i+100] = millis() - t0;
    BL.writeMicroseconds(1000 + 10 * throttle[i+100]);
    delay(1);
    thrust[i+100] = SF * ReadINA(INA_Pin);
    }
  BL.writeMicroseconds(1000);    
  
  /*Data output*/
  for (i = 0; i < 600; i++) {
    Serial.print(time[i]);
    Serial.print("\t");
    Serial.print(throttle[i]);
    Serial.print("\t");
    Serial.print(thrust[i]);
    Serial.println("\t");
    }
  Serial.println("");
  Serial.println("TEST COMPLETED!");
}

void loop() {
}

float ReadINA(int pin){
  int i;
  float store = 0;
  for(i=0; i<20; i++){
    store += analogRead(pin);
  }
  int Value = store/i;
  float Volt = (5.0/1023.0) * Value - OS;
  return Volt;
}
