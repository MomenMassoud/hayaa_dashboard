import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/gift_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'dart:convert';
import '../../tools/custom_photo_card.dart';
import '../../tools/seperated_text.dart';

class AddNewBadge extends StatefulWidget{
  _AddNewBadge createState()=>_AddNewBadge();
}


class _AddNewBadge extends State<AddNewBadge>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage=FirebaseStorage.instance;
  File? imageFile;
  bool showPickedFile = false;
  Random random = new Random();
  Uint8List some =Uint8List(8);
  List<int>? _selectedFile;
  bool _show=false;
  Uint8List? _bytesData;
  TextEditingController _name=TextEditingController();
  TextEditingController _count=TextEditingController();
  late GiftModel selectedGift;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _show,
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('gifts').snapshots(),
            builder: (context,snapshot){
              List<GiftModel> gifts=[];
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                gifts.add(
                  GiftModel(
                    giftName: massege.get("name"),
                    giftPrice: massege.get("price"),
                    giftType: massege.get("type"),
                    giftImage: massege.get("photo"),
                    giftDoc: massege.id,
                  ),
                );
              }
              return ListView(
                children: [
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
                    tOne: "Badge Name ",
                    tTwo: "*",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Badge Name'
                    ),
                    controller: _name,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SeperatedText(
                    tOne: "Target Count ",
                    tTwo: "*",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Target Count',
                    ),
                    controller: _count,
                    keyboardType: TextInputType.number,
                  ),
                  const SeperatedText(
                    tOne: "Target Gift",
                    tTwo: "*",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: gifts.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: InkWell(
                            onTap: (){
                              selectedGift=gifts[index];
                              Allarm(gifts[index].giftName);
                            },
                            child: Column(
                              children: [
                                gifts[index].giftType=="svga"?CircleAvatar(
                                  radius: 32,
                                  child: SVGASimpleImage(
                                    resUrl: gifts[index].giftImage,
                                  ),
                                )
                                    : CachedNetworkImage(
                                  imageUrl: gifts[index].giftImage,
                                  width: 50,
                                ),
                                SizedBox(height: 30,),
                                Text(gifts[index].giftName),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
        ),
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
  void Allarm(String Name) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Add New Badge"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                 Text("Are Your Sure Select Target Gift($Name)"),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()async{
                    setState(() {
                      _show=true;
                    });
                    String idd="";
                    for(int i=0;i<8;i++){
                      int randomNumber = random.nextInt(10);
                      idd="$idd$randomNumber";
                    }
                    final uploadTask=await FirebaseStorage.instance.ref('Badges/${_name.text}').putData(_bytesData!);
                    final urlDownload = await uploadTask.ref.getDownloadURL();
                    String docs="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                    _firestore.collection('badges').doc(docs).set({
                      'count':_count.text.toString(),
                      'gift':selectedGift.giftDoc,
                      'giftphoto':selectedGift.giftImage,
                      'name':_name.text,
                      'photo':urlDownload,
                      'id':idd
                    }).then((value){
                      setState(() {
                        _show=false;
                      });
                      Navigator.pop(context);
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
  
}