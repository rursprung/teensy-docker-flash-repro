#include <Arduino.h>

void toggle_led() {
    digitalWrite(13, HIGH-digitalRead(13));
}

void setup() {
    pinMode(13, OUTPUT);
    Serial.begin(0); // teensy ignores the baud rate
    Serial.println("init done!");
}

void loop() {
    Serial.println("looping...");
    toggle_led();
    delay(500);
}
