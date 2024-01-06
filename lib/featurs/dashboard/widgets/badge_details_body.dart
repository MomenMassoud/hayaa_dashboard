import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/badge_model.dart';
import 'package:flutter/material.dart';
import '../../details_screen/widget/add_new_badge.dart';
import '../../tools/custom_photo_card.dart';
import 'dart:html' as html;
import 'dart:convert';
class BadgeDetailsBody extends StatefulWidget{
  _BadgeDetailsBody createState()=>_BadgeDetailsBody();
}

class _BadgeDetailsBody extends State<BadgeDetailsBody>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String value="";
  File? imageFile;
  bool showPickedFile = false;
  Random random = new Random();
  Uint8List some =Uint8List(8);
  List<int>? _selectedFile;
  Uint8List? _bytesData;
  TextEditingController _name=TextEditingController();
  TextEditingController _count=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('badges').where('id',isGreaterThanOrEqualTo:value).where('id',isLessThanOrEqualTo: value + '\uf8ff').snapshots(),
      builder: (context,snapshot){
        List<BadgeModel> badges=[];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final masseges = snapshot.data?.docs;
        for (var massege in masseges!.reversed){
          badges.add(
            BadgeModel(count: massege.get('count'),
                id: massege.get('id'),
                gift: massege.get('gift'), photo: massege.get('photo'),
                Name: massege.get('name'), doc: massege.id,giftphoto: massege.get('giftphoto'))
          );
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(color: Colors.green, width: 2))),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Searching For Badge"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      onChanged: performSearch,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search By Badge ID....",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          )),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewBadge()));
                  }, child: Text("Add New Badge"))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(" Numbers of Badges : ${badges.length.toString()}"),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: screenWidth * 0.125,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Badge Id",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Text("|"),
                  SizedBox(
                    width: screenWidth * 0.125,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Badge Name",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Text("|"),
                  SizedBox(
                    width: screenWidth * 0.125,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Badge Photo",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Text("|"),
                  SizedBox(
                    width: screenWidth * 0.125,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Gift Photo",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Text("|"),
                  SizedBox(
                    width: screenWidth * 0.125,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Count of Gift",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Text("|"),
                  SizedBox(
                    width: screenWidth * 0.125,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Action",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: badges.length,
                  itemBuilder: (context, index) {
                    return BadgeListViewItem(
                      badgeModel: badges[index],
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
  void performSearch(String searchTerm) {
    print('Searching for: $searchTerm');
    setState(() {
      value=searchTerm;
    });
  }
}

class BadgeListViewItem extends StatelessWidget {
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
   BadgeListViewItem({
    super.key,
    required this.badgeModel,
    this.onTap,
  });
  final BadgeModel badgeModel;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(badgeModel.id,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(badgeModel.Name,
                    style: const TextStyle(color: Colors.blue)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:CachedNetworkImage(imageUrl: badgeModel.photo),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(badgeModel.giftphoto,scale: 4,),

              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(badgeModel.count)
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){

                        },
                          child: Text("Edit",style: TextStyle(color: Colors.blue),)),

                      InkWell(
                          onTap:(){},
                          child: Text("Send to User",style: TextStyle(color: Colors.blue),))
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}