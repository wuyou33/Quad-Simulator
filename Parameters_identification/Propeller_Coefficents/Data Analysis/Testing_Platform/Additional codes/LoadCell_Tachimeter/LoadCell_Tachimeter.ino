/* Load Cell*/
int INA_Pin = A1;
float OS = 0;
float SF = 1.033/0.67; //Scale Factor [kg/V];
float T;

/* Tachimeter*/
int IR_Pin = 7;
float OME;
float L = 1.75;
float R = 12.5;
float k = (L / R) / 3.14;

void setup() {
  Serial.begin(9600);
  pinMode(IR_Pin, INPUT);
  OS = ReadINA(INA_Pin);
  
  Serial.print("Omega[rad/s]");
  Serial.print("\t");
  Serial.println("Thrust[kg]");

}

void loop() {
  OME = ReadTACHI(IR_Pin);
  Serial.print(OME);
  Serial.print("\t");
  T = SF * ReadINA(INA_Pin);
  Serial.println(T);
  
  delay(100);
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
