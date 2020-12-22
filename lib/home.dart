import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String a;
  File pickedImage;
  bool isLoaded = false;
  Future pickImage() async {
    var temp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = temp;
      isLoaded = true;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          isLoaded
              ? Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(pickedImage), fit: BoxFit.cover)),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: pickImage,
            child: Text('Pick an image'),
          ),
          SizedBox(height: 10),
          MaterialButton(
            height: 50,
            
            onPressed: () async {
              FirebaseVisionImage image =
                  FirebaseVisionImage.fromFile(pickedImage);
              TextRecognizer readText =
                  FirebaseVision.instance.textRecognizer();
              VisionText text = await readText.processImage(image);
              a = text.text;
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Text(a),
                  );
                }
              );
            },
            child: Text('Read Text'),
          ),
        ],
      ),
    );
  }
}
