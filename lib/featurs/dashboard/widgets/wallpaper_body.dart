import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/store_model.dart';
import '../views/edit_store_view.dart';
import '../views/history_item_view.dart';


class WallpaperBody extends StatefulWidget{
  _WallpaperBody createState()=>_WallpaperBody();
}


class _WallpaperBody extends State<WallpaperBody>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('store').where('cat',isEqualTo: 'wallpaper').snapshots(),
      builder: (context,snapshot){
        List<StoreModel> store=[];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final masseges = snapshot.data?.docs;
        for (var massege in masseges!.reversed){
          store.add(
              StoreModel(docID: massege.id, price: massege.get('price'),
                  type: massege.get('type'), photo: massege.get('photo'), cat: massege.get('cat'), time: massege.get('time'))
          );
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(" Numbers of Wallpaper : ${store.length.toString()}"),
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
                        child: Text("Photo",
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
                        child: Text("Price",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.125,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Time",
                            style: TextStyle(
                                color: Colors.green,
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
                    const Text("|"),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: store.length,
                    itemBuilder: (context, index) {
                      return StoreListViewItem(
                        userModel: store[index],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HistoryItemView(
                                    store[index],
                                  )));
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
class StoreListViewItem extends StatelessWidget {
  const StoreListViewItem({
    super.key,
    required this.userModel,
    this.onTap,
  });
  final StoreModel userModel;
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
                child: CachedNetworkImage(imageUrl: userModel.photo),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.price,
                    style: const TextStyle(color: Colors.blue)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.time,style: TextStyle(color: Colors.green),),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Text("Edit",style: TextStyle(color: Colors.red),),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditStorView(
                              userModel,
                            )));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}