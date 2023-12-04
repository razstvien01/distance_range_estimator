#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Update these with your network credentials
const char* ssid = "HG8145V5_0484D";
const char* password = "PZz6VKmu";

// MQTT Broker
const char* mqtt_broker = "broker.hivemq.com";
const char* topic = "distance_range_estimator";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

// Declare the variables
unsigned long lastMsg = 0; // To store the time when the last message was sent
long temperature;          // To store the temperature value
char msg[50];              // To store the message to be sent

void setup_wifi() {
    delay(10);
    // Connect to Wi-Fi
    Serial.println("Connecting to WiFi...");
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }

    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
}

void setup() {
    Serial.begin(115200);
    setup_wifi();
    client.setServer(mqtt_broker, mqtt_port);
}

void loop() {
    if (!client.connected()) {
        // Reconnect if connection is lost
        while (!client.connected()) {
            Serial.print("Attempting MQTT connection...");
            // Attempt to connect
            if (client.connect("ESP8266Client")) {
                Serial.println("connected");
            } else {
                Serial.print("failed, rc=");
                Serial.print(client.state());
                Serial.println(" try again in 5 seconds");
                delay(5000);
            }
        }
    }
    client.loop();

    // Publish a message roughly every two seconds
    if (millis() - lastMsg > 2000) {
        lastMsg = millis();
        temperature = random(20, 30); // Generate a random temperature value
        snprintf(msg, 50, "Temperature: %ld", temperature);
        Serial.print("Publish message: ");
        Serial.println(msg);
        client.publish(topic, msg);
    }
}
