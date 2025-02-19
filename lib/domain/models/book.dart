class Book {
  String title;
  String author;
  String genre;
  DateTime publishingDate;
  String image;
  DateTime createdAt;

  Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.publishingDate,
    required this.image,
    required this.createdAt,
  });

  //Add factories here

  factory Book.fromFetchJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      genre: json['genre'],
      publishingDate: DateTime.parse(json['publishingDate']),
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'genre': genre,
      'publishingDate': publishingDate.toLocal(),
      'image': image,
      'createdAt': createdAt.toLocal(),
    };
  }
}
