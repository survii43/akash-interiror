/// Deduction model representing deductions from work items
class Deduction {
  final int? id;
  final int projectId;
  final int workItemId;
  final String reason; // Window opening, Door opening, Pipe, etc.
  final double lengthM;
  final double widthM;
  final int quantity;
  final double areaSqm;
  final double areaSqft;
  final DateTime createdAt;
  final DateTime? updatedAt;

  static const List<String> deductionReasons = [
    'Window opening',
    'Door opening',
    'Pipe',
    'Electrical outlet',
    'Damage',
    'Other'
  ];

  Deduction({
    this.id,
    required this.projectId,
    required this.workItemId,
    required this.reason,
    required this.lengthM,
    required this.widthM,
    required this.quantity,
    required this.areaSqm,
    required this.areaSqft,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now() {
    assert(deductionReasons.contains(reason), 'Invalid reason: $reason');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'workItemId': workItemId,
      'reason': reason,
      'lengthM': lengthM,
      'widthM': widthM,
      'quantity': quantity,
      'areaSqm': areaSqm,
      'areaSqft': areaSqft,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Deduction.fromMap(Map<String, dynamic> map) {
    return Deduction(
      id: map['id'] as int?,
      projectId: map['projectId'] as int,
      workItemId: map['workItemId'] as int,
      reason: map['reason'] as String,
      lengthM: (map['lengthM'] as num).toDouble(),
      widthM: (map['widthM'] as num).toDouble(),
      quantity: map['quantity'] as int,
      areaSqm: (map['areaSqm'] as num).toDouble(),
      areaSqft: (map['areaSqft'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  Deduction copyWith({
    int? id,
    int? projectId,
    int? workItemId,
    String? reason,
    double? lengthM,
    double? widthM,
    int? quantity,
    double? areaSqm,
    double? areaSqft,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Deduction(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      workItemId: workItemId ?? this.workItemId,
      reason: reason ?? this.reason,
      lengthM: lengthM ?? this.lengthM,
      widthM: widthM ?? this.widthM,
      quantity: quantity ?? this.quantity,
      areaSqm: areaSqm ?? this.areaSqm,
      areaSqft: areaSqft ?? this.areaSqft,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Deduction(id: $id, projectId: $projectId, workItemId: $workItemId, reason: $reason, areaSqm: $areaSqm)';
  }
}
