import 'package:flutter/material.dart';

class ImageListView extends StatelessWidget {
  final List<String> imageUrls = List.generate(
      10,
      (index) =>
          'https://picsum.photos/250?image=${index + 10}'); // Generates 10 random image URLs for demonstration

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: <Widget>[
                Image.network(imageUrls[index]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Image ${index + 1}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
