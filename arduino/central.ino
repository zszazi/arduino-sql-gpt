#include <ArduinoBLE.h>
#include <ArduinoJson.h>
#include <U8g2lib.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN 6
Adafruit_NeoPixel strip = Adafruit_NeoPixel(60, PIN, NEO_GRB + NEO_KHZ800);

U8G2_SH1107_SEEED_128X128_F_HW_I2C u8g2(U8G2_R0, /* reset=*/U8X8_PIN_NONE);

const char* deviceServiceUuid = "19b10000-e8f2-537e-4f6c-d104768a1214";
const char* deviceServiceCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1214";
const int speakerPin = 4;
const int buttonPin = 2;

bool startCounting = false;
int payment = 0; 
int paidValue = -1;
char buffer[100];
String result;
BLEService peripheralService(deviceServiceUuid);
BLEByteCharacteristic firstCharacteristic(deviceServiceCharacteristicUuid, BLERead | BLEWrite);

void setup() {
#if defined(__AVR_ATtiny85__)
  if (F_CPU == 16000000) clock_prescale_set(clock_div_1);
#endif

  strip.begin();
  strip.setBrightness(50);
  strip.show();
  pinMode(buttonPin, INPUT);
  pinMode(speakerPin, OUTPUT);
  u8g2.begin();
  colorWipe(strip.Color(255, 0, 0), 50);  // Red

  Serial.begin(9600);
  while (!Serial)
    ;

  Serial.println("Waiting for the Python Input into Serial Port");
  while (Serial.available() == 0) {
    // Wait for serial input
  }
  // Read JSON data
  String jsonStr = Serial.readStringUntil('\n');

  // Parse JSON
  DynamicJsonDocument doc(1024);
  deserializeJson(doc, jsonStr);
  int costFromArduino2 = 0;
  // Extract values from JSON
  payment = doc["cost"];
  result = doc["result"].as<String>();
  colorWipe(strip.Color(0, 255, 0), 50);  // Green
  Serial.print("cost - ");
  Serial.println(payment);
  Serial.print("result - ");
  Serial.println(result);
  if (!BLE.begin()) {
    Serial.println("- Starting Bluetooth® Low Energy module failed!");
    while (1)
      ;
  }

  BLE.setLocalName("Arduino Nano 33 BLE (Peripheral)");
  BLE.setAdvertisedService(peripheralService);
  peripheralService.addCharacteristic(firstCharacteristic);
  BLE.addService(peripheralService);
  firstCharacteristic.writeValue(-1);
  BLE.advertise();

  Serial.println("Nano 33 BLE (Peripheral Device)");
  Serial.println(" ");
  u8g2.clearBuffer();
  u8g2.sendBuffer();
  u8g2.setFont(u8g2_font_ncenB08_tr);


  snprintf(buffer, sizeof(buffer), "Get your Answers from <>");
  u8g2.drawStr(0, 20, buffer);

  snprintf(buffer, sizeof(buffer), "Pushups to do : %d", payment);
  u8g2.drawStr(0, 40, buffer);

  u8g2.sendBuffer();
}

void loop() {
  BLEDevice central = BLE.central();
  Serial.println("- Discovering central device...");
  delay(500);

  if (central) {
    Serial.println("* Connected to central device!");
    colorWipe(strip.Color(0, 0, 255), 50);  // Blue
    Serial.print("* Device MAC address: ");
    Serial.println(central.address());
    Serial.println(" ");

    while (central.connected()) {
      int buttonState = digitalRead(buttonPin);
      if (buttonState == LOW) {
        startCounting = true;
        paidValue = -1;
      }

      if (firstCharacteristic.written() && startCounting) {
        int val = firstCharacteristic.value();
        if (paidValue == -1) {
          paidValue = val;
          Serial.print("start with val:");
        } else if (val - paidValue == payment - 1) {
          //  logic if result match  
          digitalWrite(speakerPin, HIGH);  // turn the speaker on
          delay(100);
          digitalWrite(speakerPin, LOW);
          startCounting = false;
          paidValue = -1;
          snprintf(buffer, sizeof(buffer), "Result: %s", result.c_str());
          u8g2.drawStr(0, 60, buffer);
          u8g2.sendBuffer();
          rainbow(10);
          Serial.println("eeeeeeeeeeend Payment Done!");
          delay(10000);
          u8g2.clearBuffer();
          u8g2.sendBuffer();
          setup();
        }
        Serial.println(val);
        Serial.print("cost again ");
        Serial.println(payment);
        Serial.print("result again ");
        Serial.println(result);
        digitalWrite(speakerPin, HIGH);  // turn the speaker on
        delay(100);
        digitalWrite(speakerPin, LOW);
      }
    }

    Serial.println("* Disconnected to central device!");
  }
}

void colorWipe(uint32_t c, uint8_t wait) {
  for (uint16_t i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(wait);
  }
}
void rainbow(uint8_t wait) {
  uint16_t i, j;

  for (j = 0; j < 256; j++) {
    for (i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel((i + j) & 255));
    }
    strip.show();
    delay(wait);
  }
}
uint32_t Wheel(byte WheelPos) {
  WheelPos = 255 - WheelPos;
  if (WheelPos < 85) {
    return strip.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  }
  if (WheelPos < 170) {
    WheelPos -= 85;
    return strip.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
  WheelPos -= 170;
  return strip.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
}