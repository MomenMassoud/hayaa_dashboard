import 'package:dashboard/featurs/dashboard/models/store_model.dart';
import 'package:dashboard/featurs/dashboard/widgets/edit_store_body.dart';
import 'package:flutter/material.dart';


class EditStorView extends StatefulWidget{
  StoreModel store;
  EditStorView(this.store);
  _EditStoreView createState()=>_EditStoreView();
}


class _EditStoreView extends State<EditStorView>{
  @override
  Widget build(BuildContext context) {
    return EditStorBody(widget.store);
  }

}