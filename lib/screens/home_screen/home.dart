import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/area_list.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String message; // Remove the const keyword
  HomeScreen({super.key, required this.message});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Text("Current Distance:", style: kSubTextStyle),
                Text("${widget.message} cm", style: kHeadTextStyle),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: DefaultButton(
              btnText: "Save",
              onPressed: () =>
                  {Navigator.of(context).pushNamed('/add_distance')}),
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
