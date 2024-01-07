class StoreModel{
  String docID;
  String photo;
  String type;
  String price;
  String time;
  String cat;
  StoreModel(
      {required this.docID,
        required this.price,
        required this.type,
        required this.photo,
        required this.cat,
        required this.time,
      }
      );
}