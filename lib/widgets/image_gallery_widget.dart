import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../config/app_colors.dart';

class ImageGalleryWidget extends StatefulWidget {
  final int projectId;
  final double? width;
  final double? height;
  final int crossAxisCount;
  final double spacing;

  const ImageGalleryWidget({
    super.key,
    required this.projectId,
    this.width,
    this.height,
    this.crossAxisCount = 3,
    this.spacing = 8.0,
  });

  @override
  _ImageGalleryWidgetState createState() => _ImageGalleryWidgetState();
}

class _ImageGalleryWidgetState extends State<ImageGalleryWidget> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _images = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final images = await _databaseService.getProjectImages(widget.projectId);
      setState(() {
        _images = images;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.width,
        height: widget.height ?? 200,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Loading images...'),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height ?? 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: AppColors.error, size: 48),
              const SizedBox(height: 8),
              const Text('Failed to load images'),
              const SizedBox(height: 4),
              Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.grey500)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadImages,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_images.isEmpty) {
      return SizedBox(
        width: widget.width,
        height: widget.height ?? 200,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, color: AppColors.grey400, size: 48),
              SizedBox(height: 8),
              Text('No images found'),
              SizedBox(height: 4),
              Text('Upload images to see them here', style: TextStyle(fontSize: 12, color: AppColors.grey500)),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          crossAxisSpacing: widget.spacing,
          mainAxisSpacing: widget.spacing,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return _buildImageThumbnail(_images[index]);
        },
      ),
    );
  }

  Widget _buildImageThumbnail(Map<String, dynamic> image) {
    return GestureDetector(
      onTap: () => _showImageFullscreen(image),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FutureBuilder<Uint8List?>(
                future: _databaseService.getImageThumbnail(image['id']),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Image.memory(
                      snapshot.data!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, color: Colors.grey[400]),
                          const SizedBox(height: 4),
                          Text(
                            'Loading...',
                            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            // Status indicators
            _buildStatusIndicators(image),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicators(Map<String, dynamic> image) {
    return Positioned(
      top: 4,
      right: 4,
      child: Column(
        children: [
          if (image['compressionStatus'] == 'pending')
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.schedule,
                color: Colors.white,
                size: 12,
              ),
            ),
          if (image['isCompressed'] == 1)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
          if (image['isCloudUploaded'] == 1)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.info,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.cloud_done,
                color: Colors.white,
                size: 12,
              ),
            ),
        ],
      ),
    );
  }

  void _showImageFullscreen(Map<String, dynamic> image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(
          imageId: image['id'],
          imageName: image['originalFileName'],
        ),
      ),
    );
  }
}

class ImageViewerScreen extends StatefulWidget {
  final int imageId;
  final String imageName;

  const ImageViewerScreen({
    super.key,
    required this.imageId,
    required this.imageName,
  });

  @override
  _ImageViewerScreenState createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  final DatabaseService _databaseService = DatabaseService();
  Uint8List? _imageData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final imageData = await _databaseService.getImageData(widget.imageId);
      setState(() {
        _imageData = imageData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.imageName,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadImage,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteImage,
          ),
        ],
      ),
      body: _buildImageContent(),
    );
  }

  Widget _buildImageContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Loading image...', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text('Failed to load image', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadImage,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_imageData == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, color: Colors.white, size: 48),
            SizedBox(height: 16),
            Text('Image not found', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    return Center(
      child: InteractiveViewer(
        child: Image.memory(
          _imageData!,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _downloadImage() {
    // Implement image download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download functionality not implemented')),
    );
  }

  void _deleteImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _databaseService.deleteImage(widget.imageId);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close image viewer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image deleted successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete image: $e')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
