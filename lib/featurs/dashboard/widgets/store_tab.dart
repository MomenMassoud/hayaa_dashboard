import 'package:dashboard/featurs/dashboard/views/bubble_view.dart';
import 'package:dashboard/featurs/dashboard/views/car_view.dart';
import 'package:dashboard/featurs/dashboard/views/frame_view.dart';
import 'package:dashboard/featurs/dashboard/views/wallpaper_view.dart';
import 'package:dashboard/featurs/details_screen/view/add_new_store_view.dart';
import 'package:flutter/material.dart';


class StoreDetailsBody extends StatefulWidget{
  _StoreDetailsBody createState()=>_StoreDetailsBody();
}

class _StoreDetailsBody extends State<StoreDetailsBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNewStoreView()));
          }, child: Text("Add New Item"))
        ],
        backgroundColor: Colors.white,
        leading: Text("Store Details",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green),),
        leadingWidth: 190,
        elevation: 0.0,
        bottom:TabBar(
          controller: _tabController,
          labelPadding: EdgeInsets.only(right: 45.0),
          unselectedLabelColor: Color(0xFFCDCDCD),
          indicatorColor: Colors.transparent,
          labelColor: Color(0xFFC88D67),
          tabs: [
            Tab(
              child: Text("Car"),
            ),
            Tab(
              child: Text("Frame"),
            ),
            Tab(
              child: Text("Bubble"),
            ),
            Tab(
              child: Text("Wallpaper"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
          children: <Widget>[
            CarView(),
            FrameView(),
            BubbleView(),
            WallpaperView(),
          ]
      ),
    );
  }

}