import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:distance_range_estimator/types/constants.dart';
import 'package:distance_range_estimator/widgets/default_button.dart';
import 'package:distance_range_estimator/widgets/default_textfield.dart';
import 'package:distance_range_estimator/widgets/image_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

import 'package:cloud_firestore/cloud_firestore.dart';

class AddDistanceScreen extends StatefulWidget {
  final String distance;

  const AddDistanceScreen({super.key, required this.distance});

  @override
  State<AddDistanceScreen> createState() => _AddDistanceScreenState();
}

class _AddDistanceScreenState extends State<AddDistanceScreen> {
  final CollectionReference measurements =
      FirebaseFirestore.instance.collection('measurements');
  final CollectionReference distances =
      FirebaseFirestore.instance.collection('distances');

  final _labelController = TextEditingController();
  final _saveToController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageList = [];

  String? imageUrl;
  List<String?> imageUrls = [];
  late File imageFile = File('');

  Future _uploadFile(String path) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('properties')
        .child(DateTime.now().toIso8601String() + p.basename(path));

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrls.add(fileUrl);
      // imageUrls.add(path);
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

  void _selectImages(ImageSource source) async {
    final selectedImage = await _picker.pickImage(source: source);

    print("Passed");

    if (selectedImage == null) return;

    // if (selectedImage!.path.isNotEmpty) {
    //   _imageList.add(selectedImage);
    // }

    final file = await ImageCropper().cropImage(sourcePath: selectedImage.path);

    var imgFile = File(file!.path);

    imgFile = await compressImage(file.path, 35);

    _imageList.add(imgFile);

    setState(() {});

    // _imageList.add(await compressImage(file.pa
    // , 35))
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
                  _selectImages(ImageSource.camera);
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
                  _selectImages(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  Column addImageWidget(bool isThumbnail) {
    return Column(
      children: [
        InkWell(
          onTap: () => _selectPhoto(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Add Images',
              style: kSubTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _saveToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kBGColor,
        centerTitle: true,
        title: const Text("Add Distance", style: kHeadTextStyle),
        foregroundColor: kRevColor,
      ),
      // body: ImageListView(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                  child: Text(
                    "Captured Distance",
                    style: kSubTextStyle,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  "${widget.distance} CM",
                  style: kHeadTextStyle,
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: kLessPadding),
                  child: DefaultTextField(
                    hintText: "Enter label",
                    icon: Icons.label,
                    controller: _labelController,
                    keyboardType: TextInputType.text,
                    validator: null,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: kLessPadding),
                  child: DefaultTextField(
                    hintText: "Save To",
                    icon: Icons.save,
                    controller: _saveToController,
                    keyboardType: TextInputType.text,
                    validator: null,
                  ),
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              // Flexible(
              //   flex: 4,
              //   child: ImageListView(),
              // ),
              // const SizedBox(
              //   height: kDefaultPadding,
              // ),
              (_imageList.isNotEmpty)
                  ? Flexible(
                      flex: 4,
                      child: SizedBox(
                        // height: 180,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: _imageList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(
                                      _imageList[index].path,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: -4,
                                    top: -4,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: kPrimaryColor,
                                      onPressed: () {
                                        _imageList.removeAt(index);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: kDefaultPadding,
                    ),
              // const SizedBox(
              //   height: kDefaultPadding,
              // ),
              DefaultButton(
                btnText: "Upload Picture",
                onPressed: () => {_selectPhoto()},
              ),
              DefaultButton(
                btnText: "Save Distance",
                onPressed: () async {
                  try {
                    QuerySnapshot querySnapshot = await measurements
                        .where('title', isEqualTo: _saveToController.text)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

                      // Cast data to the expected type (Map<String, dynamic>)
                      // final data =
                      //     documentSnapshot.data() as Map<String, dynamic>;

                      try {
                        for (File f in _imageList) {
                          await _uploadFile(f.path);
                        }

                        await distances.add({
                          'distance': widget.distance,
                          'label': _labelController.text,
                          'saveTo': _saveToController.text,
                          'saveToId': documentSnapshot.id,
                          'imageUrls': imageUrls,
                          'created_at': Timestamp.now(),
                        });

                        Fluttertoast.showToast(
                            msg:
                                "Captured distance saved to ${_saveToController.text} measurements.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM_RIGHT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: kBGColor,
                            textColor: kRevColor,
                            fontSize: 16.0);

                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg:
                                "Failure to savw the distance in the ${_saveToController.text} measurements",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM_RIGHT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: kRevColor,
                            fontSize: 16.0);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "No document found with ${_saveToController.text} measurements",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM_RIGHT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: kRevColor,
                          fontSize: 16.0);
                    }
                  } catch (e) {
                    print('Error: $e');
                  }

                  // Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
