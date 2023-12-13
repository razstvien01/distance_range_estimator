// #include <ESP8266WiFi.h>
// #include <PubSubClient.h>

// // Network credentials
// const char* ssid = "HG8145V5_0484D";
// const char* password = "PZz6VKmu";
// // const char* ssid = "Nico";
// // const char* password = "00000000";

// // const char* ssid = "Narzo50";
// // const char* password = "123456789";

// // MQTT Broker
// const char* mqtt_broker = "broker.hivemq.com";
// const char* topic = "distance_range_estimator";
// const int mqtt_port = 1883;

// WiFiClient espClient;
// PubSubClient client(espClient);

// #define SOUND_VELOCITY 0.034
// #define CM_TO_INCH 0.393701

// // Declare the variables
// unsigned long lastMsg = 0;
// long distance;
// int duration;
// char msg[50];

// // Pins
// // const int buttonPin = D2;  // Change D3 to your ESP8266 GPIO pin connected to the button
// bool lastButtonState = LOW;
// int ledConnectionPin = D0;
// const int trigPin = D1;
// const int echoPin = D2;

// float distanceCm;
// float distanceInch;

// void setup_wifi() {
//   // Connect to Wi-Fi
//   Serial.println("Connecting to WiFi...");
//   WiFi.begin(ssid, password);
//   while (WiFi.status() != WL_CONNECTED) {
//     delay(200);
//     Serial.print(".");
//   }

//   Serial.println("WiFi connected");
//   Serial.println("IP address: ");
//   Serial.println(WiFi.localIP());
// }

// void setup() {
//   Serial.begin(115200);
//   setup_wifi();

//   client.setServer(mqtt_broker, mqtt_port);

//   pinMode(trigPin, OUTPUT);
//   pinMode(echoPin, INPUT);

//   pinMode(ledConnectionPin, OUTPUT);
// }

// void loop() {
//   // // Clears the trigPin
//   digitalWrite(trigPin, LOW);
//   delayMicroseconds(2);
//   // Sets the trigPin on HIGH state for 10 micro seconds
//   digitalWrite(trigPin, HIGH);
//   delayMicroseconds(10);
//   digitalWrite(trigPin, LOW);

//   // Reads the echoPin, returns the sound wave travel time in microseconds
//   duration = pulseIn(echoPin, HIGH);

//   // Calculate the distance
//   distanceCm = duration / 29 / 2;

//   if (!client.connected()) {
//     while (!client.connected()) {
//       // digitalWrite(ledConnectionPin, LOW);
//       Serial.print("Attempting MQTT connection...");
//       if (client.connect("ESP8266Client")) {
//         digitalWrite(ledConnectionPin, HIGH);
//         Serial.println("connected");

//         // distance = random(1, 400);
//         dtostrf(distanceCm, 1, 2, msg);
//         Serial.print("Publish message: ");
//         Serial.println(msg);
//         client.publish(topic, msg);
//         lastMsg = millis();

//       } else {
//         Serial.print("failed, rc=");
//         Serial.print(client.state());
//         Serial.println(" try again in 2 seconds");
//         delay(2000);
//       }
//     }
//   }

//   client.loop();
// }

// #include <Wire.h>  // Include the Wire library for I2C communication
// #include <LiquidCrystal_I2C.h>  // Include the LiquidCrystal_I2C library

// // Initialize the LCD with its I2C address
// LiquidCrystal_I2C lcd(0x27, 16, 2);  // Set the I2C address for your LCD

// void setup() {
//   // Initialize the LCD
//   lcd.init();

//   // Turn on the backlight (if available)
//   lcd.backlight();

//   // Print a message on the LCD
//   lcd.setCursor(0, 0);  // Set the cursor to the first row, first column
//   lcd.print("Hello, World!");  // Print the message on the LCD
// }

// void loop() {
//   // Your main code can go here
// }
#include <Wire.h>
void setup() {
  Serial.begin (9600);
  Serial.println ("I2C scanner. Scanning ...");
  byte count = 0;
  // 0x27 0x3F
  Wire.begin();
  for (byte i = 8; i < 120; i++)
  {
    Wire.beginTransmission (i);
    if (Wire.endTransmission () == 0)
      {
      Serial.print ("Found address: ");
      Serial.print (i, DEC);
      Serial.print (" (0x");
      Serial.print (i, HEX);
      Serial.println (")");
      count++;
      delay (1);
      }
  }
  Serial.println ("Done.");
  Serial.print ("Found ");
  Serial.print (count, DEC);
  Serial.println (" device(s).");
}  // end of setup

void loop() {}