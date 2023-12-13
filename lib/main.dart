import 'dart:typed_data';
import 'dart:convert';
import 'package:distance_range_estimator/widgets/measurement_dialog.dart';
import 'package:typed_data/typed_buffers.dart';

import 'package:distance_range_estimator/screens/add_area_screen/add_area.dart';
import 'package:distance_range_estimator/screens/add_distance_screen/add_distance.dart';
import 'package:distance_range_estimator/screens/home_screen/home.dart';
import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:distance_range_estimator/widgets/default_textfield.dart';
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
      routes: {
        '/add_area': (context) => CreateAreaScreen(refresh: () => {}),
      },
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
  String selectedMeasurement = "cm";
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    client.disconnect();
    super.dispose();
  }

  final mqtt.MqttServerClient client =
      mqtt.MqttServerClient('broker.hivemq.com', '');
  String receivedMessage = '0.00';

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() async {
    const Duration retryDelay =
        Duration(seconds: 5); // Delay between reconnection attempts

    client.setProtocolV311();
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    while (true) {
      // Infinite loop for reconnection attempts
      try {
        await client.connect();
        if (client.connectionStatus?.state ==
            mqtt.MqttConnectionState.connected) {
          print('MQTT client connected');
          return; // Exit the loop on successful connection
        } else {
          print(
              'Connection attempt failed, status is ${client.connectionStatus}');
        }
      } catch (e) {
        print(
            'Connection attempt failed - trying again in ${retryDelay.inSeconds} seconds');
      }

      await Future.delayed(retryDelay); // Wait before retrying
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

  void updateMeasurementUnit(String unit) {
    setState(() {
      selectedMeasurement = unit;
    });
  }

  void _showMeasurementDialog() async {
    selectedMeasurement = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return MeasurementDialog(updateMeasurementUnit, selectedMeasurement);
      },
    ) as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBGColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: const Text("Distance Range Estimator", style: kHeadTextStyle),
          actions: [
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const NotificationUI()),
                // );
                // openDialog();

                _showMeasurementDialog();
                _ssidController.text = "";
                _passwordController.text = "";
              },
              icon: const Icon(
                Icons.settings,
                color: kRevColor,
              ),
            )
          ],
        ),
        body: HomeScreen(
            message: receivedMessage,
            selectedMeasurement: selectedMeasurement));
  }
}
