import 'dart:io';

import 'package:distance_range_estimator/widgets/default_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';

import 'package:path/path.dart' as p;

class CreateAreaScreen extends StatefulWidget {
  final VoidCallback refresh;

  const CreateAreaScreen({super.key, required this.refresh});

  @override
  State<CreateAreaScreen> createState() => _CreateAreaScreenState();
}

class _CreateAreaScreenState extends State<CreateAreaScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  void dispose(){
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // final currUser = FirebaseAuth.instance.currentUser;
  
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageList = [];

  String? imageUrl;
  List<String?> imageUrls = [];
  late File imageFile = File('');

  Future _uploadFile(String path, bool isThumbnail) async {
    // final ref = FirebaseStorage.instance
    //     .ref()
    //     .child('properties')
    //     .child(DateTime.now().toIso8601String() + p.basename(path));

    // final result = await ref.putFile(File(path));
    // final fileUrl = await result.ref.getDownloadURL();

    print("HELLOOOO WORLDDDDDDD");

    setState(() {
      imageUrl = path;
    });
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
        path, newPath,
        quality: quality);

    if (result == null) {
      throw Exception('Image compression failed');
    }

    return File(result.path);
  }

  Future _pickImage(ImageSource source, double x, double y) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    final file = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: x, ratioY: y),
    );

    if (file == null) {
      return;
    }

    // setState(() {
    imageFile = File(file.path);
    // });

    imageFile = await compressImage(file.path, 35);

    setState(() {});

    //await _uploadFile(imageFile.path);
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        backgroundColor: kPrimaryColor,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera, color: kRevColor),
                title: const Text(
                  'Camera',
                  style: kSmallTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera, 16, 9);
                },
              ),
              ListTile(
                  leading: const Icon(Icons.filter, color: kRevColor),
                  title: const Text(
                    'Pick a file',
                    style: kSmallTextStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery, 16, 9);
                  }),
            ],
          );
        });
  }
  
  @override
  Widget build(BuildContext context) {
    double availableHeight = MediaQuery.of(context).size.height -
        (AppBar().preferredSize.height + MediaQuery.of(context).padding.top);
    double componentHeight = availableHeight / 3;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Text(
          'Create Area',
          style: kSubTextStyle,
        ),
        foregroundColor: kRevColor,
      ),
      backgroundColor: kBGColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: componentHeight * 1.5,
              child: Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding),
                child: addImageWidget(true),
              ),
            ),
            SizedBox(
              height: componentHeight,
              child: Form(
                child: Column(
                  children: [
                    // Form(child:  )

                    DefaultTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: _titleController,
                      hintText: 'Area Name',
                      icon: Icons.title,
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),

                    DefaultTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: _descriptionController,
                      hintText: 'Description',
                      icon: Icons.description,
                      keyboardType: TextInputType.text,
                      maxLines: 50,
                      obscureText: false,
                    ),

                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: componentHeight ,
              child: Column(
                children: [
                  DefaultButton(
                      btnText: 'Save Area',
                      onPressed: () async {
                        
                  
                        // String? uid =
                        //     FirebaseAuth.instance.currentUser?.uid;
                  
                        // final properties = FirebaseFirestore.instance
                        //     .collection('properties')
                        //     .doc(selectedLocation);
                  
                        // await _uploadFile(imageFile.path, true);
                  
                        // for (File f in _imageList) {
                        //   await _uploadFile(f.path, false);
                        // }
                  
                        // DateTime now = DateTime.now();
                        // String formattedDate =
                        //     DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
                  
                        // Item.recommendation.add(Item(
                        //   _titleController.text.trim(),
                        //   widget.property_type,
                        //   selectedLocation,
                        //   double.parse(_priceController.text.trim()),
                        //   imageUrl,
                        //   _descriptionController.text.trim(),
                        //   uid,
                        //   formattedDate,
                        //   false,
                        //   imageUrls,
                        // ));
                  
                        // Item newProperty = Item(
                        //   _titleController.text.trim(),
                        //   widget.property_type,
                        //   selectedLocation,
                        //   double.parse(_priceController.text.trim()),
                        //   imageUrl,
                        //   _descriptionController.text.trim(),
                        //   uid,
                        //   formattedDate,
                        //   false,
                        //   imageUrls,
                        // );
                  
                        // Item.nearby.add(newProperty);
                  
                        // properties.update({
                        //   newProperty.dateTime: {
                        //     'title': newProperty.title,
                        //     'type': newProperty.category,
                        //     'location': newProperty.location,
                        //     'price': newProperty.price,
                        //     'imageUrl': newProperty.thumb_url,
                        //     'description': newProperty.description,
                        //     'uid': newProperty.tenantID,
                        //     'favorite': false,
                        //     'images': newProperty.images,
                        //   }
                        // });
                  
                  
                        if (mounted) {
                          widget.refresh();
                        }
                  
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column addImageWidget(bool isThumbnail) {
    return Column(
      children: [
        (imageFile.path == '' && isThumbnail)
            ? const Icon(
                Icons.image,
                size: 60,
                color: kPrimaryColor,
              )
            : (isThumbnail)
                ? Stack(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => _selectPhoto(),
                        // child: Image.network(
                        //   imageUrl as String,
                        //   width: 400,
                        //   height: 200,
                        // ),
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: kPrimaryColor,
                          onPressed: () {
                            //_imageList.removeAt(index);
                            imageFile = File('');
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
        InkWell(
          onTap: () => _selectPhoto(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (imageFile.path != '') ? 'Change thumbnail' : 'Select thumbnail',
              style: kSubTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
