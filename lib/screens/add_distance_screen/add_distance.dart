import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:flutter/material.dart';

class AddDistanceScreen extends StatelessWidget {
  const AddDistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kBGColor,
        centerTitle: true,
        title: const Text("Add Distance", style: kHeadTextStyle),
        foregroundColor: kRevColor,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "Captured Distance 10 cm",
              style: kSubTextStyle,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "10 CM",
              style: kHeadTextStyle,
            ),
          ),
          
          DefaultButton(btnText: "Add Picture", onPressed: () => {
            print("Pressed")
          },),
        ],
      ),
    );
  }
}
