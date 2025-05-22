class DeliveryTransactionResult {
  final String id;
  final String chassisNo;
  final String variant;
  final String? color;
  final int quantity;
  final int shiftNo;
  final DateTime createdAt;
  final bool isSynced;
  final String? status;

  DeliveryTransactionResult({
    required this.id,
    required this.chassisNo,
    required this.variant,
    this.color,
    required this.quantity,
    required this.shiftNo,
    required this.createdAt,
    required this.isSynced,
    this.status,
  });

  factory DeliveryTransactionResult.fromJson(Map<String, dynamic> json) {
    return DeliveryTransactionResult(
      id: json['id'] ?? '',
      chassisNo: json['chassisNo'] ?? '',
      variant: json['variant'] ?? '',
      color: json['color'],
      quantity: json['quantity'] ?? 0,
      shiftNo: json['shiftNo'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      isSynced: json['isSynced'] ?? false,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chassisNo': chassisNo,
      'variant': variant,
      'color': color,
      'quantity': quantity,
      'shiftNo': shiftNo,
      'createdAt': createdAt.toIso8601String(),
      'isSynced': isSynced,
      'status': status,
    };
  }
}
