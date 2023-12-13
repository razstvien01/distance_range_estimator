import 'package:distance_range_estimator/types/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatelessWidget {
  final CollectionReference distanceCollection =
      FirebaseFirestore.instance.collection('distances');

  final String areaName;
  final String saveToId;

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
                return Stack(
                  children: [
                    Card(
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
                              top: Radius.circular(kBigPadding),
                            ),
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
                              bottom: Radius.circular(kDefaultPadding),
                            ),
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
                    ),
                    Positioned(
                      top: 10, // Adjust the top position as needed
                      right: 10, // Adjust the right position as needed
                      child: IconButton(
                        color: Colors.redAccent,
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: kBGColor,
                                title: const Text('Confirm Deletion', style: kHeadTextStyle,),
                                content: const Text(
                                    'Are you sure you want to delete this distance?', style: kSubTextStyle,),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      final CollectionReference distances =
                                          FirebaseFirestore.instance
                                              .collection('distances');

                                      // Use the documentId variable to get the document reference
                                      DocumentReference docRef =
                                          distances.doc(documentId);

                                      // Delete the document
                                      docRef.delete().then((_) {
                                        // Document deleted successfully
                                        print('Document deleted');
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      }).catchError((error) {
                                        // Handle errors, if any
                                        print(
                                            'Error deleting document: $error');
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            );

            // return Text('Hello wlrld', style: kSubTextStyle,);
          },
        ));
  }
}
