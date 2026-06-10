class ServicesOrderNowModel {
  final bool success;
  final List<GetServiceModel> data;

  ServicesOrderNowModel({
    required this.success,
    required this.data,
  });

  factory ServicesOrderNowModel.fromJson(Map<String, dynamic> json) {
    return ServicesOrderNowModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<GetServiceModel>.from(json['data'].map((x) => GetServiceModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class GetServiceModel {
  final int id;
  final String name;
  final String value;
  final double multiplier;

  GetServiceModel({
    required this.id,
    required this.name,
    required this.value,
    required this.multiplier,
  });

  factory GetServiceModel.fromJson(Map<String, dynamic> json) {
    return GetServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      // Ensure the multiplier is parsed securely as a double
      multiplier: (json['multiplier'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'multiplier': multiplier,
    };
  }
}