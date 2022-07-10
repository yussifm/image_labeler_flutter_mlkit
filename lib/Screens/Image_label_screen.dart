// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelerScreen extends StatefulWidget {
  ImageLabelerScreen({Key? key}) : super(key: key);

  @override
  State<ImageLabelerScreen> createState() => _ImageLabelerScreenState();
}

class _ImageLabelerScreenState extends State<ImageLabelerScreen> {
  bool imageLabelChecking = false;

  XFile? imageFile;
  String imageLabelPredictions = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Labeller"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (imageLabelChecking)
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Column(
                    children: const [
                      Expanded(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      Expanded(
                        child: Text("Processing Image"),
                      ),
                    ],
                  ),
                ),
              if (!imageLabelChecking && imageFile == null)
                Container(
                  width: 350,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Text("Pick an Image"),
                  ),
                ),
              if (imageFile != null)
                Image.file(
                  File(imageFile!.path),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        getImage(source: ImageSource.camera);
                      },
                      icon: Icon(Icons.camera_alt_outlined),
                      label: Text("Camera"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        getImage(source: ImageSource.gallery);
                      },
                      icon: Icon(Icons.image_outlined),
                      label: Text("Gallery"),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                imageLabelPredictions,
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageLabelChecking = true;
        imageFile = pickedImage;
        setState(() {});
      }
    } catch (e) {
      imageLabelChecking = false;
      imageFile = null;
      imageLabelPredictions = e.toString();
      setState(() {});
    }
  }

  void getImageLabelsPredictions({required XFile image}) async {
    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.75));
    List<ImageLabel> imgLabels = await imageLabeler.processImage(inputImage);
    StringBuffer sBuffer = StringBuffer();

    for (ImageLabel imglabel in imgLabels) {
      String labelText = imglabel.label;
      double confidence = imglabel.confidence;
      sBuffer.write(labelText);
      sBuffer.write(":");
      sBuffer.write((confidence * 100).toStringAsFixed(2));
      sBuffer.write("%\n"); //adding the % sign and newline
    }
    imageLabeler.close(); // release resources
    imageLabelPredictions = sBuffer.toString();
    imageLabelChecking = false;
    setState(() {});
  }
}
