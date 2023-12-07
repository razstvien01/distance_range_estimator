import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String areaName;

  // Sample data: List of measurements with labels.
  final List<Map<String, dynamic>> measurements = List.generate(
    10,
    (index) => {
      'label': 'Measurement ${index + 1}',
      'distance': '${10 + index * 5} cm',
      'imageUrl': 'https://picsum.photos/200/300?random=$index',
    },
  );

  DetailScreen({super.key, required this.areaName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(areaName, style: kHeadTextStyle),
        centerTitle: true,
        foregroundColor: kRevColor,
      ),
      body: ListView.builder(
        itemCount: measurements.length,
        itemBuilder: (context, index) {
          return Card(
            color: kBGColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5, // Adjust the elevation for shadow intensity
            child: Column(
              children: [
                ClipRRect(
                  // Clip the image with rounded corners
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(kBigPadding)),
                  child: Image.network(measurements[index]['imageUrl'],
                      height: 200, fit: BoxFit.fill),
                ),
                InkWell(
                  // InkWell for ListTile with rounded corners
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(kDefaultPadding)),
                  child: ListTile(
                    tileColor: kPrimaryColor,
                    title: Text(
                      measurements[index]['label'],
                      style: kSubTextStyle,
                    ),
                    subtitle: Text(
                        'Distance: ${measurements[index]['distance']}',
                        style: kSmallTextStyle),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
