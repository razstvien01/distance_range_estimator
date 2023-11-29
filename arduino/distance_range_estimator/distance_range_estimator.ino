#include <ESP8266WiFi.h>
#include <PubSubClient.h>

const char* ssid = "HG8145V5_0484D";
const char* password = "PZz6VKmu";
const char* mqttServer = "test.mosquitto.org";
const int mqttPort = 1883;
const char* mqttTopic = "distance_range_estimator";

WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  client.setServer(mqttServer, mqttPort);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  // Send data to Flutter app
  client.publish(mqttTopic, "Hello from ESP8266");
  delay(5000);
}

void reconnect() {
  while (!client.connected()) {
    Serial.println("Connecting to MQTT...");
    if (client.connect("ESP8266Client")) {
      Serial.println("Connected to MQTT");
    } else {
      Serial.println("Failed, rc=");
      Serial.println(client.state());
      Serial.println(" Retrying in 5 seconds...");
      delay(5000);
    }
  }
}
