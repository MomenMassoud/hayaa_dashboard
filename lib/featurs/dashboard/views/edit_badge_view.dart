import 'package:dashboard/featurs/dashboard/models/badge_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/edit_badge_body.dart';
import 'package:flutter/material.dart';


class EditBadgeView extends StatefulWidget{
  BadgeModel badge;
  EditBadgeView(this.badge);
  _EditBadgeView createState()=>_EditBadgeView();
}


class _EditBadgeView extends State<EditBadgeView>{
  @override
  Widget build(BuildContext context) {
    return EditBadgeBody(widget.badge);
  }

}