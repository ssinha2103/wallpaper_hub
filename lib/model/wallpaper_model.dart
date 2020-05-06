class WallPaperModel {
  String photographer;
  String photographer_url;
  int photographer_id;
  SrcModel src;

  WallPaperModel(
      {this.photographer,
      this.photographer_url,
      this.photographer_id,
      this.src});

  factory WallPaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallPaperModel(
      src: SrcModel.fromMap(jsonData["src"]),
      photographer_url: jsonData["photographer_url"],
      photographer_id: jsonData["photographer_id"],
      photographer: jsonData["photographer"],
    );
  }
}

class SrcModel {
  String original;
  String small;
  String portrait;

  SrcModel({this.original, this.small, this.portrait});

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      original: jsonData["original"],
      small: jsonData["small"],
      portrait: jsonData["portrait"],
    );
  }
}
