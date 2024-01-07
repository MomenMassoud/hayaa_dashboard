import 'package:dashboard/featurs/dashboard/models/gift_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/history_gift_body.dart';
import 'package:flutter/material.dart';

class HistoryGiftView extends StatefulWidget{
  final GiftModel gift;
  HistoryGiftView(this.gift);
  _HistoryGiftView createState()=>_HistoryGiftView();
}

class _HistoryGiftView extends State<HistoryGiftView>{
  @override
  Widget build(BuildContext context) {
    return HistoryGiftBody(widget.gift);
  }

}