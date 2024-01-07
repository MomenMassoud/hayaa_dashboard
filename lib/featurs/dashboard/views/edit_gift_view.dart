import 'package:dashboard/featurs/dashboard/models/gift_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/edit_gift_body.dart';
import 'package:flutter/material.dart';


class EditGiftView extends StatefulWidget{
  GiftModel gift;
  EditGiftView(this.gift);
  _EditGiftView createState()=>_EditGiftView();
}

class _EditGiftView extends State<EditGiftView>{
  @override
  Widget build(BuildContext context) {
    return EditGiftBody(widget.gift);
  }

}