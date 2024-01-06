import 'package:dashboard/featurs/dashboard/views/badge_details_view.dart';
import 'package:dashboard/featurs/dashboard/widgets/agencies_tab.dart';
import 'package:dashboard/featurs/dashboard/widgets/family_tab.dart';
import 'package:dashboard/featurs/dashboard/widgets/user_tab.dart';
import 'package:flutter/material.dart';

import 'gifts_tab.dart';
import 'posts_tab.dart';

class DashBoardViewBody extends StatelessWidget {
  const DashBoardViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  TabBarView(
      children: [
        UsersTab(),
        AgenciesTab(),
        FamilyTab(),
        GiftsTab(),
        Center(child: Text('Tab 5 Content')),
        PostesTab(),
        Center(child: Text('Tab 7 Content')),
        Center(child: Text('Tab 8 Content')),
        BadgeDetailsView(),
      ],
    );
  }
}
