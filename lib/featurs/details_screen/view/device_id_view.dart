import 'package:dashboard/featurs/details_screen/widget/device_id_body.dart';
import 'package:flutter/material.dart';


class DeviceIDView extends StatefulWidget{
  String deviceID;
  DeviceIDView(this.deviceID);
  _DeviceIDView createState()=>_DeviceIDView();
}


class _DeviceIDView extends State<DeviceIDView>{
  @override
  Widget build(BuildContext context) {
    return DeviceIDBody(widget.deviceID);
  }

}