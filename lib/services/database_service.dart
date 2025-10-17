import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/client_model.dart';
import '../models/project_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'akash_manager.db';
  static const String _clientTable = 'clients';
  static const String _projectTable = 'projects';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create clients table
    await db.execute('''
      CREATE TABLE $_clientTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        address TEXT,
        company TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        dataTier TEXT DEFAULT 'active',
        isArchived INTEGER DEFAULT 0,
        archivedAt TEXT
      )
    ''');

    // Create projects table with enhanced fields
    await db.execute('''
      CREATE TABLE $_projectTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        clientId INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'Active',
        startDate TEXT,
        endDate TEXT,
        budget REAL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        dataTier TEXT DEFAULT 'active',
        isArchived INTEGER DEFAULT 0,
        archivedAt TEXT,
        compressionRatio REAL,
        FOREIGN KEY (clientId) REFERENCES $_clientTable(id) ON DELETE CASCADE
      )
    ''');

    // Create images table
    await db.execute('''
      CREATE TABLE images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectId INTEGER NOT NULL,
        clientId INTEGER NOT NULL,
        originalFileName TEXT NOT NULL,
        mimeType TEXT NOT NULL,
        originalSize INTEGER NOT NULL,
        compressedSize INTEGER,
        thumbnailSize INTEGER,
        width INTEGER NOT NULL,
        height INTEGER NOT NULL,
        compressedData BLOB,
        thumbnailData BLOB,
        cloudPath TEXT,
        uploadedAt TEXT NOT NULL,
        compressedAt TEXT,
        compressionRatio REAL,
        isCompressed INTEGER DEFAULT 0,
        isCloudUploaded INTEGER DEFAULT 0,
        compressionStatus TEXT DEFAULT 'pending',
        FOREIGN KEY (projectId) REFERENCES $_projectTable(id) ON DELETE CASCADE,
        FOREIGN KEY (clientId) REFERENCES $_clientTable(id) ON DELETE CASCADE
      )
    ''');

    // Create image thumbnails table for fast loading
    await db.execute('''
      CREATE TABLE image_thumbnails (
        imageId INTEGER PRIMARY KEY,
        thumbnailData BLOB NOT NULL,
        thumbnailSize INTEGER NOT NULL,
        width INTEGER NOT NULL,
        height INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (imageId) REFERENCES images(id) ON DELETE CASCADE
      )
    ''');

    // Create compression queue table
    await db.execute('''
      CREATE TABLE compression_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageId INTEGER NOT NULL,
        priority INTEGER DEFAULT 0,
        status TEXT DEFAULT 'pending',
        createdAt TEXT NOT NULL,
        processedAt TEXT,
        errorMessage TEXT,
        retryCount INTEGER DEFAULT 0,
        FOREIGN KEY (imageId) REFERENCES images(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for performance
    await _createIndexes(db);
  }

  Future<void> _createIndexes(Database db) async {
    // Client indexes
    await db.execute('CREATE INDEX idx_clients_email ON $_clientTable(email)');
    await db.execute('CREATE INDEX idx_clients_archived ON $_clientTable(isArchived)');
    await db.execute('CREATE INDEX idx_clients_tier ON $_clientTable(dataTier)');
    
    // Project indexes
    await db.execute('CREATE INDEX idx_projects_client ON $_projectTable(clientId)');
    await db.execute('CREATE INDEX idx_projects_status ON $_projectTable(status)');
    await db.execute('CREATE INDEX idx_projects_archived ON $_projectTable(isArchived)');
    await db.execute('CREATE INDEX idx_projects_tier ON $_projectTable(dataTier)');
    
    // Image indexes
    await db.execute('CREATE INDEX idx_images_project ON images(projectId)');
    await db.execute('CREATE INDEX idx_images_client ON images(clientId)');
    await db.execute('CREATE INDEX idx_images_compressed ON images(isCompressed)');
    await db.execute('CREATE INDEX idx_images_cloud ON images(isCloudUploaded)');
    await db.execute('CREATE INDEX idx_images_status ON images(compressionStatus)');
    
    // Compression queue indexes
    await db.execute('CREATE INDEX idx_compression_status ON compression_queue(status)');
    await db.execute('CREATE INDEX idx_compression_priority ON compression_queue(priority)');
  }

  // CLIENTS CRUD OPERATIONS
  
  Future<int> insertClient(Client client) async {
    final db = await database;
    return await db.insert(_clientTable, client.toMap());
  }

  Future<Client?> getClient(int id) async {
    final db = await database;
    final result = await db.query(
      _clientTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Client.fromMap(result.first);
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    final result = await db.query(
      _clientTable,
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Client.fromMap(map)).toList();
  }

  Future<List<Client>> searchClients(String query) async {
    final db = await database;
    final result = await db.query(
      _clientTable,
      where: 'name LIKE ? OR email LIKE ? OR phone LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Client.fromMap(map)).toList();
  }

  Future<int> updateClient(Client client) async {
    final db = await database;
    return await db.update(
      _clientTable,
      client.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteClient(int id) async {
    final db = await database;
    return await db.delete(
      _clientTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // PROJECTS CRUD OPERATIONS
  
  Future<int> insertProject(Project project) async {
    final db = await database;
    return await db.insert(_projectTable, project.toMap());
  }

  Future<Project?> getProject(int id) async {
    final db = await database;
    final result = await db.query(
      _projectTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Project.fromMap(result.first);
  }

  Future<List<Project>> getAllProjects() async {
    final db = await database;
    final result = await db.query(
      _projectTable,
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Project.fromMap(map)).toList();
  }

  Future<List<Project>> getProjectsByClient(int clientId) async {
    final db = await database;
    final result = await db.query(
      _projectTable,
      where: 'clientId = ?',
      whereArgs: [clientId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Project.fromMap(map)).toList();
  }

  Future<List<Project>> searchProjects(String query) async {
    final db = await database;
    final result = await db.query(
      _projectTable,
      where: 'name LIKE ? OR description LIKE ? OR status LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Project.fromMap(map)).toList();
  }

  Future<int> updateProject(Project project) async {
    final db = await database;
    return await db.update(
      _projectTable,
      project.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  Future<int> deleteProject(int id) async {
    final db = await database;
    return await db.delete(
      _projectTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // IMAGE CRUD OPERATIONS
  
  Future<int> insertImage({
    required int projectId,
    required int clientId,
    required String originalFileName,
    required String mimeType,
    required int originalSize,
    required int width,
    required int height,
    required Uint8List originalData,
  }) async {
    final db = await database;
    
    // Insert image record
    final imageId = await db.insert('images', {
      'projectId': projectId,
      'clientId': clientId,
      'originalFileName': originalFileName,
      'mimeType': mimeType,
      'originalSize': originalSize,
      'width': width,
      'height': height,
      'compressedData': originalData, // Store original temporarily
      'uploadedAt': DateTime.now().toIso8601String(),
      'compressionStatus': 'pending',
    });

    // Add to compression queue
    await db.insert('compression_queue', {
      'imageId': imageId,
      'priority': 0,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });

    return imageId;
  }

  Future<Map<String, dynamic>?> getImage(int imageId) async {
    final db = await database;
    final result = await db.query(
      'images',
      where: 'id = ?',
      whereArgs: [imageId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getProjectImages(int projectId) async {
    final db = await database;
    return await db.query(
      'images',
      where: 'projectId = ?',
      whereArgs: [projectId],
      orderBy: 'uploadedAt DESC',
    );
  }

  Future<Uint8List?> getImageData(int imageId) async {
    final db = await database;
    final result = await db.query(
      'images',
      columns: ['compressedData'],
      where: 'id = ?',
      whereArgs: [imageId],
    );
    
    if (result.isEmpty) return null;
    return result.first['compressedData'] as Uint8List?;
  }

  Future<Uint8List?> getImageThumbnail(int imageId) async {
    final db = await database;
    final result = await db.query(
      'image_thumbnails',
      columns: ['thumbnailData'],
      where: 'imageId = ?',
      whereArgs: [imageId],
    );
    
    if (result.isEmpty) return null;
    return result.first['thumbnailData'] as Uint8List?;
  }

  Future<void> updateImageCompression({
    required int imageId,
    required Uint8List compressedData,
    required Uint8List thumbnailData,
    required double compressionRatio,
  }) async {
    final db = await database;
    
    // Update image with compressed data
    await db.update(
      'images',
      {
        'compressedData': compressedData,
        'thumbnailData': thumbnailData,
        'compressedSize': compressedData.length,
        'thumbnailSize': thumbnailData.length,
        'compressionRatio': compressionRatio,
        'isCompressed': 1,
        'compressionStatus': 'completed',
        'compressedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [imageId],
    );

    // Insert thumbnail separately for fast access
    await db.insert('image_thumbnails', {
      'imageId': imageId,
      'thumbnailData': thumbnailData,
      'thumbnailSize': thumbnailData.length,
      'width': 200, // Thumbnail dimensions
      'height': 200,
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Update compression queue
    await db.update(
      'compression_queue',
      {
        'status': 'completed',
        'processedAt': DateTime.now().toIso8601String(),
      },
      where: 'imageId = ?',
      whereArgs: [imageId],
    );
  }

  Future<void> updateImageCloudPath(int imageId, String cloudPath) async {
    final db = await database;
    await db.update(
      'images',
      {
        'cloudPath': cloudPath,
        'isCloudUploaded': 1,
      },
      where: 'id = ?',
      whereArgs: [imageId],
    );
  }

  Future<void> deleteImage(int imageId) async {
    final db = await database;
    await db.delete('images', where: 'id = ?', whereArgs: [imageId]);
    await db.delete('image_thumbnails', where: 'imageId = ?', whereArgs: [imageId]);
    await db.delete('compression_queue', where: 'imageId = ?', whereArgs: [imageId]);
  }

  // COMPRESSION QUEUE OPERATIONS
  
  Future<List<Map<String, dynamic>>> getPendingCompressions() async {
    final db = await database;
    return await db.query(
      'compression_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'priority DESC, createdAt ASC',
    );
  }

  Future<void> updateCompressionStatus({
    required int imageId,
    required String status,
    String? errorMessage,
  }) async {
    final db = await database;
    await db.update(
      'compression_queue',
      {
        'status': status,
        'processedAt': DateTime.now().toIso8601String(),
        'errorMessage': errorMessage,
      },
      where: 'imageId = ?',
      whereArgs: [imageId],
    );
  }

  // IMAGE ANALYTICS
  
  Future<Map<String, dynamic>> getImageStats() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT 
        COUNT(*) as totalImages,
        SUM(originalSize) as totalOriginalSize,
        SUM(compressedSize) as totalCompressedSize,
        AVG(compressionRatio) as avgCompressionRatio,
        COUNT(CASE WHEN isCompressed = 1 THEN 1 END) as compressedCount,
        COUNT(CASE WHEN isCloudUploaded = 1 THEN 1 END) as cloudUploadedCount
      FROM images
    ''');
    
    return result.first;
  }

  Future<List<Map<String, dynamic>>> getImagesByStatus(String status) async {
    final db = await database;
    return await db.query(
      'images',
      where: 'compressionStatus = ?',
      whereArgs: [status],
      orderBy: 'uploadedAt DESC',
    );
  }

  // Database management
  
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
