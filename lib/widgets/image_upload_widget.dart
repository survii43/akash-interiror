import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_compression_service.dart';
import '../services/database_service.dart';
import '../config/app_colors.dart';

class ImageUploadWidget extends StatefulWidget {
  final int projectId;
  final int clientId;
  final Function(int imageId)? onImageUploaded;
  final double? width;
  final double? height;
  final bool showProgress;
  final bool allowMultiple;

  const ImageUploadWidget({
    super.key,
    required this.projectId,
    required this.clientId,
    this.onImageUploaded,
    this.width,
    this.height,
    this.showProgress = true,
    this.allowMultiple = false,
  });

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  final DatabaseService _databaseService = DatabaseService();
  bool _isUploading = false;
  String? _error;
  final List<int> _uploadedImageIds = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 200,
      height: widget.height ?? 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _isUploading
          ? _buildUploadingState()
          : _buildUploadButton(),
    );
  }

  Widget _buildUploadingState() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 12),
          Text(
            'Uploading...',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Compressing in background',
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'Add Image',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Max 450x450',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 12,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isUploading = true;
        _error = null;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920, // Allow higher resolution for better quality
        maxHeight: 1920,
        imageQuality: 100, // Get original quality first
      );

      if (image == null) {
        setState(() {
          _isUploading = false;
        });
        return;
      }

      // Read image data
      final Uint8List imageData = await image.readAsBytes();

      // Get image info
      final imageInfo = await ImageCompressionService.getImageInfo(imageData);

      // Insert image into database (compression happens in background)
      final imageId = await _databaseService.insertImage(
        projectId: widget.projectId,
        clientId: widget.clientId,
        originalFileName: image.name,
        mimeType: 'image/${imageInfo.format.toLowerCase()}',
        originalSize: imageData.length,
        width: imageInfo.width,
        height: imageInfo.height,
        originalData: imageData,
      );

      setState(() {
        _isUploading = false;
        _uploadedImageIds.add(imageId);
      });

      // Notify parent widget
      widget.onImageUploaded?.call(imageId);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image uploaded successfully'),
          backgroundColor: AppColors.success,
        ),
      );

    } catch (e) {
      setState(() {
        _isUploading = false;
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

class ImageUploadGrid extends StatefulWidget {
  final int projectId;
  final int clientId;
  final Function(List<int> imageIds)? onImagesChanged;
  final int maxImages;
  final double? width;
  final double? height;

  const ImageUploadGrid({
    super.key,
    required this.projectId,
    required this.clientId,
    this.onImagesChanged,
    this.maxImages = 10,
    this.width,
    this.height,
  });

  @override
  _ImageUploadGridState createState() => _ImageUploadGridState();
}

class _ImageUploadGridState extends State<ImageUploadGrid> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final images = await _databaseService.getProjectImages(widget.projectId);
      setState(() {
        _images = images;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: widget.height ?? 200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _images.length + (_images.length < widget.maxImages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _images.length) {
            return _buildAddButton();
          }
          
          final image = _images[index];
          return _buildImageThumbnail(image);
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: _addImage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.grey[600]),
            const SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(Map<String, dynamic> image) {
    return Container(
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
                    child: Icon(Icons.image, color: Colors.grey[400]),
                  );
                }
              },
            ),
          ),
          // Compression status indicator
          if (image['compressionStatus'] == 'pending')
            Positioned(
              top: 4,
              right: 4,
              child: Container(
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
            ),
          // Delete button
          Positioned(
            top: 4,
            left: 4,
            child: GestureDetector(
              onTap: () => _deleteImage(image['id']),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 100,
    );

    if (image == null) return;

    try {
      final Uint8List imageData = await image.readAsBytes();
      final imageInfo = await ImageCompressionService.getImageInfo(imageData);

      await _databaseService.insertImage(
        projectId: widget.projectId,
        clientId: widget.clientId,
        originalFileName: image.name,
        mimeType: 'image/${imageInfo.format.toLowerCase()}',
        originalSize: imageData.length,
        width: imageInfo.width,
        height: imageInfo.height,
        originalData: imageData,
      );

      await _loadImages();
      widget.onImagesChanged?.call(_images.map((img) => img['id'] as int).toList());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  Future<void> _deleteImage(int imageId) async {
    try {
      await _databaseService.deleteImage(imageId);
      await _loadImages();
      widget.onImagesChanged?.call(_images.map((img) => img['id'] as int).toList());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
      );
    }
  }
}
