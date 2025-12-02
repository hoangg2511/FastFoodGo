class LoaiMonAnModel{
  final String Ten;
  final String id;

  LoaiMonAnModel({
    this.id = "",
    this.Ten = "",
  });


  Map<String, dynamic> toJson() {
    return {
      "uid": id,
      "Ten": Ten,
    };
  }

  factory LoaiMonAnModel.fromJson(Map<String, dynamic> json) {
    return LoaiMonAnModel(
      id: json["maLoai"] ?? "",
      Ten: json["tenLoai"] ?? "",
    );
  }

}