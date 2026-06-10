import 'dart:convert';

class CountryListResponse {
  final bool success;
  final List<CountryData> data;

  CountryListResponse({
    required this.success,
    required this.data,
  });

  factory CountryListResponse.fromRawJson(String str) =>
      CountryListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryListResponse.fromJson(Map<String, dynamic> json) => CountryListResponse(
    success: json["success"] ?? false,
    data: json["data"] == null
        ? []
        : List<CountryData>.from(
      json["data"].map((x) => CountryData.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CountryData {
  final int id;
  final String name;

  CountryData({
    required this.id,
    required this.name,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}