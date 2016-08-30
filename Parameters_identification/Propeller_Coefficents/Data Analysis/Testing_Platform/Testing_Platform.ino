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

/* Tachimeter*/
int IR_Pin = 7;           //Pin where IR-Cathode is attached
float R = 12.4;           //Distance from propeller axis and laser beam
float L = 2.2;            //Propeller chord at distance R from axis (approx of length of the arc)
float k = (L / R) / 3.14; //L/R is the radiant that divided by 3.14 give me one minus duty cycle
float OME;                //Speed rotation [rad/s]

void setup() {
  /*Initialization*/
  Serial.begin(9600);
  BL.attach(BL_Pin);
  delay(10);
  BL.writeMicroseconds(1000);
  delay(3000);
  OS = SF * ReadINA(INA_Pin);

  /*GUI*/
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
  Serial.print("Throttle[%]");
  Serial.print("\t");
  Serial.print("Omega[rad/s]");
  Serial.print("\t");
  Serial.print("Thrust[N]");
  Serial.println("\t");
  
  /*Data acquisition*/
  Serial.print(0);
  Serial.print("\t");
  Serial.print(0);
  Serial.print("\t");
  T = SF * ReadINA(INA_Pin) - OS;
  Serial.println(T);
  delay(3000);
  
  for (i = 1; i <= 10; i++) {
    BL.writeMicroseconds(1000 + 100 * i); //I increment throttle at step of 10%
    Serial.print(i * 10);
    delay(3000);
    Serial.print("\t");
    OME = ReadTACHI(IR_Pin);
    Serial.print(OME);
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

float ReadTACHI(int pin) {
  int t_high = 0;
  float T = 0;
  float f = 0;
  int i = 0;
  float OME;
  for (i = 0; i < 5; i++) {
    t_high = pulseIn(pin, HIGH);
    T = t_high / (1 - k);   //Get Period from t_high and duty cycle
    T = T / 1000000;        //Converting uS in S
    f += 1/T;
  }
  f = f / 5;  
  OME = (f/2) * 2*3.14;
  return OME;
}
