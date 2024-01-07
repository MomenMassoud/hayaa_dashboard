import 'package:dashboard/featurs/dashboard/models/badge_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/send_badge_toUser_body.dart';
import 'package:flutter/material.dart';

class SendBadgeToUserView extends StatefulWidget{
  BadgeModel badge;
  SendBadgeToUserView(this.badge);
  _SendBadgeToUserView createState()=>_SendBadgeToUserView();
}


class _SendBadgeToUserView extends State<SendBadgeToUserView>{
  @override
  Widget build(BuildContext context) {
    return SendBadgeToUserBody(widget.badge);
  }

}