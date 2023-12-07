import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:distance_range_estimator/widgets/default_textfield.dart';
import 'package:distance_range_estimator/widgets/image_list.dart';
import 'package:flutter/material.dart';

class AddDistanceScreen extends StatefulWidget {
  const AddDistanceScreen({super.key});

  @override
  State<AddDistanceScreen> createState() => _AddDistanceScreenState();
}

class _AddDistanceScreenState extends State<AddDistanceScreen> {
  final _labelController = TextEditingController();

  final _saveToController = TextEditingController();

  final List<String> imageUrls = List.generate(
      10, (index) => 'https://picsum.photos/250?image=${index + 10}');

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
      // body: ImageListView(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                  child: Text(
                    "Captured Distance 10 cm",
                    style: kSubTextStyle,
                  ),
                ),
              ),
              const Flexible(
                flex: 1,
                child: Text(
                  "10 CM",
                  style: kHeadTextStyle,
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: kLessPadding),
                  child: DefaultTextField(
                    hintText: "Enter label",
                    icon: Icons.label,
                    controller: _labelController,
                    keyboardType: TextInputType.text,
                    validator: null,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: kLessPadding),
                  child: DefaultTextField(
                    hintText: "Save To",
                    icon: Icons.save,
                    controller: _saveToController,
                    keyboardType: TextInputType.text,
                    validator: null,
                  ),
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              Flexible(
                flex: 4,
                child: ImageListView(),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              DefaultButton(
                btnText: "Upload Picture",
                onPressed: () => {print("Pressed")},
              ),
              DefaultButton(
                btnText: "Save Distance",
                onPressed: () =>
                    {Navigator.of(context).popUntil((route) => route.isFirst)},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
