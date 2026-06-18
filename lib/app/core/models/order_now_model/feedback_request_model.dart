class FeedbackRequest {
  final String orderId;
  final String experience;
  final String feedbackScope;
  final String yourSuggestion;

  FeedbackRequest({
    required this.orderId,
    required this.experience,
    required this.feedbackScope,
    required this.yourSuggestion,
  });

  Map<String, dynamic> toJson() {
    return {
      "order_id": orderId,
      "experience": experience,
      "feedback_scope": feedbackScope,
      "your_suggestion": yourSuggestion,
    };
  }
}