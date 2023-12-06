import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';

class AreaList extends StatelessWidget {
  final List<String> areas = const [
    'Area 1',
    'Area 2',
    'Area 3',
    'Area 3',
    'Area 3',
    'Area 3',
    'Area 3',
    'Area 3',
    'Area 3',
  ];

  const AreaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: areas.length,
        itemBuilder: (context, index) {
          
          return Card(
            color: kBGColor,
            child: ListTile(
              title: Text(areas[index], style: kSubTextStyle,)
            ),
          );
        }),
    );
  }
}
