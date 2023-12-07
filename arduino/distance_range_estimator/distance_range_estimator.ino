#include <ESP8266WiFi.h>
#include <PubSubClient.h>

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
int ledSendPin = D1;
int ledConnectionPin = D5;
const int trigPin = D6;
const int echoPin = D7;

float distanceCm;
float distanceInch;

void setup_wifi() {
  // Connect to Wi-Fi
  // Serial.println("Connecting to WiFi...");
  // WiFi.begin(ssid, password);
  // while (WiFi.status() != WL_CONNECTED) {
  //   delay(500);
  //   Serial.print(".");
  // }
  pinMode(ledSendPin, OUTPUT);
  pinMode(ledConnectionPin, OUTPUT);


  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // Serial.println("WiFi connected");
  // Serial.println("IP address: ");
  // Serial.println(WiFi.localIP());
}

void setup() {
  Serial.begin(115200);
  setup_wifi();
  // client.setServer(mqtt_broker, mqtt_port);
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
  Serial.print("Distance (inch): ");
  Serial.println(distanceInch);

  delay(1000);

  digitalWrite(ledSendPin, HIGH);
  // if (!client.connected()) {
  //   while (!client.connected()) {
  //     digitalWrite(ledConnectionPin, LOW);
  //     Serial.print("Attempting MQTT connection...");
  //     if (client.connect("ESP8266Client")) {
  //       digitalWrite(ledConnectionPin, HIGH);
  //       Serial.println("connected");

  //       // distance = random(1, 400);
  //       snprintf(msg, 50, "%ld", distance);
  //       Serial.print("Publish message: ");
  //       Serial.println(msg);
  //       client.publish(topic, msg);
  //       lastMsg = millis();

  //     } else {
  //       Serial.print("failed, rc=");
  //       Serial.print(client.state());
  //       Serial.println(" try again in 5 seconds");
  //       delay(5000);
  //     }
  //   }
  // }

  // client.loop();

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
