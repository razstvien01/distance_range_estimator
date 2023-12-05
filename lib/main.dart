import 'package:distance_range_estimator/widgets/default-button.dart';
import 'package:flutter/material.dart';

//* MQTT Libraries
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;

//* Firebase core libraries
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //* Setting statusbarcolor to kTransparent
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: kTransparent,
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MQTT Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final mqtt.MqttServerClient client =
      mqtt.MqttServerClient('broker.hivemq.com', '');
  String receivedMessage = 'Waiting for messages...';

  @override
  void initState() {
    super.initState();
    // connect();
  }

  void connect() async {
    client.setProtocolV311();
    client.logging(on: true);
    client.keepAlivePeriod = 5;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == mqtt.MqttConnectionState.connected) {
      print('MQTT client connected');
    } else {
      print(
          'ERROR MQTT client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
  }

  void onConnected() {
    print('Connected');
    client.subscribe("distance_range_estimator", mqtt.MqttQos.atMostOnce);
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
    client.updates
        ?.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> c) {
      final mqtt.MqttPublishMessage message =
          c[0].payload as mqtt.MqttPublishMessage;
      final payload = mqtt.MqttPublishPayload.bytesToStringAsString(
          message.payload.message);

      print('Received message: $payload from topic: ${c[0].topic}>');
      setState(() {
        receivedMessage = payload;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Distance Range Estimator"),
      ),
      // body: Text("Current Distance: 20 cm"),
      body: Column(
        children: [
          Text("Current Distance: 20 cm"),
          DefaultButton(btnText: "Save", onPressed: () => {
            print("Button clicked")
          }),
          
          DefaultButton(btnText: "Create Area", onPressed: () => {
            print("Button clicked")
          })
        ],
      )
      // body: Center(
      //   child: Text(receivedMessage),
      // ),
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
