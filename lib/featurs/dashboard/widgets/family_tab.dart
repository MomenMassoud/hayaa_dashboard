import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/family_model.dart';
import 'package:dashboard/featurs/dashboard/views/family_details_view.dart';
import 'package:flutter/material.dart';

class FamilyTab extends StatefulWidget {
  const FamilyTab({super.key});

  @override
  State<FamilyTab> createState() => _FamilyTabState();
}

class _FamilyTabState extends State<FamilyTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String value = "";
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('family')
            .where('idd', isGreaterThanOrEqualTo: value)
            .where('idd', isLessThanOrEqualTo: '$value\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          List<FamilyModel> families = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            families.add(
              FamilyModel(
                familyId: massege.get("idd"),
                familyName: massege.get("name"),
                lvl: massege.get("level"),
                familyDoc: massege.get("id"),
                familyBio: massege.get("bio"),
                familyImage: massege.get("photo"),
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
                    child: Text("Searching For Family"),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    onChanged: performSearch,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search By Family Id....",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(" Numbers of Familys : ${families.length.toString()}"),
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
                        child: Text("Family Id",
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
                        child: Text("Family Name",
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
                        child: Text("Family Bio"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.125,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Family lvl"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.1,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Family Image"),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: families.length,
                    itemBuilder: (context, index) {
                      return FamilyListViewItem(
                        familyModel: families[index],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FamilyDetailsView(
                                      familyId: families[index].familyId)));
                          log(families[index].familyId);
                        },
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

class FamilyListViewItem extends StatelessWidget {
  const FamilyListViewItem({
    super.key,
    this.onTap,
    required this.familyModel,
  });
  final FamilyModel familyModel;
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
                child: Text(familyModel.familyId,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(familyModel.familyName,
                    style: const TextStyle(color: Colors.blue)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  familyModel.familyBio,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(familyModel.lvl),
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
                    imageUrl: familyModel.familyImage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
