#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Network credentials
const char* ssid = "HG8145V5_0484D";
const char* password = "PZz6VKmu";

// MQTT Broker
const char* mqtt_broker = "broker.hivemq.com";
const char* topic = "distance_range_estimator";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

// Declare the variables
unsigned long lastMsg = 0;
long distance;
char msg[50];

// Button setup
const int buttonPin = D2;  // Change D3 to your ESP8266 GPIO pin connected to the button
bool lastButtonState = LOW;
int ledSendPin = D1;
int ledConnectionPin = D5;

void setup_wifi() {
  // Connect to Wi-Fi
  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  pinMode(ledSendPin, OUTPUT);
  pinMode(ledConnectionPin, OUTPUT);
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void setup() {
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_broker, mqtt_port);

  pinMode(buttonPin, INPUT);  // Initialize the button pin as an input
}

void loop() {

  if (!client.connected()) {
    while (!client.connected()) {
      digitalWrite(ledConnectionPin, LOW);
      Serial.print("Attempting MQTT connection...");
      if (client.connect("ESP8266Client")) {
        digitalWrite(ledConnectionPin, HIGH);
        Serial.println("connected");
      } else {
        Serial.print("failed, rc=");
        Serial.print(client.state());
        Serial.println(" try again in 5 seconds");
        delay(5000);
      }
    }
  }

  // client.loop();

  bool buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH && lastButtonState == LOW && client.connected()) {

    // Button is pressed
    distance = random(1, 400);  // Generate a random distance value
    snprintf(msg, 50, "Current Distance: %ld cm", distance);
    Serial.print("Publish message: ");
    Serial.println(msg);
    client.publish(topic, msg);
    lastMsg = millis();
    digitalWrite(ledSendPin, HIGH);  // Turn the LED on
    delay(50);                      // Wait for a second
    digitalWrite(ledSendPin, LOW);   // Turn the LED off
    delay(50);
  }
  lastButtonState = buttonState;  // Update the last button state

  
}
