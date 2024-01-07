import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'dart:convert';
import '../../tools/custom_photo_card.dart';
import '../../tools/seperated_text.dart';
class AddNewStoreBody extends StatefulWidget{
  _AddNewStoreBody createState()=>_AddNewStoreBody();
}
enum type {gif, svga,photo}
enum cat {car, frame,bubble,wallpaper}
class _AddNewStoreBody extends State<AddNewStoreBody>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage=FirebaseStorage.instance;
  File? imageFile;
  Uint8List some =Uint8List(8);
  List<int>? _selectedFile;
  bool _show=false;
  Uint8List? _bytesData;
  TextEditingController _name=TextEditingController();
  TextEditingController _count=TextEditingController();
  type gender = type.gif;
  cat choose=cat.car;
  bool showPickedFile = false;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _show,
        child: ListView(
          children: [
            Text("Choose Type Of Item",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      value: type.svga,
                      hoverColor: Colors.black,
                      groupValue: gender,
                      onChanged: (type? g) {
                        setState(() {
                          gender = g!;
                        });
                      },
                    ),
                    Text("SVGA",)
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: type.photo,
                      groupValue: gender,
                      onChanged: (type? g) {
                        setState(() {
                          gender = g!;
                        });
                      },
                    ),
                    Text('Photo'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: type.gif,
                      groupValue: gender,
                      onChanged: (type? g) {
                        setState(() {
                          gender = g!;
                        });
                      },
                    ),
                    Text('Gif'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            showPickedFile == false
                ? CustomImagePicker(
              screenWidth: screenWidth,
              onTap: () {
                _pickImage();
              },
            )
                : InkWell(
              onTap: () {
                _pickImage();
              },
              child: _bytesData != null ? Container(
                  height: 100,
                  child: Image.memory(_bytesData!))
                  : Container(),
            ),
            const SeperatedText(
              tOne: "Item time ",
              tTwo: "*",
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Item time'
              ),
              controller: _name,
            ),
            const SizedBox(
              height: 30,
            ),
            const SeperatedText(
              tOne: "Item Price ",
              tTwo: "*",
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Item Price',
              ),
              controller: _count,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 30,
            ),
            Text("Choose Category Of Item",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      value: cat.car,
                      groupValue: choose,
                      onChanged: (cat? g) {
                        setState(() {
                          choose = g!;
                        });
                      },
                    ),
                    Text("Car",)
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: cat.wallpaper,
                      groupValue: choose,
                      onChanged: (cat? g) {
                        setState(() {
                          choose = g!;
                        });
                      },
                    ),
                    Text('Wallpaper'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: cat.frame,
                      groupValue: choose,
                      onChanged: (cat? g) {
                        setState(() {
                          choose = g!;
                        });
                      },
                    ),
                    Text('Frame'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: cat.bubble,
                      groupValue: choose,
                      onChanged: (cat? g) {
                        setState(() {
                          choose = g!;
                        });
                      },
                    ),
                    Text('Bubble'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: (){Allarm();}, child: Text("Add New Item"))
          ],
        ),
      ),
    );
  }
  void Allarm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Add New Item"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(onPressed: ()async{
                    setState(() {
                      _show=true;
                    });
                    String idd="";
                    final uploadTask=await FirebaseStorage.instance.ref('store/${_name.text}').putData(_bytesData!);
                    final urlDownload = await uploadTask.ref.getDownloadURL();
                    String docs="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                    _firestore.collection('store').doc(docs).set({
                      'cat':choose.toString()=="cat.car"?'car':choose.toString()=="cat.frame"?'frame':choose.toString()=="cat.bubble"?'bubble':'wallpaper',
                      'time':_name.text,
                      'price':_count.text.toString(),
                      'id':docs,
                      'photo':urlDownload,
                      'type':gender.toString()=="type.photo"?'photo':gender.toString()=="type.gif"?'gif':'svga',
                    }).then((value){
                      Navigator.pop(context);
                      setState(() {
                        _show=false;
                      });
                      Navigator.pop(context);
                    });
                  }, child: Text("Yes")),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("No"))
                ],
              )
          );
        });
  }
  _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        setState(() {
          _bytesData =
              Base64Decoder().convert(reader.result.toString().split(",").last);
          _selectedFile = _bytesData;
          showPickedFile=true;
        });
      });
      reader.readAsDataUrl(file);
    });
  }
}