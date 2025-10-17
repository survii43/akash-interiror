/// Work Rate model representing rates for different work categories
class WorkRate {
  final int? id;
  final int projectId;
  final String workCategory; // wall, floor, ceiling, etc.
  final String unit; // sqft, sqm, meter, count, etc.
  final double rateValue; // Rate amount
  final String currency; // INR, USD, etc.
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  static const List<String> validCurrencies = ['INR', 'USD', 'EUR', 'GBP'];

  WorkRate({
    this.id,
    required this.projectId,
    required this.workCategory,
    required this.unit,
    required this.rateValue,
    this.currency = 'INR',
    required this.effectiveFrom,
    this.effectiveTo,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now() {
    assert(validCurrencies.contains(currency), 'Invalid currency: $currency');
    assert(
      effectiveTo == null || effectiveFrom.isBefore(effectiveTo!),
      'effectiveFrom must be before effectiveTo',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'workCategory': workCategory,
      'unit': unit,
      'rateValue': rateValue,
      'currency': currency,
      'effectiveFrom': effectiveFrom.toIso8601String(),
      'effectiveTo': effectiveTo?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory WorkRate.fromMap(Map<String, dynamic> map) {
    return WorkRate(
      id: map['id'] as int?,
      projectId: map['projectId'] as int,
      workCategory: map['workCategory'] as String,
      unit: map['unit'] as String,
      rateValue: (map['rateValue'] as num).toDouble(),
      currency: map['currency'] as String? ?? 'INR',
      effectiveFrom: DateTime.parse(map['effectiveFrom'] as String),
      effectiveTo: map['effectiveTo'] != null
          ? DateTime.parse(map['effectiveTo'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  WorkRate copyWith({
    int? id,
    int? projectId,
    String? workCategory,
    String? unit,
    double? rateValue,
    String? currency,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkRate(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      workCategory: workCategory ?? this.workCategory,
      unit: unit ?? this.unit,
      rateValue: rateValue ?? this.rateValue,
      currency: currency ?? this.currency,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool isEffective(DateTime date) {
    return !date.isBefore(effectiveFrom) &&
        (effectiveTo == null || date.isBefore(effectiveTo!));
  }

  @override
  String toString() {
    return 'WorkRate(id: $id, projectId: $projectId, workCategory: $workCategory, rateValue: $rateValue $currency)';
  }
}
