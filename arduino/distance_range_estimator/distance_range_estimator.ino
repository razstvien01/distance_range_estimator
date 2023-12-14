#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <LiquidCrystal.h>

// Network credentials
// const char* ssid = "HG8145V5_0484D";
// const char* password = "PZz6VKmu";

// const char* ssid = "Nico";
// const char* password = "00000000";

const char* ssid = "Narzo50";
const char* password = "123456789";

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
// int ledConnectionPin = D0;

float distanceCm;
float distanceInch;
float distanceFt;

// Pin mapping to the LCD
const int rs = D1;
const int en = D0;
const int d4 = D8;
const int d5 = D7;
const int d6 = D6;
const int d7 = D5;
const int trigPin = D4;  //left, orange
const int echoPin = D2;  //right

const int buttonPin = D3;

int ctr = 0;

// Variables to hold button state
int buttonState = 0;
int lastButtonState = 0;
int currentState = 0;
const int numberOfStates = 3;

LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

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
  Serial.begin(115200);
  lcd.begin(16, 2);  // Set the dimensions of the LCD (16x2)
  lcd.println("CONNECTING...");
  setup_wifi();

  client.setServer(mqtt_broker, mqtt_port);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  pinMode(buttonPin, INPUT);

  lcd.clear();
}

void loop() {
  String result = "";
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

  // Calculate the distance in feet
  distanceFt = distanceCm / 30.48;  // 1 foot = 30.48 cm

  // Calculate the distance in inches
  distanceInch = distanceCm / 2.54;  // 1 inch = 2.54 cm

  buttonState = digitalRead(buttonPin);

  Serial.println("HELLO");
  // If the button is pressed and the previous state was not pressed
  if (buttonState == HIGH && lastButtonState == LOW) {
    // Toggle the LED state
    Serial.println("PRESSED");

    currentState = (currentState + 1) % numberOfStates;
  }

  // Save the current button state for the next loop iteration
  lastButtonState = buttonState;


  switch (currentState) {

    case 0:
      result = String(distanceCm) + " cm";
      lcd.println(result);
      break;
    case 1:
      result = String(distanceInch) + " inches";
      lcd.println(result);
      break;
    case 2:
      result = String(distanceFt) + " ft";
      lcd.println(result);
      break;
  }

  // delay(1000);

  if (!client.connected()) {
    while (!client.connected()) {
      // digitalWrite(ledConnectionPin, LOW);
      Serial.print("Attempting MQTT connection...");

      if (client.connect("ESP8266Client")) {
        // digitalWrite(ledConnectionPin, HIGH);
        Serial.println("connected");

        float dVal = 0;

        switch (currentState) {

          case 0:
            dVal = distanceCm;
            break;
          case 1:
            dVal = distanceInch;
            break;
          case 2:
            dVal = distanceFt;
            break;
        }


        dtostrf(dVal, 1, 2, msg);
        Serial.print("Publish message: ");
        Serial.println(msg);
        client.publish(topic, msg);
        lastMsg = millis();

      } else {
        Serial.print("failed, rc=");
        Serial.print(client.state());
        Serial.println(" try again in 2 seconds");
        delay(2000);
      }
    }
  }

  client.loop();

  delay(200);
  lcd.clear();
}

// const int buttonPin = D3;  // Change this if your button is connected to a different pin

// // Variables to hold button state
// int buttonState = 0;
// int lastButtonState = 0;

// void setup() {
//   // Initialize button pin as an input
//   pinMode(buttonPin, INPUT);
//   Serial.begin(9600);
// }

// void loop() {
//   // Read the state of the button
//   buttonState = digitalRead(buttonPin);

//   // If the button is pressed and the previous state was not pressed
//   if (buttonState == HIGH && lastButtonState == LOW) {
//     // Toggle the LED state
//       Serial.println("PRESSEDD");
//   }

//   // Save the current button state for the next loop iteration
//   lastButtonState = buttonState;
// }



// #include <LiquidCrystal.h>

// Pin mapping to the LCD
// const int rs = D1;
// const int en = D0;
// const int d4 = D8;
// const int d5 = D7;
// const int d6 = D6;
// const int d7 = D5;
// const int trigPin=D4; //left
// const int echoPin=D2; //right

// int duration;
// int distance;

// LiquidCrystal lcd(rs, en, d4, d5, d6, d7); // Initialize the LCD

// void setup() {

//   pinMode(trigPin, OUTPUT);
//   pinMode(echoPin, INPUT);

//   lcd.begin(16, 2); // Set the dimensions of the LCD (16x2)
//   lcd.print(distance);
//   delay(1000);
//   Serial.begin(9600);

// }

// void loop() {
//   // You can add your main code logic here if needed
//   digitalWrite(trigPin, LOW);
//   delayMicroseconds(2);

//   digitalWrite(trigPin, HIGH);
//   delayMicroseconds(10);
//   digitalWrite(trigPin, LOW);

//   duration = pulseIn(echoPin, HIGH);
//   distance = duration/29/2;

//   Serial.print("Distance: ");
//   Serial.println(distance);

//   lcd.clear();
//   lcd.print(distance);
//   lcd.print(" CM");

//   delay(2000);



// }

// void setup() {
//   delay(10000);
//   Serial.begin(115200);
//   Serial.println("Start");
//   Serial.println("---------------");
//   delay(1000);
//   Serial.println("Blink Example");
//   delay(1000);
//   pinMode(LED_BUILTIN, OUTPUT);

// }


// void loop() {
// Serial.println("========================");
// Serial.println("Loop");
//   // put your main code here, to run repeatedly:
//   digitalWrite(LED_BUILTIN, LOW);
//   delay(2000);
//   digitalWrite(LED_BUILTIN, HIGH);
//   delay(2000);
// }