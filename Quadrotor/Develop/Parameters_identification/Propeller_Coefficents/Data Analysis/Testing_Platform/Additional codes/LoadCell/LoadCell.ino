/* Load Cell*/
int INA_Pin = A1;
float OS = 0;
float SF = 1.398/0.86; //Scale Factor [kg/V];
float T;

void setup() {
  Serial.begin(9600);
  OS = ReadINA(INA_Pin);
}

void loop() {
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

