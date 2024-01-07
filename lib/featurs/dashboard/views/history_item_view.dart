import 'package:dashboard/featurs/dashboard/models/store_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/history_item_body.dart';
import 'package:flutter/material.dart';

class HistoryItemView extends StatefulWidget{
  StoreModel store;
  HistoryItemView(this.store);
  _HistoryItemView createState()=>_HistoryItemView();
}

class _HistoryItemView extends State<HistoryItemView>{
  @override
  Widget build(BuildContext context) {
    return HistoryItemBody(widget.store);
  }

}