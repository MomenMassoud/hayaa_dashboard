import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/gift_history_model.dart';
import 'package:dashboard/featurs/dashboard/models/gift_model.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryGiftBody extends StatefulWidget{
  final GiftModel gift;
  HistoryGiftBody(this.gift);
  _HistoryGiftBody createState()=>_HistoryGiftBody();
}

class _HistoryGiftBody extends State<HistoryGiftBody>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('gifts').doc(widget.gift.giftDoc).collection('history').snapshots(),
      builder: (context,snapshot){
        List<DataRow> rows = [];
        List<HistoryGiftModel> history=[];
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
            HistoryGiftModel(email: massege.get('email'), type: massege.get('type'),
                price: massege.get('price'), photo: massege.get('photo'),
                name: massege.get('name'), date: massege.get('date'),allow: massege.get('allow'))
          );

          DataRow row=DataRow(
              cells: [
                DataCell(Text("${massege.get('email')}",style: TextStyle(color: Colors.red),)),
                DataCell(Text("${massege.get('type')}",style: TextStyle(color: Colors.blue),)),
                DataCell(Text("${massege.get('price')}",style: TextStyle(color: Colors.green),)),
                DataCell(Text("${massege.get('photo')}",style: TextStyle(color: Colors.orange),)),
                DataCell(Text("${massege.get('name')}",style: TextStyle(color: Colors.red),),),
                DataCell(Text("${massege.get('date')}",style: TextStyle(color: Colors.green),)),
                DataCell(Text("${massege.get('allow')}",style: TextStyle(color: Colors.blue),)),
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
                      child: Text("History Of Gift"),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                          child: Text('Type',
                              style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.blue)
                          ),
                        ),
                      )),
                      DataColumn(label: SizedBox(
                        height: screenHeight * 0.08,
                        child: Center(
                          child: Text('Price',
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
                          child: Text('Date',
                              style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.green)
                          ),
                        ),
                      )),
                      DataColumn(label: SizedBox(
                        height: screenHeight * 0.08,
                        child: Center(
                          child: Text('Active',
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
              )
            ],
          ),
        );
      },
    );
  }
  Future<void> exportToExcel2(List<HistoryGiftModel> rows) async {
    // Create Excel Workbook
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    CellValue email=TextCellValue("Email");
    CellValue id=TextCellValue("Type");
    CellValue name=TextCellValue("Price");
    CellValue date=TextCellValue("Photo");
    CellValue gift=TextCellValue("Name");
    CellValue photo=TextCellValue("Date");
    CellValue Active=TextCellValue("Active");
    List<CellValue> head=[email,id,name,date,gift,photo,Active];
    sheet.appendRow(head);
    for(int i=0;i<rows.length;i++){
      CellValue email=TextCellValue(rows[i].email);
      CellValue id=TextCellValue(rows[i].type);
      CellValue name=TextCellValue(rows[i].price);
      CellValue date=TextCellValue(rows[i].photo);
      CellValue gift=TextCellValue(rows[i].name);
      CellValue photo=TextCellValue(rows[i].date);
      CellValue Active=TextCellValue(rows[i].allow);
      List<CellValue> head=[email,id,name,date,gift,photo,Active];
      sheet.appendRow(head);
    }
    excel.rename('existingSheetName', 'newSheetName');
    var fileBytes = excel.save(fileName: 'HistroyGiftEdit.xlsx');
  }
}