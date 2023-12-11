#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <LiquidCrystal.h>

// Network credentials
const char* ssid = "HG8145V5_0484D";
const char* password = "PZz6VKmu";
// const char* ssid = "Nicolen";
// const char* password = "00000000";

// const char* ssid = "Narzo50";
// const char* password = "123456789";

// MQTT Broker
const char* mqtt_broker = "broker.hivemq.com";
const char* topic = "distance_range_estimator";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

#define SOUND_VELOCITY 0.034
#define CM_TO_INCH 0.393701

// Declare the variables
unsigned long lastMsg = 0;
long distance;
int duration;
char msg[50];

// Pins
// const int buttonPin = D2;  // Change D3 to your ESP8266 GPIO pin connected to the button
bool lastButtonState = LOW;
int ledConnectionPin = D0;
const int trigPin = D1;
const int echoPin = D2;

float distanceCm;
float distanceInch;

// LiquidCrystal lcd(rs, en, d4, d5, d6, d7);
LiquidCrystal lcd(D3, D4, D5, D6, D7, D8);
const char* textToScroll = "Manifesting makapasar! HELP USS!!!!";

void setup_wifi() {
  // Connect to Wi-Fi
  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(200);
    Serial.print(".");
  }

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  
  // lcd.begin(16, 2);
  // lcd.clear();
  // lcd.print(textToScroll);
  
  pinMode(ledConnectionPin, OUTPUT);

  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_broker, mqtt_port);
}

void loop() {

  // Clears the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);

  // Calculate the distance
  distanceCm = duration / 29 / 2;

  // Convert to inches
  distanceInch = distanceCm * CM_TO_INCH;

  // Prints the distance on the Serial Monitor
  Serial.print("Distance (cm): ");
  Serial.println(distanceCm);

  delay(1000);

  if (!client.connected()) {
    while (!client.connected()) {
      digitalWrite(ledConnectionPin, LOW);
      Serial.print("Attempting MQTT connection...");
      if (client.connect("ESP8266Client")) {
        digitalWrite(ledConnectionPin, HIGH);
        Serial.println("connected");

        // distance = random(1, 400);
        dtostrf(distanceCm, 1, 2, msg);
        Serial.print("Publish message: ");
        Serial.println(msg);
        client.publish(topic, msg);
        lastMsg = millis();

      } else {
        Serial.print("failed, rc=");
        Serial.print(client.state());
        Serial.println(" try again in 3 seconds");
        delay(3000);
      }
    }
  }

  client.loop();

  // int textLength = strlen(textToScroll);

  // for (int i = 0; i < textLength + 16; ++i) {
  //   lcd.scrollDisplayLeft();
  //   delay(300);
  // }

  // lcd.setCursor(textLength > 16 ? 16 : textLength, 1);
  // delay(1000);
  // lcd.clear();
  // lcd.setCursor(0, 0);
  // lcd.print(textToScroll);

  // bool buttonState = digitalRead(buttonPin);
  // if (buttonState == HIGH && lastButtonState == LOW && client.connected()) {

  //   // Button is pressed
  //   distance = random(1, 400);  // Generate a random distance value
  //   snprintf(msg, 50, "Current Distance: %ld cm", distance);
  //   Serial.print("Publish message: ");
  //   Serial.println(msg);
  //   client.publish(topic, msg);
  //   lastMsg = millis();
  //   digitalWrite(ledSendPin, HIGH);  // Turn the LED on
  //   delay(50);                      // Wait for a second
  //   digitalWrite(ledSendPin, LOW);   // Turn the LED off
  //   delay(50);
  // }
  // lastButtonState = buttonState;  // Update the last button state
}

// #include <LiquidCrystal.h>

// // Define the LCD control pins
// const int rs = D3;  // RS pin
// const int en = D4;  // Enable pin
// const int d4 = D5;
// const int d5 = D6;
// const int d6 = D7;
// const int d7 = D8;

// // Create an instance of the LiquidCrystal library
// LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

// void setup() {
//   // Initialize the LCD
//   lcd.begin(16, 2); // Change the numbers to match your LCD's dimensions (columns x rows)

//   // Print a message to the LCD
//   lcd.print("Hello, ESP8266!");
// }

// void loop() {
//   // Your main code here
// }

