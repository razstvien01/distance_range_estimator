import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/detail_area_screen/detail_area.dart';

class AreaList extends StatelessWidget {
  final CollectionReference areaCollection =
      FirebaseFirestore.instance.collection('area');

  AreaList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: areaCollection.orderBy('created_at', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Loading indicator
        }

        final areas = snapshot.data?.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: areas?.length,
          itemBuilder: (context, index) {
            final areaData = areas?[index].data() as Map<String, dynamic>;
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
                    builder: (context) => DetailScreen(areaName: areaName),
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
