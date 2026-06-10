import 'dart:convert';

class WordCountResponse {
  final bool success;
  final double basePricePerWord;
  final int discountPercentage;
  final List<WordCountData> data;

  WordCountResponse({
    required this.success,
    required this.basePricePerWord,
    required this.discountPercentage,
    required this.data,
  });

  factory WordCountResponse.fromRawJson(String str) =>
      WordCountResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WordCountResponse.fromJson(Map<String, dynamic> json) => WordCountResponse(
    success: json["success"] ?? false,
    basePricePerWord: (json["base_price_per_word"] as num?)?.toDouble() ?? 0.0,
    discountPercentage: json["discount_percentage"] ?? 0,
    data: json["data"] == null
        ? []
        : List<WordCountData>.from(
      json["data"].map((x) => WordCountData.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "base_price_per_word": basePricePerWord,
    "discount_percentage": discountPercentage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class WordCountData {
  final int id;
  final String name;
  final int value;
  final double multiplier;

  WordCountData({
    required this.id,
    required this.name,
    required this.value,
    required this.multiplier,
  });

  factory WordCountData.fromJson(Map<String, dynamic> json) => WordCountData(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    value: json["value"] ?? 0,
    multiplier: (json["multiplier"] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "value": value,
    "multiplier": multiplier,
  };
}