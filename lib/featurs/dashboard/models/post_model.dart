class PostModel {
  final String postDay;
  final String postMonth;
  final String postYear;
  final String ownerName;
  final String postContent;
  final String postImage;
  final String postDoc;

  PostModel(
      {required this.postDay,
      required this.postMonth,
      required this.postYear,
      required this.ownerName,
      required this.postContent,
      required this.postImage
      , required this.postDoc});
}
