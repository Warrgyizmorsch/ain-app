class SampleDetailResponseModel {
  final bool success;
  final SampleDetailData? data;

  SampleDetailResponseModel({
    required this.success,
    this.data,
  });

  factory SampleDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return SampleDetailResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? SampleDetailData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class SampleDetailData {
  final int id;
  final int category;
  final String content;
  final String description;
  final String updatedAt;
  final String createdAt;
  final String title;
  final String slug;
  final int typeId;
  final String metaTitle;
  final String metaDescription;
  final String categoryName;
  final String typeName;
  final CategoryData? categoryData;
  final TypeData? type;

  SampleDetailData({
    required this.id,
    required this.category,
    required this.content,
    required this.description,
    required this.updatedAt,
    required this.createdAt,
    required this.title,
    required this.slug,
    required this.typeId,
    required this.metaTitle,
    required this.metaDescription,
    required this.categoryName,
    required this.typeName,
    this.categoryData,
    this.type,
  });

  factory SampleDetailData.fromJson(Map<String, dynamic> json) {
    return SampleDetailData(
      id: json['id'] ?? 0,
      category: json['category'] ?? 0,
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      typeId: json['type_id'] ?? 0,
      metaTitle: json['meta_title'] ?? '',
      metaDescription: json['meta_description'] ?? '',
      categoryName: json['category_name'] ?? '',
      typeName: json['type_name'] ?? '',
      // Note: Kept the exact key 'categoty_data' from your JSON
      categoryData: json['categoty_data'] != null
          ? CategoryData.fromJson(json['categoty_data'])
          : null,
      type: json['type'] != null
          ? TypeData.fromJson(json['type'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'content': content,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'title': title,
      'slug': slug,
      'type_id': typeId,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'category_name': categoryName,
      'type_name': typeName,
      'categoty_data': categoryData?.toJson(),
      'type': type?.toJson(),
    };
  }
}

class CategoryData {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  CategoryData({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class TypeData {
  final int id;
  final String name;
  final String updatedAt;
  final String createdAt;

  TypeData({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
  });

  factory TypeData.fromJson(Map<String, dynamic> json) {
    return TypeData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'updated_at': updatedAt,
      'created_at': createdAt,
    };
  }
}