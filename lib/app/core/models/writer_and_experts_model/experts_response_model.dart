
class ExpertListResponseModel {
  bool? success;
  List<ExpertData>? data; // THIS is now a List, which fixes your error!

  ExpertListResponseModel({this.success, this.data});

  factory ExpertListResponseModel.fromJson(Map<String, dynamic> json) {
    return ExpertListResponseModel(
      success: json['success'],
      data: json['data'] != null
          ? List<ExpertData>.from(json['data'].map((x) => ExpertData.fromJson(x)))
          : null,
    );
  }
}

class ExpertData {
  int? id;
  String? name;
  String? content;
  int? finishOrder;
  int? inprogressOrder;
  String? image;
  String? subject;
  String? service;
  String? createdAt;
  String? updatedAt;
  String? location;
  List<String>? skills;
  List<String>? helpus;
  List<CustomerReview>? customerReview;
  String? slug;
  int? successRate;
  String? metaTag;
  String? metaDescription;
  String? images;

  ExpertData({
    this.id,
    this.name,
    this.content,
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
      id: json['id'],
      name: json['name'],
      content: json['content'],
      finishOrder: json['finish_order'],
      inprogressOrder: json['inprogress_order'],
      image: json['image'],
      subject: json['subject'],
      service: json['service'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      location: json['location'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      helpus: json['helpus'] != null ? List<String>.from(json['helpus']) : null,
      customerReview: json['customer_review'] != null
          ? List<CustomerReview>.from(
          json['customer_review'].map((v) => CustomerReview.fromJson(v)))
          : null,
      slug: json['slug'],
      successRate: json['success'], // Maps the integer 'success' key to successRate
      metaTag: json['meta_tag'],
      metaDescription: json['meta_description'],
      images: json['images'],
    );
  }


}

class CustomerReview {
  String? name;
  int? rating;
  String? review;

  CustomerReview({this.name, this.rating, this.review});

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      rating: json['rating'],
      review: json['review'],
    );
  }


}