import 'package:flutter/material.dart';

class AgencyModel {
  final String agencyId;
  final String agencyName;
  final String ownerEmail;
  final String agencyDoc;
  final String agencyCountry;
  final String agencyBio;
  final String agencyImage;
  final String? doc;



  AgencyModel(
      {required this.agencyId,
      required this.agencyName,
      required this.ownerEmail,
      required this.agencyDoc,
      required this.agencyCountry,
      required this.agencyBio ,
      required this.agencyImage, 
      @required this.doc
      });
}
