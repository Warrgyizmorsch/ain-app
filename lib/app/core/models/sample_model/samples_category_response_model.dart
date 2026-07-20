
class SamplesCategoryResponseModel {
  final bool success;
  final List<SampleCategory>? data;

  SamplesCategoryResponseModel({
    required this.success,
    this.data,
  });

  factory SamplesCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return SamplesCategoryResponseModel(
      success: json['success'],
      data: json['data'] != null
          ? List<SampleCategory>.from(
          json['data'].map((x) => SampleCategory.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data != null
          ? List<dynamic>.from(data!.map((x) => x.toJson()))
          : null,
    };
  }
}

class SampleCategory {
  final int? id;
  final String? name;
  final int? sampleCount;

  SampleCategory({
    this.id,
    this.name,
    this.sampleCount,
  });

  factory SampleCategory.fromJson(Map<String, dynamic> json) {
    return SampleCategory(
      id: json['id'],
      name: json['name'],
      sampleCount: json['sample_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sample_count': sampleCount,
    };
  }
}