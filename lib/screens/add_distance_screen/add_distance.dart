import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:distance_range_estimator/widgets/default_textfield.dart';
import 'package:flutter/material.dart';

class AddDistanceScreen extends StatefulWidget {
  AddDistanceScreen({super.key});

  @override
  State<AddDistanceScreen> createState() => _AddDistanceScreenState();
}

class _AddDistanceScreenState extends State<AddDistanceScreen> {
  final _labelController = TextEditingController();

  final _saveToController = TextEditingController();

  final List<String> imageUrls = List.generate(10, (index) => 'https://picsum.photos/250?image=${index + 10}');

  @override
  void dispose() {
    _labelController.dispose();
    _saveToController.dispose();
  }

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
      body: SingleChildScrollView(
        child: Column(
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
            DefaultTextField(
              hintText: "Enter label",
              icon: Icons.label,
              controller: _labelController,
              keyboardType: TextInputType.text,
              validator: null,
            ),
            DefaultTextField(
              hintText: "Save To",
              icon: Icons.save,
              controller: _saveToController,
              keyboardType: TextInputType.text,
              validator: null,
            ),
            ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Image.network(imageUrls[index]),
                      Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Text('Image ${index + 1}', style: kSmallTextStyle),
                      )
                    ],
                  ),
                );
              },
            ),
            DefaultButton(
              btnText: "Upload Picture",
              onPressed: () => {print("Pressed")},
            ),
            DefaultButton(
              btnText: "Save Distance",
              onPressed: () => {print("Pressed")},
            ),
          ],
        ),
      ),
    );
  }
}
