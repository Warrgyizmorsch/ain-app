class SampleResponseModel {
  final bool success;
  final SampleData data;

  SampleResponseModel({
    required this.success,
    required this.data,
  });

  factory SampleResponseModel.fromJson(Map<String, dynamic> json) {
    return SampleResponseModel(
      success: json['success'] ?? false,
      data: SampleData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class SampleData {
  final int currentPage;
  final List<SampleItem> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  SampleData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory SampleData.fromJson(Map<String, dynamic> json) {
    return SampleData(
      currentPage: json['current_page'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SampleItem.fromJson(e))
          .toList() ??
          [],
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      lastPageUrl: json['last_page_url'] ?? '',
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => PageLink.fromJson(e))
          .toList() ??
          [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 0,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class SampleItem {
  final int id;
  final String title;
  final String slug;
  final int categoryId;
  final String categoryName;
  final int typeId;
  final String typeName;
  final String metaTitle;
  final String metaDescription;
  final String createdAt;

  SampleItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.categoryId,
    required this.categoryName,
    required this.typeId,
    required this.typeName,
    required this.metaTitle,
    required this.metaDescription,
    required this.createdAt,
  });

  factory SampleItem.fromJson(Map<String, dynamic> json) {
    return SampleItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      typeId: json['type_id'] ?? 0,
      typeName: json['type_name'] ?? '',
      metaTitle: json['meta_title'] ?? '',
      metaDescription: json['meta_description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'category_id': categoryId,
      'category_name': categoryName,
      'type_id': typeId,
      'type_name': typeName,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'created_at': createdAt,
    };
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    required this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}