import 'package:dashboard/featurs/dashboard/widgets/dash_board_view_body.dart';
import 'package:flutter/material.dart';

class DashBoardView extends StatelessWidget {
  const DashBoardView({super.key});
  static String id = 'DashBoardView';
  @override
  Widget build(BuildContext context) {
    List<Widget> myTabs = [
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Users'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Agencies'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Family'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Gifts'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Events'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Posts'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Rooms'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Add Staff'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Badges'),
        ),
      ),
      const RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Tab(text: 'Store'),
        ),
      ),
    ];
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: RotatedBox(
            quarterTurns: 1,
            child: TabBar(
              tabs: myTabs,
            ),
          ),
        ),
        body: const DashBoardViewBody(),
      ),
    );
  }
}
