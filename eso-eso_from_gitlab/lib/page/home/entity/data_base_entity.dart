class DataBaseEntity {
  String name;
  String version;
  String contentVersion;
  String url;
  String url2;
  DataBaseEntity({
    this.name,
    this.version,
    this.contentVersion,
    this.url,
    this.url2
  });
  DataBaseEntity.fromJson(Map<String,dynamic> json) {
    name = json["name"];
    version = json["version"];
    contentVersion = json["contentVersion"];
    url = json["url"];
    url2 = json["url2"];
  }
}

