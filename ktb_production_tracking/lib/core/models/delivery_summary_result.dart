class DeliverySummaryResult {
  final String variant;
  final int quantity;

  DeliverySummaryResult({
    required this.variant,
    required this.quantity,
  });

  factory DeliverySummaryResult.fromJson(Map<String, dynamic> json) {
    return DeliverySummaryResult(
      variant: json['variant'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variant': variant,
      'quantity': quantity,
    };
  }
}
