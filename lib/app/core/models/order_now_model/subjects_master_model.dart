import 'dart:convert';

class SubjectsResponse {
  final bool success;
  final List<SubjectData> data;

  SubjectsResponse({
    required this.success,
    required this.data,
  });

  factory SubjectsResponse.fromRawJson(String str) =>
      SubjectsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubjectsResponse.fromJson(Map<String, dynamic> json) => SubjectsResponse(
    success: json["success"] ?? false,
    data: json["data"] == null
        ? []
        : List<SubjectData>.from(
      json["data"].map((x) => SubjectData.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SubjectData {
  final int id;
  final String name;
  final String value;

  SubjectData({
    required this.id,
    required this.name,
    required this.value,
  });

  factory SubjectData.fromJson(Map<String, dynamic> json) => SubjectData(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    value: json["value"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "value": value,
  };
}