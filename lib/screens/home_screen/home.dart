import 'package:distance_range_estimator/screens/add_distance_screen/add_distance.dart';
import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/area_list.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String message; // Remove the const keyword
  final String selectedMeasurement;
  final String status;
  HomeScreen({super.key, required this.message, required this.selectedMeasurement, required this.status});

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
                const Text("Status:", style: kSubTextStyle),
                Text(widget.status, style: kHeadTextStyle),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                const Text("Current Distance:", style: kSubTextStyle),
                Text("${widget.message} ${widget.selectedMeasurement}", style: kHeadTextStyle),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: DefaultButton(
              btnText: "Save Distance",
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddDistanceScreen(
                            distance: widget.message,
                          );
                        },
                      ),
                    )
                  }),
        ),
        Flexible(flex: 4, child: AreaList()),
        Flexible(
          flex: 1,
          child: DefaultButton(
              btnText: "Create Measurements",
              onPressed: () => {Navigator.of(context).pushNamed('/add_area')}),
        )
      ],
    );
  }
}
