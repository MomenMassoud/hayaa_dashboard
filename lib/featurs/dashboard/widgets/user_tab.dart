import 'dart:developer';

import 'package:dashboard/featurs/dashboard/models/user_model.dart';
import 'package:dashboard/featurs/dashboard/views/user_details_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({
    super.key,
  });

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String value = "";
  String keySearch = "id";

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user')
            .where(keySearch, isGreaterThanOrEqualTo: value)
            .where(keySearch, isLessThanOrEqualTo: '$value\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          List<UserModel> users = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            users.add(
              UserModel(
                userId: massege.get('id'),
                userName: massege.get('name'),
                coins: massege.get('coin'),
                diamonds: massege.get('daimond'),
                lvl2: massege.get('level2'),
                lvl: massege.get('level'),
                type: massege.get('type'),
                vip: massege.get('vip'),
                country: massege.get("country"),
                phoneNum: massege.get("phonenumber"),
                doc:  massege.id,
              ),
            );
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(color: Colors.green, width: 2))),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Searching For User"),
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
                              hintText: "Search By User $keySearch....",
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
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  keySearch = "country";
                                });
                              },
                              child: const Text("Filter By Country")),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  keySearch = "id";
                                });
                              },
                              child: const Text("Filter By ID")),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  keySearch = "type";
                                });
                              },
                              child: const Text("Filter By Type")),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  keySearch = "phonenumber";
                                });
                              },
                              child: const Text("Filter By Phone Number")),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  keySearch = "name";
                                });
                              },
                              child: const Text("Filter By Name")),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(" Numbers of Users : ${users.length.toString()}"),
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
                          child: Text("User Id",
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
                          child: Text("user Name",
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
                          child: Text("Coins"),
                        ),
                      ),
                      const Text("|"),
                      SizedBox(
                        width: screenWidth * 0.125,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Diamonds"),
                        ),
                      ),
                      const Text("|"),
                      SizedBox(
                        width: screenWidth * 0.1,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("User lvl"),
                        ),
                      ),
                      const Text("|"),
                      SizedBox(
                        width: screenWidth * 0.1,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("User lvl 2"),
                        ),
                      ),
                      const Text("|"),
                      SizedBox(
                        width: screenWidth * 0.125,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("User Type",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const Text("|"),
                      SizedBox(
                        width: screenWidth * 0.1,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("VIP"),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return UserListViewItem(
                          userModel: users[index],
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserDetailsView(
                                      userId: users[index].doc,
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
        });
  }

  void performSearch(String searchTerm) {
    // Add your search logic here
    log('Searching for: $searchTerm');
    setState(() {
      if (keySearch == "country") {
        value = searchTerm.toUpperCase();
      } else {
        value = searchTerm;
      }
    });
  }
}

class UserListViewItem extends StatelessWidget {
  const UserListViewItem({
    super.key,
    required this.userModel,
    this.onTap,
  });
  final UserModel userModel;
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
                child: Text(userModel.userId,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.userName,
                    style: const TextStyle(color: Colors.blue)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.coins),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.diamonds),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.lvl),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.lvl2),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.type,
                    style: const TextStyle(color: Colors.green)),
              ),
            ),
            const Text("|"),
            SizedBox(
              width: screenWidth * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(userModel.vip),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
