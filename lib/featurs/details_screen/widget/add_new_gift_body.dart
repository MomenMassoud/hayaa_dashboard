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

class AddNewGiftBody extends StatefulWidget{
  _AddNewGiftView createState()=>_AddNewGiftView();
}

enum type {gif, svga,photo}
enum allow {yes, no}
class _AddNewGiftView extends State<AddNewGiftBody>{
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
  allow allows=allow.yes;
  bool showPickedFile = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _show,
        child: ListView(
          children: [
            Text("Choose Type Of Gift",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
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
              tOne: "Gift Name ",
              tTwo: "*",
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Gift Name'
              ),
              controller: _name,
            ),
            const SizedBox(
              height: 30,
            ),
            const SeperatedText(
              tOne: "Gift Price ",
              tTwo: "*",
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Gift Price',
              ),
              controller: _count,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 30,
            ),
            Text("Active",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      value: allow.yes,
                      groupValue: allows,
                      onChanged: (allow? g) {
                        setState(() {
                          allows = g!;
                        });
                      },
                    ),
                    Text('Active'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: allow.no,
                      groupValue: allows,
                      onChanged: (allow? g) {
                        setState(() {
                          allows = g!;
                        });
                      },
                    ),
                    Text('DisActive'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: (){Allarm();}, child: Text("Add New Gift"))
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
              title: Text("Add New Gift"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(onPressed: ()async{
                    setState(() {
                      _show=true;
                    });
                    String idd="";
                    final uploadTask=await FirebaseStorage.instance.ref('gifts/${_name.text}').putData(_bytesData!);
                    final urlDownload = await uploadTask.ref.getDownloadURL();
                    String docs="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                    _firestore.collection('gifts').doc(docs).set({
                     'allow':allows.toString()=="allow.yes"?'true':'false',
                      'creat':_auth.currentUser!.email,
                      'date':DateTime.now().toString(),
                      'name':_name.text,
                      'price':_count.text.toString(),
                      'photo':urlDownload,
                      'type':gender.toString()=="type.gif"?'gif':gender.toString()=="type.photo"?'photo':'svga'
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