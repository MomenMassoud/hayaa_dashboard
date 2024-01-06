import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/agency_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/custom_text_field.dart';
import 'package:dashboard/featurs/login/widgets/gradiant_button.dart';
import 'package:dashboard/featurs/login/widgets/gradient_container.dart';
import 'package:flutter/material.dart';

class AgencyDetailsView extends StatefulWidget {
  const AgencyDetailsView({
    super.key,
    required this.agencyId,
  });
  final String agencyId;

  @override
  State<AgencyDetailsView> createState() => _AgencyDetailsViewState();
}

class _AgencyDetailsViewState extends State<AgencyDetailsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    bool enablEditing = false;

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('agency')
            .where("id", isEqualTo: widget.agencyId)
            .snapshots(),
        builder: (context, snapshot) {
          final masseges = snapshot.data?.docs;
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          List<AgencyModel> agencys = [];
          for (var massege in masseges!.reversed) {
            agencys.add(AgencyModel(
              agencyId: massege.get("id"),
              agencyName: massege.get("name"),
              ownerEmail: massege.get("email"),
              agencyDoc: massege.get("doc"),
              agencyCountry: massege.get("country"),
              agencyBio: massege.get("bio"),
              agencyImage: massege.get("photo"),
              doc: massege.get("doc"),
            ));
          }
          log(agencys.toString());
          final AgencyModel selectedAgency = agencys[0];

          return Scaffold(
            body: Stack(
              children: [
                GradientContainer(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  colorOne: const Color.fromARGB(255, 255, 211, 208),
                  colorTwo: const Color.fromARGB(255, 252, 243, 242),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left: BorderSide(color: Colors.red, width: 2))),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(" Agency Details Modification"),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text("Agency Id : ${widget.agencyId}"),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextField(
                              enable: enablEditing,
                              isNumber: true,
                              initialvalue: selectedAgency.agencyId,
                              fieldName: "Agency Id",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'agency') // Replace with the actual collection name
                                    .doc(selectedAgency.doc)
                                    .update({
                                  'id':
                                      value // Replace with the actual field name
                                });
                              },
                            ),
                            CustomTextField(
                              enable: enablEditing,
                              isNumber: false,
                              initialvalue: selectedAgency.agencyName,
                              fieldName: "Agency Name",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'agency') // Replace with the actual collection name
                                    .doc(selectedAgency.doc)
                                    .update({
                                  'name':
                                      value // Replace with the actual field name
                                });
                              },
                            ),
                            CustomTextField(
                              enable: enablEditing,
                              isNumber: false,
                              initialvalue: selectedAgency.agencyBio,
                              fieldName: "ِAgency Bio",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'agency') // Replace with the actual collection name
                                    .doc(selectedAgency.doc)
                                    .update({
                                  'bio':
                                      value // Replace with the actual field name
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                                image:
                                    NetworkImage(selectedAgency.agencyImage)),
                            const SizedBox(
                              height: 30,
                            ),
                            GradiantButton(
                                screenWidth: screenWidth,
                                buttonLabel: "Delet Agency",
                                onPressed: () {
                                  //Logic to delet this Agency
                                },
                                fontSize: 24),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextField(
                              enable: enablEditing,
                              isNumber: false,
                              initialvalue: selectedAgency.ownerEmail,
                              fieldName: "Owner E-mail",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'agency') // Replace with the actual collection name
                                    .doc(selectedAgency.doc)
                                    .update({
                                  'email':
                                      value // Replace with the actual field name
                                });
                              },
                            ),
                            CustomTextField(
                              enable: enablEditing,
                              isNumber: false,
                              initialvalue: selectedAgency.agencyCountry,
                              fieldName: "Agency Country",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'agency') // Replace with the actual collection name
                                    .doc(selectedAgency.doc)
                                    .update({
                                  'country':
                                      value // Replace with the actual field name
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
