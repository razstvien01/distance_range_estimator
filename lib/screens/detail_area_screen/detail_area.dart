import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatelessWidget {
  final CollectionReference distanceCollection =
      FirebaseFirestore.instance.collection('distances');

  final String areaName;
  final String saveToId;

  // Sample data: List of measurements with labels.
  final List<Map<String, dynamic>> measurements = List.generate(
    10,
    (index) => {
      'label': 'Measurement ${index + 1}',
      'distance': '${10 + index * 5} cm',
      'imageUrl': 'https://picsum.photos/200/300?random=$index',
    },
  );

  DetailScreen({super.key, required this.areaName, required this.saveToId});

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
        body: StreamBuilder<QuerySnapshot>(
          //  stream: distanceCollection.orderBy('created_at', descending: true).snapshots(),
          stream: distanceCollection
              .where('saveToId', isEqualTo: saveToId) // Add this line
              .orderBy('created_at', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // print(saveToId);
            final distances = snapshot.data?.docs;

            if (distances == null || distances.isEmpty) {
              // Show a message when the list is empty
              return const Center(
                child: Text(
                  'No distances available',
                  style: kSubTextStyle,
                ),
              );
            }

            return ListView.builder(
              itemCount: distances.length,
              itemBuilder: (context, index) {
                final documentSnapshot = distances[index];
                final documentId = documentSnapshot.id;

                final distanceData =
                    distances[index].data() as Map<String, dynamic>;
                final label = distanceData['label'] ??
                    ''; // Replace 'title' with the field name in your Firestore document
                final distance = distanceData['distance'] ?? '';
                final thumbUrl = distanceData['imageUrls'][0] ?? '';

                // print(distances);
                // return Text('HGELLO WORL.D', style: kSubTextStyle,);
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
                        child: Image.network(
                          thumbUrl,
                          height: 350,
                          width: 350,
                          fit: BoxFit.fill,
                        ),
                      ),
                      InkWell(
                        // InkWell for ListTile with rounded corners
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(kDefaultPadding)),
                        child: ListTile(
                          tileColor: Colors.transparent,
                          title: Text(
                            distance + " cm",
                            style: kSubTextStyle,
                          ),
                          subtitle: Text(
                            label,
                            style: kSmallTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );

            // return Text('Hello wlrld', style: kSubTextStyle,);
          },
        )

        // body: ListView.builder(
        //   itemCount: measurements.length,
        //   itemBuilder: (context, index) {
        //     return Card(
        //       color: kBGColor,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(15.0),
        //       ),
        //       elevation: 5, // Adjust the elevation for shadow intensity
        //       child: Column(
        //         children: [
        //           ClipRRect(
        //             // Clip the image with rounded corners
        //             borderRadius: const BorderRadius.vertical(
        //                 top: Radius.circular(kBigPadding)),
        //             child: Image.network(measurements[index]['imageUrl'],
        //                 height: 200, fit: BoxFit.fill),
        //           ),
        //           InkWell(
        //             // InkWell for ListTile with rounded corners
        //             borderRadius: const BorderRadius.vertical(
        //                 bottom: Radius.circular(kDefaultPadding)),
        //             child: ListTile(
        //               tileColor: Colors.transparent,
        //               title: Text(
        //                 measurements[index]['label'],
        //                 style: kSubTextStyle,
        //               ),
        //               subtitle: Text(
        //                   'Distance: ${measurements[index]['distance']}',
        //                   style: kSmallTextStyle),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );

        //   },
        // ),

        );
  }
}
