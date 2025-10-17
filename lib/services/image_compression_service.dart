import 'dart:async';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'database_service.dart';

class ImageCompressionService {
  static const int maxDimension = 450;
  static const int thumbnailSize = 200;
  static const int quality = 85;
  static const int thumbnailQuality = 70;
  
  final DatabaseService _databaseService;
  Timer? _compressionTimer;
  bool _isProcessing = false;

  ImageCompressionService(this._databaseService);

  /// Start background compression processing
  void startBackgroundCompression() {
    _compressionTimer?.cancel();
    _compressionTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _processCompressionQueue();
    });
  }

  /// Stop background compression processing
  void stopBackgroundCompression() {
    _compressionTimer?.cancel();
    _compressionTimer = null;
  }

  /// Process compression queue in background
  Future<void> _processCompressionQueue() async {
    if (_isProcessing) return;
    
    _isProcessing = true;
    
    try {
      final pendingItems = await _databaseService.getPendingCompressions();
      
      for (final item in pendingItems.take(3)) { // Process max 3 at a time
        await _compressImage(item['imageId'] as int);
      }
    } catch (e) {
      print('Background compression error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  /// Compress a single image
  Future<void> _compressImage(int imageId) async {
    try {
      // Update status to processing
      await _databaseService.updateCompressionStatus(
        imageId: imageId,
        status: 'processing',
      );

      // Get image data
      final imageData = await _databaseService.getImageData(imageId);
      if (imageData == null) {
        throw Exception('Image data not found');
      }

      // Compress image
      final compressionResult = await compressImageData(imageData);

      // Update database with compressed data
      await _databaseService.updateImageCompression(
        imageId: imageId,
        compressedData: compressionResult.compressedData,
        thumbnailData: compressionResult.thumbnailData,
        compressionRatio: compressionResult.compressionRatio,
      );

      print('Image $imageId compressed successfully');
    } catch (e) {
      print('Compression failed for image $imageId: $e');
      await _databaseService.updateCompressionStatus(
        imageId: imageId,
        status: 'failed',
        errorMessage: e.toString(),
      );
    }
  }

  /// Compress image data with quality preservation
  static Future<CompressionResult> compressImageData(Uint8List imageData) async {
    try {
      // Decode the image
      final image = img.decodeImage(imageData);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Calculate new dimensions maintaining aspect ratio
      final dimensions = _calculateDimensions(
        image.width,
        image.height,
        maxDimension,
        maxDimension,
      );

      // Create compressed image
      final compressedImage = img.copyResize(
        image,
        width: dimensions.width,
        height: dimensions.height,
        interpolation: img.Interpolation.cubic,
      );

      // Create thumbnail
      final thumbnailImage = img.copyResize(
        image,
        width: thumbnailSize,
        height: thumbnailSize,
        interpolation: img.Interpolation.cubic,
      );

      // Encode images
      final compressedData = Uint8List.fromList(
        img.encodeJpg(compressedImage, quality: quality),
      );

      final thumbnailData = Uint8List.fromList(
        img.encodeJpg(thumbnailImage, quality: thumbnailQuality),
      );

      // Calculate compression ratio
      final compressionRatio = compressedData.length / imageData.length;

      return CompressionResult(
        compressedData: compressedData,
        thumbnailData: thumbnailData,
        compressionRatio: compressionRatio,
        originalSize: imageData.length,
        compressedSize: compressedData.length,
        thumbnailSize: thumbnailData.length,
      );
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }

  /// Calculate optimal dimensions maintaining aspect ratio
  static _ImageDimensions _calculateDimensions(
    int originalWidth,
    int originalHeight,
    int maxWidth,
    int maxHeight,
  ) {
    // If image is already smaller than max dimensions, return original
    if (originalWidth <= maxWidth && originalHeight <= maxHeight) {
      return _ImageDimensions(originalWidth, originalHeight);
    }

    // Calculate scaling factor
    final widthRatio = maxWidth / originalWidth;
    final heightRatio = maxHeight / originalHeight;
    
    // Use the smaller ratio to ensure both dimensions fit within limits
    final scale = widthRatio < heightRatio ? widthRatio : heightRatio;

    return _ImageDimensions(
      (originalWidth * scale).round(),
      (originalHeight * scale).round(),
    );
  }

  /// Get image information
  static Future<ImageInfo> getImageInfo(Uint8List imageData) async {
    try {
      final image = img.decodeImage(imageData);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      return ImageInfo(
        width: image.width,
        height: image.height,
        size: imageData.length,
        format: _getImageFormat(imageData),
      );
    } catch (e) {
      throw Exception('Failed to get image info: $e');
    }
  }

  /// Detect image format
  static String _getImageFormat(Uint8List data) {
    if (data.length < 4) return 'unknown';
    
    // Check file signatures
    if (data[0] == 0xFF && data[1] == 0xD8) return 'JPEG';
    if (data[0] == 0x89 && data[1] == 0x50 && data[2] == 0x4E && data[3] == 0x47) {
      return 'PNG';
    }
    if (data[0] == 0x47 && data[1] == 0x49 && data[2] == 0x46) return 'GIF';
    if (data[0] == 0x52 && data[1] == 0x49 && data[2] == 0x46 && data[3] == 0x46) {
      return 'WEBP';
    }
    
    return 'unknown';
  }

  /// Clean up old compression queue items
  Future<void> cleanupCompressionQueue() async {
    try {
      // Remove completed items older than 7 days
      final cutoffDate = DateTime.now().subtract(const Duration(days: 7));
      // TODO: Implement cleanup logic using cutoffDate
      print('Cleanup cutoff date: $cutoffDate');
    } catch (e) {
      print('Cleanup failed: $e');
    }
  }
}

class CompressionResult {
  final Uint8List compressedData;
  final Uint8List thumbnailData;
  final double compressionRatio;
  final int originalSize;
  final int compressedSize;
  final int thumbnailSize;

  CompressionResult({
    required this.compressedData,
    required this.thumbnailData,
    required this.compressionRatio,
    required this.originalSize,
    required this.compressedSize,
    required this.thumbnailSize,
  });

  int get spaceSaved => originalSize - compressedSize;
  double get spaceSavedPercentage => (spaceSaved / originalSize) * 100;
}

class _ImageDimensions {
  final int width;
  final int height;

  _ImageDimensions(this.width, this.height);
}

class ImageInfo {
  final int width;
  final int height;
  final int size;
  final String format;

  ImageInfo({
    required this.width,
    required this.height,
    required this.size,
    required this.format,
  });
}
