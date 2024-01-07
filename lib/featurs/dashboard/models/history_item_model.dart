class HistoryItemModel{
  final String date;
  final String email;
  final String photo;
  final String price;
  final String time;
  final String type;
  HistoryItemModel(
      {required this.date,
        required this.price,
        required this.type,
        required this.photo,
        required this.email,
        required this.time,
      }
      );
}