import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/detail_area_screen/detail_area.dart';

class AreaList extends StatelessWidget {
  final CollectionReference areaCollection =
      FirebaseFirestore.instance.collection('measurements');

  AreaList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: areaCollection.orderBy('created_at', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        }

        final areas = snapshot.data?.docs;

        if (areas == null || areas.isEmpty) {
          // Show a message when the list is empty
          return const Center(
            child: Text('No measurements available', style: kSubTextStyle,),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: areas.length,
          itemBuilder: (context, index) {
            final documentSnapshot = areas[index];
            final documentId = documentSnapshot.id;
            final areaData = areas[index].data() as Map<String, dynamic>;
            final areaName = areaData['title'] ??
                ''; // Replace 'title' with the field name in your Firestore document
            final thumbnailUrl = areaData['thumbnail'] ??
                ''; // Replace 'thumbnail' with the field name for the thumbnail URL

            return GestureDetector(
              onTap: () {
                // Action to take when the list item is tapped
                // For example, navigate to a new screen:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(areaName: areaName, saveToId: documentId),
                  ),
                );
              },
              child: Card(
                color: kBGColor,
                child: ListTile(
                  leading: thumbnailUrl.isNotEmpty
                      ? Image.network(thumbnailUrl,
                          width: 100, height: 100) // Display thumbnail image
                      : SizedBox(
                          width: 100,
                          height: 100), // Placeholder if thumbnail URL is empty
                  title: Text(areaName, style: kSubTextStyle),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
