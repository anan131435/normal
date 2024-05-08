class DataBaseEntity {
  String name;
  String release;
  String URL;
  DataBaseEntity({
    this.name,
    this.release,
    this.URL,
  });
  DataBaseEntity.fromJson(Map<String,dynamic> json) {
    name = json["name"];
    release = json["release"];
    URL = json["URL"];
  }
}

