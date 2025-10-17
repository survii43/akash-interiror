class Project {
  final int? id;
  final String name;
  final String? description;
  final int clientId;
  final String status; // tender, active, completed, on-hold, cancelled
  final DateTime? startDate;
  final DateTime? endDate;
  final double? budget;
  final String? location;
  final String? createdBy; // user_id or username
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Summary/Measurement fields
  final double? totalAreaSqm;
  final double? totalDeductionSqm;
  final double? totalClaimableSqm;
  final double? totalClaimableSqft;
  final String? verifiedBy; // user_id or username
  final DateTime? verifiedOn;

  static const List<String> validStatuses = [
    'tender',
    'active',
    'completed',
    'on-hold',
    'cancelled'
  ];

  Project({
    this.id,
    required this.name,
    this.description,
    required this.clientId,
    this.status = 'tender',
    this.startDate,
    this.endDate,
    this.budget,
    this.location,
    this.createdBy,
    DateTime? createdAt,
    this.updatedAt,
    this.totalAreaSqm,
    this.totalDeductionSqm,
    this.totalClaimableSqm,
    this.totalClaimableSqft,
    this.verifiedBy,
    this.verifiedOn,
  }) : createdAt = createdAt ?? DateTime.now() {
    assert(
      validStatuses.contains(status),
      'Invalid status: $status. Must be one of: ${validStatuses.join(", ")}',
    );
  }

  // Convert Project to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'clientId': clientId,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'budget': budget,
      'location': location,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'totalAreaSqm': totalAreaSqm,
      'totalDeductionSqm': totalDeductionSqm,
      'totalClaimableSqm': totalClaimableSqm,
      'totalClaimableSqft': totalClaimableSqft,
      'verifiedBy': verifiedBy,
      'verifiedOn': verifiedOn?.toIso8601String(),
    };
  }

  // Create Project from Map (database)
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      clientId: map['clientId'] as int,
      status: map['status'] as String? ?? 'tender',
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'] as String)
          : null,
      endDate:
          map['endDate'] != null ? DateTime.parse(map['endDate'] as String) : null,
      budget: map['budget'] != null ? (map['budget'] as num).toDouble() : null,
      location: map['location'] as String?,
      createdBy: map['createdBy'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      totalAreaSqm: map['totalAreaSqm'] != null
          ? (map['totalAreaSqm'] as num).toDouble()
          : null,
      totalDeductionSqm: map['totalDeductionSqm'] != null
          ? (map['totalDeductionSqm'] as num).toDouble()
          : null,
      totalClaimableSqm: map['totalClaimableSqm'] != null
          ? (map['totalClaimableSqm'] as num).toDouble()
          : null,
      totalClaimableSqft: map['totalClaimableSqft'] != null
          ? (map['totalClaimableSqft'] as num).toDouble()
          : null,
      verifiedBy: map['verifiedBy'] as String?,
      verifiedOn: map['verifiedOn'] != null
          ? DateTime.parse(map['verifiedOn'] as String)
          : null,
    );
  }

  // Copy with method
  Project copyWith({
    int? id,
    String? name,
    String? description,
    int? clientId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    String? location,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? totalAreaSqm,
    double? totalDeductionSqm,
    double? totalClaimableSqm,
    double? totalClaimableSqft,
    String? verifiedBy,
    DateTime? verifiedOn,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalAreaSqm: totalAreaSqm ?? this.totalAreaSqm,
      totalDeductionSqm: totalDeductionSqm ?? this.totalDeductionSqm,
      totalClaimableSqm: totalClaimableSqm ?? this.totalClaimableSqm,
      totalClaimableSqft: totalClaimableSqft ?? this.totalClaimableSqft,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedOn: verifiedOn ?? this.verifiedOn,
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, clientId: $clientId, status: $status, location: $location)';
  }
}
