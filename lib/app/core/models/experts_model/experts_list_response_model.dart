class ExpertListResponseModel {
  final bool? success;
  final List<ExpertData>? data;

  const ExpertListResponseModel({
    this.success,
    this.data,
  });

  factory ExpertListResponseModel.fromJson(Map<String, dynamic> json) {
    return ExpertListResponseModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExpertData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class ExpertData {
  final int? id;
  final String? name;
  final String? content;
  final String? description;
  final int? finishOrder;
  final int? inprogressOrder;
  final String? image;
  final String? subject;
  final String? service;
  final String? createdAt;
  final String? updatedAt;
  final String? location;
  final List<String>? skills;
  final List<String>? helpus;
  final List<CustomerReview>? customerReview;
  final String? slug;
  final int? successRate;
  final String? metaTag;
  final String? metaDescription;
  final String? images;

  const ExpertData({
    this.id,
    this.name,
    this.content,
    this.description,
    this.finishOrder,
    this.inprogressOrder,
    this.image,
    this.subject,
    this.service,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.skills,
    this.helpus,
    this.customerReview,
    this.slug,
    this.successRate,
    this.metaTag,
    this.metaDescription,
    this.images,
  });

  factory ExpertData.fromJson(Map<String, dynamic> json) {
    return ExpertData(
      id: json['id'] as int?,
      name: json['name'] as String?,
      content: json['content'] as String?,
      description: json['description'] as String?,
      finishOrder: json['finish_order'] as int?,
      inprogressOrder: json['inprogress_order'] as int?,
      image: json['image'] as String?,
      subject: json['subject'] as String?,
      service: json['service'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      location: json['location'] as String?,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      helpus: (json['helpus'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      customerReview: (json['customer_review'] as List<dynamic>?)
          ?.map((e) => CustomerReview.fromJson(e as Map<String, dynamic>))
          .toList(),
      slug: json['slug'] as String?,
      successRate: json['success'] as int?,
      metaTag: json['meta_tag'] as String?,
      metaDescription: json['meta_description'] as String?,
      images: json['images'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'finish_order': finishOrder,
      'inprogress_order': inprogressOrder,
      'image': image,
      'subject': subject,
      'service': service,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'location': location,
      'skills': skills,
      'helpus': helpus,
      'customer_review': customerReview?.map((e) => e.toJson()).toList(),
      'slug': slug,
      'success': successRate,
      'meta_tag': metaTag,
      'meta_description': metaDescription,
      'images': images,
    };
  }
}

class CustomerReview {
  final String? name;
  final int? rating;
  final String? review;

  const CustomerReview({
    this.name,
    this.rating,
    this.review,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] as String?,
      rating: json['rating'] as int?,
      review: json['review'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'review': review,
    };
  }
}