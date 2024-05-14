class ChapterItem {
  String contentUrl = "";
  String cover = "";
  String name = "";
  String time = "";
  String url = "";

  ChapterItem({
    required this.contentUrl,
    required this.cover,
    required this.name,
    required this.time,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
        "contentUrl": contentUrl,
        "cover": cover,
        "name": name,
        "time": time,
        "url": url,
      };

  ChapterItem.fromJson(Map<String, dynamic> json) {
    contentUrl = json["contentUrl"];
    cover = json["cover"];
    name = json["name"];
    time = json["time"];
    url = json["url"];
  }
}
