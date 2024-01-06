import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/views/user_details_view.dart';
import 'package:flutter/material.dart';

import '../../dashboard/models/user_model.dart';
import '../../login/widgets/gradient_container.dart';


class DeviceIDBody extends StatefulWidget{
  String deviceID;
  DeviceIDBody(this.deviceID);
  _DeviceIDBody createState()=>_DeviceIDBody();
}


class _DeviceIDBody extends State<DeviceIDBody>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return  StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user')
            .where("devicetoken", isEqualTo: widget.deviceID)
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
          return Scaffold(
            body: Stack(
              children: [
                GradientContainer(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  colorOne: const Color.fromARGB(255, 255, 211, 208),
                  colorTwo: const Color.fromARGB(255, 252, 243, 242),
                ),
                ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context,index){
                    if(index==0){
                      return Column(
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
                              child: Text("Device Details"),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => UserDetailsView( userId: users[index].doc.toString(),)));
                            },
                            child: Table(
                              children: [
                                TableRow(
                                  children: [
                                    Text("ID",style: TextStyle(color: Colors.red),),
                                    Text("UID",style: TextStyle(color: Colors.green),),
                                    Text("Name"),
                                    Text("Photo"),
                                    Text("UserType"),
                                    Text("Wealth"),
                                    Text("Charm"),
                                    Text("Vip"),
                                  ]
                                ),
                                TableRow(
                                  children: [
                                    Text(users[index].doc,style: TextStyle(color: Colors.red),),
                                    Text(users[index].userId,style: TextStyle(color: Colors.green),),
                                    Text(users[index].userName),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(image: NetworkImage(
                                              users[index].image.toString()
                                          ),)
                                      ),
                                    ),
                                    Text(users[index].type),
                                    Text(users[index].lvl),
                                    Text(users[index].lvl2),
                                    Text(users[index].vip),
                                  ]
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    else{
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => UserDetailsView( userId: users[index].doc.toString(),)));
                        },
                        child: SizedBox(
                          height: 10,
                          child: Table(
                            children: [
                              TableRow(
                                  children: [
                                    Text(users[index].doc,style: TextStyle(color: Colors.red),),
                                    Text(users[index].userId,style: TextStyle(color: Colors.green),),
                                    Text(users[index].userName),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(image: NetworkImage(
                                              users[index].image.toString()
                                          ),)
                                      ),
                                    ),
                                    Text(users[index].type),
                                    Text(users[index].lvl),
                                    Text(users[index].lvl2),
                                    Text(users[index].vip),
                                  ]
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

}