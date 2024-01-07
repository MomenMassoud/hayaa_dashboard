import 'package:dashboard/featurs/dashboard/models/store_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/featurs/dashboard/models/gift_model.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/badge_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'dart:html' as html;
import '../../tools/seperated_text.dart';

class EditStorBody extends StatefulWidget{
  StoreModel store;
  EditStorBody(this.store);
  _EditStorBody createState()=>_EditStorBody();
}

enum type { photo, gif,svga }
class _EditStorBody extends State<EditStorBody>{
  final FirebaseStorage _storage=FirebaseStorage.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  File? imageFile;
  bool showPickedFile = false;
  Uint8List some =Uint8List(8);
  List<int>? _selectedFile;
  bool _show=false;
  String allowStore="false";
  String giftType="";
  Uint8List? _bytesData;
  TextEditingController _name=TextEditingController();
  TextEditingController _count=TextEditingController();
  type gender = type.gif;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name=TextEditingController(text: widget.store.time);
    _count=TextEditingController(text: widget.store.price);
    if(widget.store.type=="photo"){
      gender=type.photo;
      giftType='photo';
    }
    else if(widget.store.type=="gif"){
      gender=type.gif;
      giftType='gif';
    }
    else{
      gender=type.svga;
      giftType="svga";
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
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
                        giftType='svga';
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
                        giftType='photo';
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
                        giftType='gif';
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
          showPickedFile == false?InkWell(
            onTap: () {
              _pickImage();
            },
            child: Container(
              height: 150,
              child:widget.store.type!="svga"? CachedNetworkImage(
                  imageUrl: widget.store.photo
              ):SVGASimpleImage(
                resUrl: widget.store.photo,
              ),),
          ):InkWell(
            onTap: () {
              _pickImage();
            },
            child: _bytesData != null ? Container(
                height: 100,
                child: Image.memory(_bytesData!))
                : Container(),
          ),
          const SeperatedText(
            tOne: "Item Time ",
            tTwo: "*",
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Item Time'
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
          ElevatedButton(onPressed: (){
            Allarm();
          }, child: Text("Edit Gift"))
        ],
      ),
    );
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

  void Allarm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Edit Item"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("You Will Edit Item"),
                  ElevatedButton(onPressed: ()async{
                    setState(() {
                      _show=true;
                    });
                    String idd="";
                    if(_bytesData!=null){
                      final uploadTask=await FirebaseStorage.instance.ref('store/${_name.text}').putData(_bytesData!);
                      final urlDownload = await uploadTask.ref.getDownloadURL();
                      String docs="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                      _firestore.collection('store').doc(widget.store.docID).update({
                        'time':_name.text,
                        'price':_count.text.toString(),
                        'photo':urlDownload,
                        'type':gender.toString()=="type.gif"?'gif':gender.toString()=="type.photo"?'photo':'svga'
                      }).then((value){
                        String id="${DateTime.now().toString()}-${_auth.currentUser!.email}";
                        _firestore.collection('gifts').doc(widget.store.docID).collection('history').doc(id).set({
                          'email':_auth.currentUser!.email,
                          'photo':_bytesData==null?'false':'true',
                          'time':widget.store.time==_name.text?'false':'true',
                          'price':widget.store.price==_count.text.toString()?'false':'true',
                          'date':DateTime.now().toString(),
                          'type':widget.store.type==giftType?'false':'true'
                        }).then((value){
                          Navigator.pop(context);
                          setState(() {
                            _show=false;
                          });
                          Navigator.pop(context);
                        });
                      });
                    }
                    else{
                      _firestore.collection('store').doc(widget.store.docID).update({
                        'time':_name.text,
                        'price':_count.text.toString(),
                        'type':gender.toString()=="type.gif"?'gif':gender.toString()=="type.photo"?'photo':'svga'
                      }).then((value){
                        String id="${DateTime.now().toString()}-${_auth.currentUser!.email}";
                        _firestore.collection('store').doc(widget.store.docID).collection('history').doc(id).set({
                          'email':_auth.currentUser!.email,
                          'photo':_bytesData==null?'false':'true',
                          'time':widget.store.time==_name.text?'false':'true',
                          'price':widget.store.price==_count.text.toString()?'false':'true',
                          'date':DateTime.now().toString(),
                          'type':widget.store.type==giftType?'false':'true'
                        }).then((value){
                          Navigator.pop(context);
                          setState(() {
                            _show=false;
                          });
                          Navigator.pop(context);
                        });
                      });
                    }

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

}