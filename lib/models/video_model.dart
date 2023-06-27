class Video {
  late String id;
  late String title;
  late String description;
  late String url;
  late List<dynamic> country;
  late String date;
  late String views;
  late bool isVisible;
  late String userId;
  static const String tableName = 'favourite';

  Video();

  Video.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    url = map['url'];
    country = map['country'];
    date = map['date'];
    views = map['views'];
    isVisible = map['is_visible'];
    userId = map['user_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['url'] = url;
    map['country'] = country;
    map['date'] = date;
    map['views'] = views;
    map['is_visible'] = isVisible;
    map['user_id'] = userId;

    return map;
  }
}
