class HistoryGiftModel{
  final String email;
  final String date;
  final String name;
  final String price;
  final String type;
  final String photo;
  final String allow;
  HistoryGiftModel(
      {required this.email,
        required this.type,
        required this.price,
        required this.photo,
        required this.name,
        required this.date,
        required this.allow,
      }
      );
}