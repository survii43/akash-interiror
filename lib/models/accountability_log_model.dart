/// Accountability Log model for tracking actions and changes
class AccountabilityLog {
  final int? id;
  final int projectId;
  final int? workItemId;
  final String action; // Approved deduction, Added work item, Updated rate, etc.
  final String performedBy; // user_id or username
  final String? comments;
  final DateTime timestamp;
  final String? changedFields; // JSON string of what changed
  final String? oldValues; // JSON string of old values
  final String? newValues; // JSON string of new values

  static const List<String> commonActions = [
    'Approved deduction',
    'Rejected deduction',
    'Added work item',
    'Updated work item',
    'Deleted work item',
    'Added deduction',
    'Updated deduction',
    'Deleted deduction',
    'Added rate',
    'Updated rate',
    'Deleted rate',
    'Approved project',
    'Rejected project',
    'Status changed',
    'User added',
    'User removed',
    'Verified measurements'
  ];

  AccountabilityLog({
    this.id,
    required this.projectId,
    this.workItemId,
    required this.action,
    required this.performedBy,
    this.comments,
    DateTime? timestamp,
    this.changedFields,
    this.oldValues,
    this.newValues,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'workItemId': workItemId,
      'action': action,
      'performedBy': performedBy,
      'comments': comments,
      'timestamp': timestamp.toIso8601String(),
      'changedFields': changedFields,
      'oldValues': oldValues,
      'newValues': newValues,
    };
  }

  factory AccountabilityLog.fromMap(Map<String, dynamic> map) {
    return AccountabilityLog(
      id: map['id'] as int?,
      projectId: map['projectId'] as int,
      workItemId: map['workItemId'] as int?,
      action: map['action'] as String,
      performedBy: map['performedBy'] as String,
      comments: map['comments'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      changedFields: map['changedFields'] as String?,
      oldValues: map['oldValues'] as String?,
      newValues: map['newValues'] as String?,
    );
  }

  AccountabilityLog copyWith({
    int? id,
    int? projectId,
    int? workItemId,
    String? action,
    String? performedBy,
    String? comments,
    DateTime? timestamp,
    String? changedFields,
    String? oldValues,
    String? newValues,
  }) {
    return AccountabilityLog(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      workItemId: workItemId ?? this.workItemId,
      action: action ?? this.action,
      performedBy: performedBy ?? this.performedBy,
      comments: comments ?? this.comments,
      timestamp: timestamp ?? this.timestamp,
      changedFields: changedFields ?? this.changedFields,
      oldValues: oldValues ?? this.oldValues,
      newValues: newValues ?? this.newValues,
    );
  }

  @override
  String toString() {
    return 'AccountabilityLog(id: $id, projectId: $projectId, action: $action, performedBy: $performedBy)';
  }
}
