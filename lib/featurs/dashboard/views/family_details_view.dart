import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/family_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/custom_text_field.dart';
import 'package:dashboard/featurs/login/widgets/gradiant_button.dart';
import 'package:dashboard/featurs/login/widgets/gradient_container.dart';
import 'package:flutter/material.dart';

class FamilyDetailsView extends StatefulWidget {
  const FamilyDetailsView({
    super.key,
    required this.familyId,
  });
  final String familyId;

  @override
  State<FamilyDetailsView> createState() => _FamilyDetailsViewState();
}

class _FamilyDetailsViewState extends State<FamilyDetailsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    bool enablEditing = false;

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('family')
            .where("idd", isEqualTo: widget.familyId)
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
          List<FamilyModel> familyies = [];
          for (var massege in masseges!.reversed) {
            familyies.add(
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
          final FamilyModel selectedFamily = familyies[0];

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
                        child: Text(" Family Details Modification"),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text("Family Id : ${widget.familyId}"),
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
                              initialvalue: selectedFamily.familyId,
                              fieldName: "Family Id",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'family') // Replace with the actual collection name
                                    .doc(selectedFamily.familyDoc)
                                    .update({
                                  'idd':
                                      value // Replace with the actual field name
                                });
                              },
                            ),
                            CustomTextField(
                              enable: enablEditing,
                              isNumber: false,
                              initialvalue: selectedFamily.familyName,
                              fieldName: "Family Name",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'family') // Replace with the actual collection name
                                    .doc(selectedFamily.familyDoc)
                                    .update({
                                  'name':
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
                                    NetworkImage(selectedFamily.familyImage)),
                            const SizedBox(
                              height: 30,
                            ),
                            GradiantButton(
                                screenWidth: screenWidth,
                                buttonLabel: "Delet Family",
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
                              initialvalue: selectedFamily.familyBio,
                              fieldName: "Family Bio",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'family') // Replace with the actual collection name
                                    .doc(selectedFamily.familyDoc)
                                    .update({
                                  'bio':
                                      value // Replace with the actual field name
                                });
                              },
                            ),
                            CustomTextField(
                              enable: enablEditing,
                              isNumber: true,
                              initialvalue: selectedFamily.lvl,
                              fieldName: "Family Level",
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        'family') // Replace with the actual collection name
                                    .doc(selectedFamily.familyDoc)
                                    .update({
                                  'level':
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
