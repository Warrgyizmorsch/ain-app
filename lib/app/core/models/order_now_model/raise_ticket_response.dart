class RaiseTicketResponse {
  final bool? success;
  final String? message;
  final TicketData? data;

  RaiseTicketResponse({
    this.success,
    this.message,
    this.data,
  });

  factory RaiseTicketResponse.fromJson(Map<String, dynamic> json) {
    return RaiseTicketResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? TicketData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class TicketData {
  final int? feedbackId;
  final String? feedbackTicket;
  final String? statusIssue;
  final String? comment;
  final String? createdAt;

  TicketData({
    this.feedbackId,
    this.feedbackTicket,
    this.statusIssue,
    this.comment,
    this.createdAt,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      feedbackId: json['feedback_id'],
      feedbackTicket: json['feedback_ticket'],
      statusIssue: json['status_issue'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_id': feedbackId,
      'feedback_ticket': feedbackTicket,
      'status_issue': statusIssue,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}