import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';

import '../screens/detail_area_screen/detail_area.dart';

class AreaList extends StatelessWidget {
  final List<String> areas = const [
    'Area 1',
    'Area 2',
    'Area 3',
    'Area 4',
    'Area 5',
    'Area 6',
    'Area 7',
    'Area 8',
    'Area 9',
    'Area 9',
    'Area 7',
    'Area 8',
    'Area 9',
    'Area 9',
    'Area 7',
    'Area 8',
    'Area 9',
    'Area 9',
    // ... other areas
  ];

  const AreaList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: areas.length,
      itemBuilder: (context, index) {
        return Card(
          color: kBGColor,
          child: ListTile(
            title: Text(areas[index], style: kSubTextStyle),
            onTap: () {
              // Action to take when card is tapped
              // For example, navigate to a new screen:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(areaName: areas[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
