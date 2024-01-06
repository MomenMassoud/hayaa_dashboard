import 'package:flutter/material.dart';

class UserModel {
  final String userId;
  final String userName;
  final String coins;
  final String diamonds;
  final String lvl;
  final String lvl2;
  final String vip;
  final String type;
  final String doc;
  final String? bio;
  final String? image;
  final String? country;
  final String? phoneNum;
  final String? gender;
  final String? device;
  final String? vipDead;
  final String? userCountry;
  UserModel(
      {required this.userId,
      required this.userName,
      required this.coins,
      required this.diamonds,
      required this.lvl,
      required this.lvl2,
      required this.type,
      required this.vip,
      required this.doc,
      @required this.bio,
      @required this.image,
      @required this.country,
      @required this.phoneNum,
        @required this.gender,
        @required this.device,
        @required this.vipDead,
        @required this.userCountry,
      });
}
