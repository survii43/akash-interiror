class Project {
  final int? id;
  final String name;
  final String? description;
  final int clientId;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? budget;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Project({
    this.id,
    required this.name,
    this.description,
    required this.clientId,
    this.status = 'Active',
    this.startDate,
    this.endDate,
    this.budget,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create Project from Map (database)
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      clientId: map['clientId'] as int,
      status: map['status'] as String? ?? 'Active',
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'] as String)
          : null,
      endDate:
          map['endDate'] != null ? DateTime.parse(map['endDate'] as String) : null,
      budget: map['budget'] != null ? (map['budget'] as num).toDouble() : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, clientId: $clientId, status: $status)';
  }
}
