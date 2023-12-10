import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final area = FirebaseFirestore.instance.collection('area');

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  var _isDisabled = false;
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();

  String? imageUrl;
  List<String?> imageUrls = [];
  late File imageFile = File('');

  Future _uploadFile(String path, bool isThumbnail) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('areas')
        .child(DateTime.now().toIso8601String() + p.basename(path));

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
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

    imageFile = File(file.path);

    imageFile = await compressImage(file.path, 35);

    setState(() {});

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
        title: const Text(
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
              height: componentHeight,
              child: Column(
                children: [
                  DefaultButton(
                      isDisabled: _isDisabled,
                      btnText: 'Save Area',
                      onPressed: () async {
                        _isDisabled = !_isDisabled;
                        // String? uid =
                        //     FirebaseAuth.instance.currentUser?.uid;
                        final title = _titleController.text;
                        final description = _descriptionController.text;

                        try {
                          await _uploadFile(imageFile.path, true);
                          await area.add({
                            'title': title,
                            'description': description,
                            'thumbnail': imageUrl
                          });

                          Fluttertoast.showToast(
                              msg: "Created area successfully",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM_RIGHT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kBGColor,
                              textColor: kRevColor,
                              fontSize: 16.0);
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Failure to create area",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM_RIGHT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: kRevColor,
                              fontSize: 16.0);
                          // If there is an error
                        }

                        _isDisabled = !_isDisabled;
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
