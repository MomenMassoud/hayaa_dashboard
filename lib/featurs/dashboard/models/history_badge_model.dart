class HistoryBadgeModel{
  final String email;
  final String date;
  final String name;
  final String gift;
  final String target;
  final String photo;
  final String id;
  HistoryBadgeModel(
      {required this.email,
        required this.id,
        required this.gift,
        required this.photo,
        required this.name,
        required this.target,
        required this.date,
      }
      );
}