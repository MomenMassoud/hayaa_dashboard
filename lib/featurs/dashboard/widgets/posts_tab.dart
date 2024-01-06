import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostesTab extends StatefulWidget {
  const PostesTab({super.key});

  @override
  State<PostesTab> createState() => _PostesTabState();
}

class _PostesTabState extends State<PostesTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String value = "";
  String keySearch = "year";

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('post')
            .where(keySearch, isGreaterThanOrEqualTo: value)
            .where(keySearch, isLessThanOrEqualTo: '$value\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          List<PostModel> posts = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            posts.add(PostModel(
              postDay: massege.get("day"),
              postMonth: massege.get("month"),
              postYear: massege.get("year"),
              ownerName: massege.get("owner_name"),
              postContent: massege.get("text"),
              postImage: massege.get("photo"),
              postDoc: massege.id,
            ));
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
                    child: Text("Searching For post Or Deleting It "),
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
                            hintText: "Search By Post $keySearch...",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            )),
                      ),
                    ),
                    Row(
                      children: [
                        const Text("select Search filter : "),
                        const SizedBox(
                          width: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                keySearch = "year";
                              });
                            },
                            child: const Text("Filter By year")),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                keySearch = "owner_name";
                              });
                            },
                            child: const Text("Filter Owner Name ")),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(" Numbers of post : ${posts.length.toString()}"),
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
                        child: Text("Post Content",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.125,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Owner Name",
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.125,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Day"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.125,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Month"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.1,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Year"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.1,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Post Image"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.1,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Delet Option"),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return AgencyListViewItem(
                        postModel: posts[index],
                        currentPostdoc: posts[index].postDoc,
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  void performSearch(String searchTerm) {
    // Add your search logic here
    log('Searching for: $searchTerm');
    setState(() {
      value = searchTerm;
    });
  }
}

class AgencyListViewItem extends StatefulWidget {
  const AgencyListViewItem({
    super.key,
    required this.postModel,
    required this.currentPostdoc,
  });
  final PostModel postModel;
  final String currentPostdoc;

  @override
  State<AgencyListViewItem> createState() => _AgencyListViewItemState();
}

class _AgencyListViewItemState extends State<AgencyListViewItem> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: screenWidth * 0.125,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.postModel.postContent,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.red)),
            ),
          ),
          const Text("|"),
          SizedBox(
            width: screenWidth * 0.125,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.postModel.ownerName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.blue)),
            ),
          ),
          const Text("|"),
          SizedBox(
            width: screenWidth * 0.125,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.postModel.postDay,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Text("|"),
          SizedBox(
            width: screenWidth * 0.125,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.postModel.postMonth),
            ),
          ),
          const Text("|"),
          SizedBox(
            width: screenWidth * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.postModel.postYear,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          const Text("|"),
          SizedBox(
            width: screenWidth * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: widget.postModel.postImage),
            ),
          ),
          const Text("|"),
          SizedBox(
            width: screenWidth * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    
                    var docRef = _firestore
                        .collection("post")
                        .doc(widget.currentPostdoc);
                    docRef.delete();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Delet this post ! ",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
