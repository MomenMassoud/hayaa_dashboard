import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/agency_model.dart';
import 'package:dashboard/featurs/dashboard/views/agency_details_view.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AgenciesTab extends StatefulWidget {
  const AgenciesTab({super.key});

  @override
  State<AgenciesTab> createState() => _AgenciesTabState();
}

class _AgenciesTabState extends State<AgenciesTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String value = "";
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('agency')
            .where('id', isGreaterThanOrEqualTo: value)
            .where('id', isLessThanOrEqualTo: '$value\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          List<AgencyModel> agencies = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            agencies.add(
              AgencyModel(
                  agencyId: massege.get("id"),
                  agencyName: massege.get("name"),
                  ownerEmail: massege.get("email"),
                  agencyDoc: massege.get("doc"),
                  agencyCountry: massege.get("country"),
                  agencyBio: massege.get("bio"),
                  agencyImage: massege.get("photo")),
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
                    child: Text("Searching For Agency"),
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
                        hintText: "Search By Agency Id....",
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
                Text(" Numbers of Agencies : ${agencies.length.toString()}"),
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
                        child: Text("Agency Id",
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
                        child: Text("Agency Name",
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
                        child: Text("Agency Bio"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.125,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Agency Country"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.1,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Agency Owner Email"),
                      ),
                    ),
                    const Text("|"),
                    SizedBox(
                      width: screenWidth * 0.1,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Agency Image"),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: agencies.length,
                    itemBuilder: (context, index) {
                      return AgencyListViewItem(
                        agencyModel: agencies[index],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AgencyDetailsView(
                                      agencyId: agencies[index].agencyId)));
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

class AgencyListViewItem extends StatelessWidget {
  const AgencyListViewItem({
    super.key,
    this.onTap,
    required this.agencyModel,
  });
  final AgencyModel agencyModel;
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
                child: Text(agencyModel.agencyId,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(agencyModel.agencyName,
                    style: const TextStyle(color: Colors.blue)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  agencyModel.agencyBio,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(agencyModel.agencyCountry),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(agencyModel.ownerEmail,
                    overflow: TextOverflow.ellipsis),
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
                    imageUrl: agencyModel.agencyImage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
