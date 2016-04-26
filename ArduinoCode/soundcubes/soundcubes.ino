const int numCubes = 3;

int greenLedPins[] = {2, 4, 6};
int redLedPins[] = {3, 5, 7};

int OFF = 0;
int WRONG = 1;
int CORRECT = 2;

// Save stuff read from serial port in buffer
char buffer[2 * numCubes + 2] = { '\0' };

void setup() {
  Serial.begin(9600);

  // Turn all digital pins to outputs
  for (int i = 2; i < 13; ++i) {
    pinMode(i, OUTPUT);
    digitalWrite(i, LOW);
  }
}

void loop() {
  while (Serial.available() >= 2 * numCubes + 1) {
    for (int i = 0; i < 2 * numCubes + 1; ++i) {
      buffer[i] = Serial.read();
    }

    for (int i = 0; i < numCubes; ++i) {
      // Convert ASCII byte to corresponding integer.
      int status = buffer[2*i] - '0';
      int redLedPin = redLedPins[i];
      int greenLedPin = greenLedPins[i];
      if (status == OFF) {
        // Both LEDs off
        digitalWrite(redLedPin, LOW);
        digitalWrite(greenLedPin, LOW);
      } else if (status == WRONG) {
        // Red LED on, green LED off
        digitalWrite(greenLedPin, LOW);
        digitalWrite(redLedPin, HIGH);
      } else if (status == CORRECT) {
        // Red LED off, green LED on
        digitalWrite(greenLedPin, HIGH);
        digitalWrite(redLedPin, LOW);
      }
    }
  }
}

