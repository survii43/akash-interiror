/// Project User model representing users assigned to projects
class ProjectUser {
  final int? id;
  final int projectId;
  final String name;
  final String email;
  final String role; // designer, engineer, supervisor, accountant, etc.
  final String raciRole; // R (Responsible), A (Accountable), C (Consulted), I (Informed)
  final bool canEditMeasurements;
  final bool canApproveDeductions;
  final bool canViewTenders;
  final bool canAddRates;
  final bool canDeleteItems;
  final bool canApproveProject;
  final DateTime assignedAt;
  final DateTime? removedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  static const List<String> validRoles = [
    'designer',
    'engineer',
    'supervisor',
    'accountant',
    'admin',
    'viewer'
  ];

  static const List<String> validRaciRoles = ['R', 'A', 'C', 'I'];

  ProjectUser({
    this.id,
    required this.projectId,
    required this.name,
    required this.email,
    required this.role,
    this.raciRole = 'R',
    this.canEditMeasurements = false,
    this.canApproveDeductions = false,
    this.canViewTenders = false,
    this.canAddRates = false,
    this.canDeleteItems = false,
    this.canApproveProject = false,
    DateTime? assignedAt,
    this.removedAt,
    DateTime? createdAt,
    this.updatedAt,
  })  : assignedAt = assignedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now() {
    assert(validRoles.contains(role), 'Invalid role: $role');
    assert(validRaciRoles.contains(raciRole), 'Invalid RACI role: $raciRole');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'email': email,
      'role': role,
      'raciRole': raciRole,
      'canEditMeasurements': canEditMeasurements ? 1 : 0,
      'canApproveDeductions': canApproveDeductions ? 1 : 0,
      'canViewTenders': canViewTenders ? 1 : 0,
      'canAddRates': canAddRates ? 1 : 0,
      'canDeleteItems': canDeleteItems ? 1 : 0,
      'canApproveProject': canApproveProject ? 1 : 0,
      'assignedAt': assignedAt.toIso8601String(),
      'removedAt': removedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ProjectUser.fromMap(Map<String, dynamic> map) {
    return ProjectUser(
      id: map['id'] as int?,
      projectId: map['projectId'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      raciRole: map['raciRole'] as String? ?? 'R',
      canEditMeasurements: (map['canEditMeasurements'] as int?) == 1,
      canApproveDeductions: (map['canApproveDeductions'] as int?) == 1,
      canViewTenders: (map['canViewTenders'] as int?) == 1,
      canAddRates: (map['canAddRates'] as int?) == 1,
      canDeleteItems: (map['canDeleteItems'] as int?) == 1,
      canApproveProject: (map['canApproveProject'] as int?) == 1,
      assignedAt: DateTime.parse(map['assignedAt'] as String),
      removedAt: map['removedAt'] != null
          ? DateTime.parse(map['removedAt'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  ProjectUser copyWith({
    int? id,
    int? projectId,
    String? name,
    String? email,
    String? role,
    String? raciRole,
    bool? canEditMeasurements,
    bool? canApproveDeductions,
    bool? canViewTenders,
    bool? canAddRates,
    bool? canDeleteItems,
    bool? canApproveProject,
    DateTime? assignedAt,
    DateTime? removedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectUser(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      raciRole: raciRole ?? this.raciRole,
      canEditMeasurements: canEditMeasurements ?? this.canEditMeasurements,
      canApproveDeductions: canApproveDeductions ?? this.canApproveDeductions,
      canViewTenders: canViewTenders ?? this.canViewTenders,
      canAddRates: canAddRates ?? this.canAddRates,
      canDeleteItems: canDeleteItems ?? this.canDeleteItems,
      canApproveProject: canApproveProject ?? this.canApproveProject,
      assignedAt: assignedAt ?? this.assignedAt,
      removedAt: removedAt ?? this.removedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool isActive() => removedAt == null;

  @override
  String toString() {
    return 'ProjectUser(id: $id, projectId: $projectId, name: $name, role: $role, raciRole: $raciRole)';
  }
}
