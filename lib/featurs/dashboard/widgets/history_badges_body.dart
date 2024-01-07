import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/badge_model.dart';
import 'package:dashboard/featurs/dashboard/models/history_badge_send_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/history_badge_model.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class HistoryBadgesBody extends StatefulWidget{
  BadgeModel badge;
  HistoryBadgesBody(this.badge);
  _HistoryBadgesBody createState()=>_HistoryBadgesBody();
}


class _HistoryBadgesBody extends State<HistoryBadgesBody>{
  final FirebaseStorage _storage=FirebaseStorage.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  bool histroy=true;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: histroy?StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('badges').doc(widget.badge.doc).collection('history').snapshots(),
        builder: (context,snapshot){
          List<HistoryBadgeModel> history=[];
          List<DataRow> rows = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            history.add(
                HistoryBadgeModel(email: massege.get('email'),
                    id: massege.get('id'), gift: massege.get('gift'), photo: massege.get('photo'),
                    name: massege.get('name'), target: massege.get('target'), date: massege.get('date'))
            );
            DataRow row=DataRow(
                cells: [
                  DataCell(Text("${massege.get('email')}",style: TextStyle(color: Colors.red),)),
                  DataCell(Text("${massege.get('id')}",style: TextStyle(color: Colors.blue),)),
                  DataCell(Text("${massege.get('gift')}",style: TextStyle(color: Colors.green),)),
                  DataCell(Text("${massege.get('photo')}",style: TextStyle(color: Colors.orange),)),
                  DataCell(Text("${massege.get('name')}",style: TextStyle(color: Colors.red),),),
                  DataCell(Text("${massege.get('target')}",style: TextStyle(color: Colors.blue),)),
                  DataCell(Text("${massege.get('date')}",style: TextStyle(color: Colors.green),)),
                ]
            );

            rows.add(row);
          }
          return Padding(
              padding: const EdgeInsets.all(58),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("History Of Badge"),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(" History of Badge : ${history.length.toString()}"),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                histroy = true;
                              });
                            },
                            child: const Text("History Edit")),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                histroy = false;
                              });
                            },
                            child: const Text("History Send")),
                      ],
                    ),
                    DataTable(
                      columnSpacing: 55.0,
                      sortAscending: true,
                      showBottomBorder: true,
                      horizontalMargin: 12.0,
                      dividerThickness: 2.0,
                      border: TableBorder.all(),
                      columns: [
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Email',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.red)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('ID',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.blue)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Gift',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.green)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Photo',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.orange)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Name',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.red)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Target',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.blue)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Date',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.green)
                            ),
                          ),
                        )),
                      ],
                      rows: rows,
                    ),
                    SizedBox(height: 40,),
                    ElevatedButton(onPressed: (){
                      exportToExcel2(history);
                    }, child: Text("Download Sheet Excel"))
                  ],
                ),
              ],
            ),
          );
        },
      ):StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('badges').doc(widget.badge.doc).collection('send').snapshots(),
        builder: (context,snapshot){
          List<HistroyBadgeSendModel> history=[];
          List<DataRow> rows = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            history.add(
               HistroyBadgeSendModel(email: massege.get('email'),
                   id: massege.get('id'), name: massege.get('name'), date: massege.get('date'))
            );
            DataRow row=DataRow(
                cells: [
                  DataCell(Text("${massege.get('email')}",style: TextStyle(color: Colors.red),)),
                  DataCell(Text("${massege.get('id')}",style: TextStyle(color: Colors.blue),)),
                  DataCell(Text("${massege.get('name')}",style: TextStyle(color: Colors.red),),),
                  DataCell(Text("${massege.get('date')}",style: TextStyle(color: Colors.green),)),
                ]
            );

            rows.add(row);
          }
          return Padding(
            padding: const EdgeInsets.all(58),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("History Of Badge Send"),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(" History of Badge Send: ${history.length.toString()}"),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                histroy = true;
                              });
                            },
                            child: const Text("History Edit")),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                histroy = false;
                              });
                            },
                            child: const Text("History Send")),
                      ],
                    ),
                    DataTable(
                      columnSpacing: 55.0,
                      sortAscending: true,
                      showBottomBorder: true,
                      horizontalMargin: 12.0,
                      dividerThickness: 2.0,
                      border: TableBorder.all(),
                      columns: [
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Email',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.red)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('ID',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.blue)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Name',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.red)
                            ),
                          ),
                        )),
                        DataColumn(label: SizedBox(
                          height: screenHeight * 0.08,
                          child: Center(
                            child: Text('Date',
                                style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.green)
                            ),
                          ),
                        )),
                      ],
                      rows: rows,
                    ),
                    SizedBox(height: 70,),
                    ElevatedButton(
                        onPressed: (){
                          exportToExcel(history);
                        },
                        child: Text("Download Sheet Excel"))
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Future<void> exportToExcel(List<HistroyBadgeSendModel> rows) async {
    // Create Excel Workbook
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    CellValue email=TextCellValue("Email");
    CellValue id=TextCellValue("ID");
    CellValue name=TextCellValue("Name");
    CellValue date=TextCellValue("Date");
    List<CellValue> head=[email,id,name,date];
    sheet.appendRow(head);
    for(int i=0;i<rows.length;i++){
      CellValue email=TextCellValue(rows[i].email);
      CellValue id=TextCellValue(rows[i].id);
      CellValue name=TextCellValue(rows[i].name);
      CellValue date=TextCellValue(rows[i].date);
      List<CellValue> head=[email,id,name,date];
      sheet.appendRow(head);
    }
    excel.rename('existingSheetName', 'newSheetName');
    var fileBytes = excel.save(fileName: 'HistroyBadgeSend.xlsx');
  }
  Future<void> exportToExcel2(List<HistoryBadgeModel> rows) async {
    // Create Excel Workbook
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    CellValue email=TextCellValue("Email");
    CellValue id=TextCellValue("ID");
    CellValue name=TextCellValue("Name");
    CellValue date=TextCellValue("Date");
    CellValue gift=TextCellValue("Gift");
    CellValue photo=TextCellValue("Photo");
    CellValue target=TextCellValue("Target");
    List<CellValue> head=[email,id,name,date,gift,photo,target];
    sheet.appendRow(head);
    for(int i=0;i<rows.length;i++){
      CellValue email=TextCellValue(rows[i].email);
      CellValue id=TextCellValue(rows[i].id);
      CellValue name=TextCellValue(rows[i].name);
      CellValue date=TextCellValue(rows[i].date);
      CellValue gift=TextCellValue(rows[i].gift);
      CellValue photo=TextCellValue(rows[i].photo);
      CellValue target=TextCellValue(rows[i].target);
      List<CellValue> head=[email,id,name,date,gift,photo,target];
      sheet.appendRow(head);
    }
    excel.rename('existingSheetName', 'newSheetName');
    var fileBytes = excel.save(fileName: 'HistroyBadgeEdit.xlsx');
  }
}