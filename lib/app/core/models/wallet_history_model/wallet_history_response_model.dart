class TransactionResponseModel {
  final bool success;
  final TransactionData data;

  TransactionResponseModel({
    required this.success,
    required this.data,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      success: json["success"] ?? false,
      data: TransactionData.fromJson(
        json["data"] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data.toJson(),
    };
  }
}

class TransactionData {
  final List<Transaction> transactions;
  final Pagination pagination;

  TransactionData({
    required this.transactions,
    required this.pagination,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      transactions: json["transactions"] != null
          ? List<Transaction>.from(
          json["transactions"].map((x) => Transaction.fromJson(x ?? {})))
          : [],
      pagination: Pagination.fromJson(
        json["pagination"] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "transactions": transactions.map((x) => x.toJson()).toList(),
      "pagination": pagination.toJson(),
    };
  }
}

class Transaction {
  final int id;
  final num amount;
  final String type;
  final String description;
  final bool isExpired;
  final String expiresAt;
  final String createdAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.isExpired,
    required this.expiresAt,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"] ?? 0,
      amount: json["amount"] ?? 0,
      type: json["type"] ?? "",
      description: json["description"] ?? "",
      isExpired: json["is_expired"] ?? false,
      expiresAt: json["expires_at"] ?? "",
      createdAt: json["created_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "type": type,
      "description": description,
      "is_expired": isExpired,
      "expires_at": expiresAt,
      "created_at": createdAt,
    };
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMore;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json["current_page"] ?? 0,
      lastPage: json["last_page"] ?? 0,
      perPage: json["per_page"] ?? 0,
      total: json["total"] ?? 0,
      hasMore: json["has_more"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "current_page": currentPage,
      "last_page": lastPage,
      "per_page": perPage,
      "total": total,
      "has_more": hasMore,
    };
  }
}