class TrimmingOnSummaryResult {
  final String cabin;
  final String color;
  final int quantity;

  TrimmingOnSummaryResult({
    required this.cabin,
    required this.color,
    required this.quantity,
  });

  factory TrimmingOnSummaryResult.fromJson(Map<String, dynamic> json) {
    return TrimmingOnSummaryResult(
      cabin: json['cabin'] ?? '',
      color: json['color'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cabin': cabin,
      'color': color,
      'quantity': quantity,
    };
  }
}
