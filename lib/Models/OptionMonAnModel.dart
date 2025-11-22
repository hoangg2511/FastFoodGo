class OptionMonAnModel {
  final String id;
  final String ten;
  final int gia;
  final List<LoaiOptionModel> maLoaiOptions;
  OptionMonAnModel({
    this.id ="",
    this.ten = "",
    this.gia = 0,
    List<LoaiOptionModel>? maLoaiOptions,
  }) : maLoaiOptions = maLoaiOptions ?? [];

  Map<String, dynamic> toJson() {
    return {
      "maOption": id,
      "tenOption": ten,
      "gia":gia,
      "maLoaiOptions": maLoaiOptions.map((loai) => loai.toJson()).toList(),
    };
  }

  factory OptionMonAnModel.fromJson(Map<String, dynamic> json) {
    return OptionMonAnModel(
      id: json["maOption"] ?? "",
      ten: json["tenOption"] ?? "",
      gia : (json["gia"] is int)
          ? json["gia"]
          : (json["gia"] is double)
          ? (json["gia"] as double).toInt()
          : 0,
      maLoaiOptions: (json["maLoaiOptions"] as List<dynamic>?)
          ?.map((loai) => LoaiOptionModel.fromJson(loai as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

}

class LoaiOptionModel {
  final String id;
  final String ten;
  LoaiOptionModel({
    this.id ="",
    this.ten = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "maLoaiOption": id,
      "tenLoaiOption": ten,
    };
  }

  factory LoaiOptionModel.fromJson(Map<String, dynamic> json) {
    return LoaiOptionModel(
        id:json["maLoaiOption"] ?? "",
        ten: json["tenLoaiOption"] ?? "",
    );
  }

}
