class DataBaseEntity {
  String? name;
  String? version;
  String? url;
  String? url2;
  DataBaseEntity({
    required this.name,
    required this.version,
    required this.url,
    required this.url2
  });
  DataBaseEntity.fromJson(Map<String,dynamic> json) {
    name = json["name"];
    version = json["version"];
    url = json["url"];
    url2 = json["url2"];
  }
}

