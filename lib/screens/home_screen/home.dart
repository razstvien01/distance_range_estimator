import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/area_list.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text("Current Distance: 20 cm", style: kSubTextStyle),
          ),
        ),
        Flexible(
          flex: 1,
          child: DefaultButton(
              btnText: "Save", onPressed: () => {print("Button clicked")}),
        ),
        const Flexible(flex: 5, child: AreaList()),
        Flexible(
          flex: 1,
          child: DefaultButton(
              btnText: "Create Area",
              onPressed: () => {Navigator.of(context).pushNamed('/add_area')}),
        )
      ],
    );
  }
}
