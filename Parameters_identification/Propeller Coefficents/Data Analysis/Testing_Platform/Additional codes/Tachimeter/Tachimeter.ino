/* Tachimeter*/
int IR_Pin = 7;
float OME;
float L = 1.75;
float R = 12.5;
float k = (L / R) / 3.14;

void setup() {
  Serial.begin(9600);
  pinMode(IR_Pin, INPUT);
}

void loop() {
  OME = ReadTACHI(IR_Pin);
  Serial.println(OME);
  
  delay(100);
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
