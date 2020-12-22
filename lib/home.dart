import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File pickedImage;
  bool isLoaded = false;
  Future pickImage() async{
    var temp = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      pickedImage = temp;
      isLoaded=true;
    });
  }
  Future readText() async{
    FirebaseVisionImage image = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer readText = FirebaseVision.instance.textRecognizer();
    VisionText text = await readText.processImage(image);
    for (TextBlock block in text.blocks){
      for(TextLine line in block.lines){
        for(TextElement word in line.elements){
          print(word.text);
        }
      }
    }
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         isLoaded ? Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(pickedImage),fit: BoxFit.cover
                )
              ),
            ),
          ): Container(),
          SizedBox(height: 10,),
          RaisedButton(
            onPressed: pickImage,
            child: Text('Pick an image'),
            ),
            SizedBox(height:10),
            RaisedButton(
              onPressed: readText,
              child: Text('Read Text'),
            )
        ],
      ),
    );
  }
}