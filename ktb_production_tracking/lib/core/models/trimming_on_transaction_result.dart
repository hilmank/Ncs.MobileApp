class TrimmingOnTransactionResult {
  final String id;
  final String cabinNo;
  final String color;
  final DateTime productionDate;
  final int shiftNo;
  final String line;
  final String current;
  final String processId;
  final String? status;

  TrimmingOnTransactionResult({
    required this.id,
    required this.cabinNo,
    required this.color,
    required this.productionDate,
    required this.shiftNo,
    required this.line,
    required this.current,
    required this.processId,
    this.status,
  });

  factory TrimmingOnTransactionResult.fromJson(Map<String, dynamic> json) {
    return TrimmingOnTransactionResult(
      id: json['id']?.toString() ?? '',
      cabinNo: json['cabinNo']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      productionDate: DateTime.parse(json['productionDate']),
      shiftNo: json['shiftNo'] ?? 0,
      line: json['line']?.toString() ?? '',
      current: json['current']?.toString() ?? '',
      processId: json['processId']?.toString() ?? '',
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cabinNo': cabinNo,
      'productionDate': productionDate.toIso8601String(),
      'color': color,
      'shiftNo': shiftNo,
      'line': line,
      'current': current,
      'processId': processId,
      'status': status,
    };
  }
}
