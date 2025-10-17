import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../config/app_colors.dart';

class ImageAnalyticsDashboard extends StatefulWidget {
  const ImageAnalyticsDashboard({super.key});

  @override
  _ImageAnalyticsDashboardState createState() => _ImageAnalyticsDashboardState();
}

class _ImageAnalyticsDashboardState extends State<ImageAnalyticsDashboard> {
  final DatabaseService _databaseService = DatabaseService();
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final stats = await _databaseService.getImageStats();
      setState(() {
        _stats = stats;
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
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Image Storage Analytics',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadStats,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              _buildErrorState()
            else if (_stats != null)
              _buildStatsContent()
            else
              _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error, color: AppColors.error, size: 48),
          const SizedBox(height: 8),
          const Text('Failed to load analytics'),
          const SizedBox(height: 4),
          Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.grey500)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadStats,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.image_not_supported, color: AppColors.grey400, size: 48),
          SizedBox(height: 8),
          Text('No images found'),
          SizedBox(height: 4),
          Text('Upload images to see analytics', style: TextStyle(fontSize: 12, color: AppColors.grey500)),
        ],
      ),
    );
  }

  Widget _buildStatsContent() {
    final stats = _stats!;
    final totalImages = stats['totalImages'] as int? ?? 0;
    final totalOriginalSize = stats['totalOriginalSize'] as int? ?? 0;
    final totalCompressedSize = stats['totalCompressedSize'] as int? ?? 0;
    final avgCompressionRatio = stats['avgCompressionRatio'] as double? ?? 0.0;
    final compressedCount = stats['compressedCount'] as int? ?? 0;
    final cloudUploadedCount = stats['cloudUploadedCount'] as int? ?? 0;

    final spaceSaved = totalOriginalSize - totalCompressedSize;
    final spaceSavedPercentage = totalOriginalSize > 0 ? (spaceSaved / totalOriginalSize) * 100 : 0.0;

    return Column(
      children: [
        // Storage metrics
        _buildStorageMetrics(
          totalImages: totalImages,
          totalOriginalSize: totalOriginalSize,
          totalCompressedSize: totalCompressedSize,
          spaceSaved: spaceSaved,
          spaceSavedPercentage: spaceSavedPercentage,
        ),
        const SizedBox(height: 16),
        // Compression statistics
        _buildCompressionStats(
          compressedCount: compressedCount,
          totalImages: totalImages,
          avgCompressionRatio: avgCompressionRatio,
        ),
        const SizedBox(height: 16),
        // Cloud storage statistics
        _buildCloudStats(
          cloudUploadedCount: cloudUploadedCount,
          totalImages: totalImages,
        ),
        const SizedBox(height: 16),
        // Optimization suggestions
        _buildOptimizationSuggestions(
          totalImages: totalImages,
          compressedCount: compressedCount,
          cloudUploadedCount: cloudUploadedCount,
        ),
      ],
    );
  }

  Widget _buildStorageMetrics({
    required int totalImages,
    required int totalOriginalSize,
    required int totalCompressedSize,
    required int spaceSaved,
    required double spaceSavedPercentage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Storage Metrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _buildMetricRow('Total Images', totalImages.toString()),
        _buildMetricRow('Original Size', _formatBytes(totalOriginalSize)),
        _buildMetricRow('Compressed Size', _formatBytes(totalCompressedSize)),
        _buildMetricRow('Space Saved', '${_formatBytes(spaceSaved)} (${spaceSavedPercentage.toStringAsFixed(1)}%)'),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: spaceSavedPercentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
        ),
        const SizedBox(height: 4),
        Text('Storage Optimization: ${spaceSavedPercentage.toStringAsFixed(1)}%', 
             style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
      ],
    );
  }

  Widget _buildCompressionStats({
    required int compressedCount,
    required int totalImages,
    required double avgCompressionRatio,
  }) {
    final compressionPercentage = totalImages > 0 ? (compressedCount / totalImages) * 100 : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Compression Statistics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _buildMetricRow('Compressed Images', '$compressedCount / $totalImages'),
        _buildMetricRow('Compression Rate', '${compressionPercentage.toStringAsFixed(1)}%'),
        _buildMetricRow('Avg Compression Ratio', '${(avgCompressionRatio * 100).toStringAsFixed(1)}%'),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: compressionPercentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text('Compression Progress: ${compressionPercentage.toStringAsFixed(1)}%', 
             style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
      ],
    );
  }

  Widget _buildCloudStats({
    required int cloudUploadedCount,
    required int totalImages,
  }) {
    final cloudPercentage = totalImages > 0 ? (cloudUploadedCount / totalImages) * 100 : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cloud Storage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _buildMetricRow('Cloud Uploaded', '$cloudUploadedCount / $totalImages'),
        _buildMetricRow('Cloud Rate', '${cloudPercentage.toStringAsFixed(1)}%'),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: cloudPercentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
        ),
        const SizedBox(height: 4),
        Text('Cloud Sync Progress: ${cloudPercentage.toStringAsFixed(1)}%', 
             style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
      ],
    );
  }

  Widget _buildOptimizationSuggestions({
    required int totalImages,
    required int compressedCount,
    required int cloudUploadedCount,
  }) {
    List<String> suggestions = [];
    
    if (totalImages == 0) {
      suggestions.add('No images uploaded yet');
    } else {
      if (compressedCount < totalImages) {
        suggestions.add('${totalImages - compressedCount} images pending compression');
      }
      if (cloudUploadedCount < totalImages) {
        suggestions.add('${totalImages - cloudUploadedCount} images pending cloud upload');
      }
      if (compressedCount == totalImages && cloudUploadedCount == totalImages) {
        suggestions.add('All images optimized and synced');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Optimization Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...suggestions.map((suggestion) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Icon(
                suggestion.contains('pending') ? Icons.schedule : 
                suggestion.contains('optimized') ? Icons.check_circle : Icons.info,
                color: suggestion.contains('pending') ? Colors.orange :
                       suggestion.contains('optimized') ? AppColors.success : AppColors.info,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(suggestion, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
