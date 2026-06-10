import 'dart:convert';

class UrgencyListResponse {
  final bool success;
  final List<UrgencyData> data;

  UrgencyListResponse({
    required this.success,
    required this.data,
  });

  factory UrgencyListResponse.fromRawJson(String str) =>
      UrgencyListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UrgencyListResponse.fromJson(Map<String, dynamic> json) => UrgencyListResponse(
    success: json["success"] ?? false,
    data: json["data"] == null
        ? []
        : List<UrgencyData>.from(
      json["data"].map((x) => UrgencyData.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UrgencyData {
  final int id;
  final String name;
  final String value;
  final double multiplier;

  UrgencyData({
    required this.id,
    required this.name,
    required this.value,
    required this.multiplier,
  });

  factory UrgencyData.fromJson(Map<String, dynamic> json) => UrgencyData(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    value: json["value"] ?? '',
    multiplier: (json["multiplier"] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "value": value,
    "multiplier": multiplier,
  };
}