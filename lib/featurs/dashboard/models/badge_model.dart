import 'package:flutter/material.dart';

class BadgeModel {
  final String count;
  final String Name;
  final String gift;
  final String id;
  final String photo;
  final String doc;
  final String giftphoto;
  final String created;
  final String date;
  BadgeModel(
      {required this.count,
        required this.id,
        required this.gift,
        required this.photo,
        required this.Name,
        required this.doc,
        required this.giftphoto,
        required this.created,
        required this.date,
      });
}
