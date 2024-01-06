import 'package:dashboard/featurs/dashboard/models/gift_model.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GiftsTab extends StatefulWidget {
  const GiftsTab({
    super.key,
  });

  @override
  State<GiftsTab> createState() => _GiftsTabState();
}

class _GiftsTabState extends State<GiftsTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String value = "";
  String keySearch = "name";

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('gifts')
            .where(keySearch, isGreaterThanOrEqualTo: value)
            .where(keySearch, isLessThanOrEqualTo: '$value\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          List<GiftModel> gifts = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
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
                    child: Text("Searching For gift"),
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
                            hintText: "Search By gift $keySearch ....",
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
                                keySearch = "name";
                              });
                            },
                            child: const Text("Filter By name")),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                keySearch = "price";
                              });
                            },
                            child: const Text("Filter By Price ")),
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
                Text(" Numbers of gifts now : ${gifts.length.toString()}"),
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
                        child: Text("Gift Name",
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
                        child: Text("Gift Price",
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
                        child: Text("Gift Type"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.1,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Gift Image"),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: gifts.length,
                    itemBuilder: (context, index) {
                      return GiftListViewItem(
                        giftModel: gifts[index],
                        onTap: () {},
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {},
                        child: const Text(
                          "Add Gift",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
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

class GiftListViewItem extends StatelessWidget {
  const GiftListViewItem({
    super.key,
    this.onTap,
    required this.giftModel,
  });
  final GiftModel giftModel;
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
                child: Text(giftModel.giftName,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(giftModel.giftPrice,
                    style: const TextStyle(color: Colors.blue)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  giftModel.giftType,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: giftModel.giftImage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
