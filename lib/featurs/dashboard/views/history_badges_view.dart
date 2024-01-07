import 'package:dashboard/featurs/dashboard/models/badge_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/history_badges_body.dart';
import 'package:flutter/material.dart';

class HistoryBadgesView extends StatefulWidget{
  BadgeModel badge;
  HistoryBadgesView(this.badge);
  _HistoryBadgesView createState()=>_HistoryBadgesView();
}


class _HistoryBadgesView extends State<HistoryBadgesView>{
  @override
  Widget build(BuildContext context) {
    return HistoryBadgesBody(widget.badge);
  }

}