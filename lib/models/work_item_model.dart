/// Work Item model representing measurements and work details
class WorkItem {
  final int? id;
  final int projectId;
  final int sNo; // Serial number
  final String description;
  final String unitOfMeasure; // Meter, sqft, sqm, etc.
  final int quantityCount; // Number of items
  final double lengthM;
  final double widthM;
  final double areaSqm;
  final double areaSqft;
  final String? materialType;
  final String workCategory; // wall, floor, ceiling, etc.
  final String? imageRef; // Reference to image or cloud path
  final String? remarks;
  final DateTime createdAt;
  final DateTime? updatedAt;

  static const List<String> workCategories = [
    'wall',
    'floor',
    'ceiling',
    'door',
    'window',
    'finishing',
    'other'
  ];

  static const List<String> unitsOfMeasure = [
    'Meter',
    'sqft',
    'sqm',
    'Count',
    'Liter',
    'kg'
  ];

  WorkItem({
    this.id,
    required this.projectId,
    required this.sNo,
    required this.description,
    required this.unitOfMeasure,
    required this.quantityCount,
    required this.lengthM,
    required this.widthM,
    required this.areaSqm,
    required this.areaSqft,
    this.materialType,
    required this.workCategory,
    this.imageRef,
    this.remarks,
    DateTime? createdAt,
    this.updatedAt,
  })  : createdAt = createdAt ?? DateTime.now() {
    assert(workCategories.contains(workCategory),
        'Invalid workCategory: $workCategory');
    assert(unitsOfMeasure.contains(unitOfMeasure),
        'Invalid unitOfMeasure: $unitOfMeasure');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'sNo': sNo,
      'description': description,
      'unitOfMeasure': unitOfMeasure,
      'quantityCount': quantityCount,
      'lengthM': lengthM,
      'widthM': widthM,
      'areaSqm': areaSqm,
      'areaSqft': areaSqft,
      'materialType': materialType,
      'workCategory': workCategory,
      'imageRef': imageRef,
      'remarks': remarks,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory WorkItem.fromMap(Map<String, dynamic> map) {
    return WorkItem(
      id: map['id'] as int?,
      projectId: map['projectId'] as int,
      sNo: map['sNo'] as int,
      description: map['description'] as String,
      unitOfMeasure: map['unitOfMeasure'] as String,
      quantityCount: map['quantityCount'] as int,
      lengthM: (map['lengthM'] as num).toDouble(),
      widthM: (map['widthM'] as num).toDouble(),
      areaSqm: (map['areaSqm'] as num).toDouble(),
      areaSqft: (map['areaSqft'] as num).toDouble(),
      materialType: map['materialType'] as String?,
      workCategory: map['workCategory'] as String,
      imageRef: map['imageRef'] as String?,
      remarks: map['remarks'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  WorkItem copyWith({
    int? id,
    int? projectId,
    int? sNo,
    String? description,
    String? unitOfMeasure,
    int? quantityCount,
    double? lengthM,
    double? widthM,
    double? areaSqm,
    double? areaSqft,
    String? materialType,
    String? workCategory,
    String? imageRef,
    String? remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkItem(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      sNo: sNo ?? this.sNo,
      description: description ?? this.description,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      quantityCount: quantityCount ?? this.quantityCount,
      lengthM: lengthM ?? this.lengthM,
      widthM: widthM ?? this.widthM,
      areaSqm: areaSqm ?? this.areaSqm,
      areaSqft: areaSqft ?? this.areaSqft,
      materialType: materialType ?? this.materialType,
      workCategory: workCategory ?? this.workCategory,
      imageRef: imageRef ?? this.imageRef,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'WorkItem(id: $id, projectId: $projectId, sNo: $sNo, description: $description, areaSqm: $areaSqm)';
  }
}
