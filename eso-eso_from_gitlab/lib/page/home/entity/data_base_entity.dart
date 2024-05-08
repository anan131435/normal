class DataBaseEntity {
  String name;
  String version;
  String url;
  DataBaseEntity({
    this.name,
    this.version,
    this.url,
  });
  DataBaseEntity.fromJson(Map<String,dynamic> json) {
    name = json["name"];
    version = json["version"];
    url = json["url"];
  }
}

