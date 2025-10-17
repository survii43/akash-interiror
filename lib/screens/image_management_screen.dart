import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/image_compression_service.dart';
import '../widgets/image_analytics_dashboard.dart';
import '../config/app_colors.dart';

class ImageManagementScreen extends StatefulWidget {
  const ImageManagementScreen({super.key});

  @override
  _ImageManagementScreenState createState() => _ImageManagementScreenState();
}

class _ImageManagementScreenState extends State<ImageManagementScreen>
    with TickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();
  late TabController _tabController;
  final bool _isCompressionRunning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startBackgroundCompression();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startBackgroundCompression() {
    final compressionService = ImageCompressionService(_databaseService);
    compressionService.startBackgroundCompression();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.image), text: 'All Images'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnalyticsTab(),
          _buildAllImagesTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ImageAnalyticsDashboard(),
          const SizedBox(height: 16),
          _buildCompressionStatusCard(),
          const SizedBox(height: 16),
          _buildStorageOptimizationCard(),
        ],
      ),
    );
  }

  Widget _buildAllImagesTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _databaseService.getImagesByStatus('all'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                const Text('Failed to load images'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final images = snapshot.data ?? [];
        if (images.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported, color: AppColors.grey400, size: 48),
                SizedBox(height: 16),
                Text('No images found'),
                SizedBox(height: 8),
                Text('Upload images to see them here', 
                     style: TextStyle(color: AppColors.grey500)),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _buildImageCard(images[index]);
          },
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Compression Settings', 
                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildSettingRow('Max Image Size', '450x450 pixels'),
                  _buildSettingRow('Compression Quality', '85%'),
                  _buildSettingRow('Thumbnail Size', '200x200 pixels'),
                  _buildSettingRow('Background Processing', 'Enabled'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Storage Management', 
                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    'Clean Up Old Images',
                    'Remove images older than 6 months',
                    Icons.cleaning_services,
                    () => _cleanupOldImages(),
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    'Optimize Storage',
                    'Recompress all images for better storage',
                    Icons.storage,
                    () => _optimizeStorage(),
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    'Export Analytics',
                    'Export storage and compression statistics',
                    Icons.download,
                    () => _exportAnalytics(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompressionStatusCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Compression Status', 
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.compress, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _databaseService.getPendingCompressions(),
              builder: (context, snapshot) {
                final pendingCount = snapshot.data?.length ?? 0;
                return Column(
                  children: [
                    _buildStatusRow('Pending Compression', pendingCount.toString()),
                    _buildStatusRow('Background Processing', _isCompressionRunning ? 'Active' : 'Idle'),
                    const SizedBox(height: 12),
                    if (pendingCount > 0)
                      LinearProgressIndicator(
                        value: 0.5, // This would be calculated based on actual progress
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageOptimizationCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Storage Optimization', 
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.tune, color: AppColors.success),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: _databaseService.getImageStats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stats = snapshot.data!;
                final totalOriginalSize = stats['totalOriginalSize'] as int? ?? 0;
                final totalCompressedSize = stats['totalCompressedSize'] as int? ?? 0;
                final spaceSaved = totalOriginalSize - totalCompressedSize;
                final spaceSavedPercentage = totalOriginalSize > 0 
                    ? (spaceSaved / totalOriginalSize) * 100 : 0.0;

                return Column(
                  children: [
                    _buildStatusRow('Space Saved', _formatBytes(spaceSaved)),
                    _buildStatusRow('Optimization Rate', '${spaceSavedPercentage.toStringAsFixed(1)}%'),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: spaceSavedPercentage / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(Map<String, dynamic> image) {
    return Card(
      child: InkWell(
        onTap: () => _showImageDetails(image),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Icon(Icons.image, color: Colors.grey[400]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    image['originalFileName'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildImageStatusChip(image),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageStatusChip(Map<String, dynamic> image) {
    String status = image['compressionStatus'] ?? 'unknown';
    Color color;
    IconData icon;

    switch (status) {
      case 'completed':
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case 'pending':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case 'processing':
        color = AppColors.primary;
        icon = Icons.sync;
        break;
      case 'failed':
        color = AppColors.error;
        icon = Icons.error;
        break;
      default:
        color = AppColors.grey500;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }

  void _showImageDetails(Map<String, dynamic> image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File: ${image['originalFileName']}'),
            Text('Size: ${_formatBytes(image['originalSize'] ?? 0)}'),
            Text('Status: ${image['compressionStatus']}'),
            if (image['compressionRatio'] != null)
              Text('Compression: ${(image['compressionRatio'] * 100).toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _cleanupOldImages() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cleanup functionality not implemented')),
    );
  }

  void _optimizeStorage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Optimization functionality not implemented')),
    );
  }

  void _exportAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality not implemented')),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
