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
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('ImagetoText'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          isLoaded
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Container(
                      
                      height: MediaQuery.of(context).size.height/1.6,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(pickedImage), fit: BoxFit.cover)),
                    ),
                  ),
              )
              : Container(
                   height: MediaQuery.of(context).size.height/1.6,
                      width: MediaQuery.of(context).size.width,
                      
              ),
          SizedBox(
            height: 10,
          ),
          
          SizedBox(height: 10),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.amberAccent,
            height: 50,
            minWidth: MediaQuery.of(context).size.width/1.5,
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
                      
                      child: Container(
                        height: MediaQuery.of(context).size.height/2,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(a,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        ))),
                    );
                  });
            },
            child: Text('Read Text',style: TextStyle(fontSize: 20),),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickImage,
        icon: Icon(Icons.image),
        backgroundColor: Colors.amberAccent,
        label: Text('Pick Image')),
    );
  }
}
