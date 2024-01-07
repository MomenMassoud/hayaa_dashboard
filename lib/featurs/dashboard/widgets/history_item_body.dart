import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/featurs/dashboard/models/history_item_model.dart';
import 'package:dashboard/featurs/dashboard/models/store_model.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HistoryItemBody extends StatefulWidget{
  StoreModel store;
  HistoryItemBody(this.store);
  _HistoryItemBody createState()=>_HistoryItemBody();
}


class _HistoryItemBody extends State<HistoryItemBody>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('store').doc(widget.store.docID).collection('history').snapshots(),
      builder: (context,snapshot){
        List<DataRow> rows = [];
        List<HistoryItemModel> history=[];
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
            HistoryItemModel(date: massege.get('date'), price: massege.get('price')
                , type: massege.get('type'), photo: massege.get('photo'), email: massege.get('email'),
                time: massege.get('time'))
          );
          DataRow row=DataRow(
              cells: [
                DataCell(Text("${massege.get('email')}",style: TextStyle(color: Colors.red),)),
                DataCell(Text("${massege.get('type')}",style: TextStyle(color: Colors.blue),)),
                DataCell(Text("${massege.get('price')}",style: TextStyle(color: Colors.green),)),
                DataCell(Text("${massege.get('photo')}",style: TextStyle(color: Colors.orange),)),
                DataCell(Text("${massege.get('date')}",style: TextStyle(color: Colors.green),)),
                DataCell(Text("${massege.get('time')}",style: TextStyle(color: Colors.blue),)),
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
                      child: Text("History Of Item"),
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
                          child: Text('Date',
                              style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.red)
                          ),
                        ),
                      )),
                      DataColumn(label: SizedBox(
                        height: screenHeight * 0.08,
                        child: Center(
                          child: Text('Time',
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
  Future<void> exportToExcel2(List<HistoryItemModel> rows) async {
    // Create Excel Workbook
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    CellValue email=TextCellValue("Email");
    CellValue id=TextCellValue("Type");
    CellValue name=TextCellValue("Price");
    CellValue date=TextCellValue("Photo");
    CellValue gift=TextCellValue("Date");
    CellValue photo=TextCellValue("Time");
    List<CellValue> head=[email,id,name,date,gift,photo,];
    sheet.appendRow(head);
    for(int i=0;i<rows.length;i++){
      CellValue email=TextCellValue(rows[i].email);
      CellValue id=TextCellValue(rows[i].type);
      CellValue name=TextCellValue(rows[i].price);
      CellValue date=TextCellValue(rows[i].photo);
      CellValue gift=TextCellValue(rows[i].date);
      CellValue photo=TextCellValue(rows[i].time);
      List<CellValue> head=[email,id,name,date,gift,photo,];
      sheet.appendRow(head);
    }
    excel.rename('existingSheetName', 'newSheetName');
    var fileBytes = excel.save(fileName: 'HistroyItemEdit.xlsx');
  }
}