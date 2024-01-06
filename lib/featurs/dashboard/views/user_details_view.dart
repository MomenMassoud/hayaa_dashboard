import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/user_model.dart';
import 'package:dashboard/featurs/details_screen/view/device_id_view.dart';
import 'package:dashboard/featurs/login/widgets/gradient_container.dart';
import 'package:flutter/material.dart';

class UserDetailsView extends StatefulWidget {
  const UserDetailsView({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool enablEditing = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user')
            .where("doc", isEqualTo: widget.userId)
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
          List<UserModel> users = [];
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
                doc: massege.get("doc"),
                bio: massege.get("bio"),
                image: massege.get("photo"),
                gender: massege.get('gender'),
                device: massege.get("devicetoken"),
                vipDead: massege.get('vip_end'),
                 userCountry:massege.get('user_country'),
                phoneNum: massege.get('phonenumber'),
              ),
            );
          }
          final UserModel selectedUser = users[0];
          int coins = int.parse(selectedUser.coins);
          int diamonds = int.parse(selectedUser.diamonds);

          String type = selectedUser.type;

          return Scaffold(
            body: Stack(
              children: [
                GradientContainer(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  colorOne: const Color.fromARGB(255, 255, 211, 208),
                  colorTwo: const Color.fromARGB(255, 252, 243, 242),
                ),
                ListView(
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
                        child: Text(" User Details"),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                   Table(
                     children: [
                       const TableRow(
                         children: [
                           Text("ID",style: TextStyle(color: Colors.red),),
                           Text("UID",style: TextStyle(color: Colors.green),),
                           Text("Photo"),
                           Text("AppInfo"),
                           Text("Details"),
                           Text("Moreinfo"),
                           Text("button"),
                           Text("Action"),
                         ]
                       ),
                       TableRow(
                           children: [
                             Text(widget.userId,style: TextStyle(color: Colors.red),),
                             Text(selectedUser.userId,style: TextStyle(color: Colors.green),),
                             Container(
                               height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(
                                    selectedUser.image.toString()
                                ),)
                              ),
                             ),
                             Text("AppInfo"),
                             Text("Name:${selectedUser.userName}"),
                             Text("Active:${selectedUser.type}"),
                             InkWell(
                               onTap: (){},
                                 child: Text("Details",style: TextStyle(color: Colors.blue),)),
                             InkWell(
                                 onTap: (){},
                                 child: Text("Editing and Modification Basic information",style: TextStyle(color: Colors.blue),)),
                           ]
                       ),
                       TableRow(
                           children: [
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text("Device ID:"),
                             Text("ActivationTime:"),
                             InkWell(
                                 onTap: (){},
                                 child: Text("room",style: TextStyle(color: Colors.blue),)),
                             InkWell(
                                 onTap: (){},
                                 child: Text("Setting Default Avatar",style: TextStyle(color: Colors.blue),)),
                           ]
                       ),
                       TableRow(
                         children: [
                           Text(""),
                           Text(""),
                           Text(""),
                           Text(""),
                           InkWell(
                             onTap: (){
                               Navigator.of(context).push(
                                   MaterialPageRoute(builder: (context) => DeviceIDView(selectedUser.device.toString())));
                             },
                             child: Text("${selectedUser.device}",style: TextStyle(color: Colors.blue),),
                           ),
                           Text("RegistrationTime:"),
                           InkWell(
                               onTap: (){},
                               child: Text("banned users",style: TextStyle(color: Colors.blue),)),
                           InkWell(
                               onTap: (){},
                               child: Text("Send System messages",style: TextStyle(color: Colors.blue),)),
                         ]
                       ),
                       TableRow(
                           children: [
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text("Country: ${selectedUser.userCountry}"),
                             Text("Last Active Time:"),
                             Text(""),
                             InkWell(
                                 onTap: (){},
                                 child: Text("Unbinding",style: TextStyle(color: Colors.blue),)),
                           ]
                       ),
                       TableRow(
                           children: [
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text("Last Login Method:"),
                             Text(""),
                             InkWell(
                                 onTap: (){},
                                 child: Text("Third Party Account",style: TextStyle(color: Colors.blue),)),
                           ]
                       ),

                       TableRow(
                           children: [
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text("Mobile Number: ${selectedUser.phoneNum}"),
                             Text("Charm level:${selectedUser.lvl2}"),
                             Text(""),
                             InkWell(
                                 onTap: (){},
                                 child: Text("Modification user bindings and adding titles",style: TextStyle(color: Colors.blue),)),
                           ]
                       ),
                       TableRow(
                           children: [
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text("Wealth Level:${selectedUser.lvl}"),
                             Text(""),
                             Text(""),
                           ]
                       ),
                       TableRow(
                           children: [
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text(""),
                             Text("UserOrgaanization:Personal"),
                             Text(""),
                             Text(""),
                           ]
                       ),
                     ],
                   )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
