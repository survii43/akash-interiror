import 'package:flutter/material.dart';
import '../utils/ui_utils.dart';
import '../utils/responsive_utils.dart';
import 'responsive_components.dart';

/// Generic list screen template to eliminate duplication
class CommonListScreen<T> extends StatefulWidget {
  final String title;
  final String searchHint;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final List<T> items;
  final bool isLoading;
  final String? error;
  final Widget Function(T item, int index) itemBuilder;
  final void Function(String query) onSearch;
  final VoidCallback? onRefresh;
  final VoidCallback? onAdd;
  final String? addButtonTooltip;

  const CommonListScreen({
    super.key,
    required this.title,
    required this.searchHint,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    required this.items,
    required this.isLoading,
    required this.itemBuilder,
    required this.onSearch,
    this.error,
    this.onRefresh,
    this.onAdd,
    this.addButtonTooltip,
  });

  @override
  State<CommonListScreen<T>> createState() => _CommonListScreenState<T>();
}

class _CommonListScreenState<T> extends State<CommonListScreen<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveComponents.responsiveAppBar(
        context: context,
        title: widget.title,
        actions: widget.onRefresh != null
            ? [
                IconButton(
                  icon: ResponsiveComponents.responsiveIcon(context, Icons.refresh),
                  onPressed: widget.onRefresh,
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: widget.onAdd != null
          ? FloatingActionButton(
              onPressed: widget.onAdd,
              tooltip: widget.addButtonTooltip ?? 'Add',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: ResponsiveUtils.responsivePadding(context),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          prefixIcon: ResponsiveComponents.responsiveIcon(context, Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: ResponsiveComponents.responsiveIcon(context, Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearch('');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {});
          widget.onSearch(value);
        },
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return UIUtils.buildLoadingWidget(message: 'Loading...');
    }

    if (widget.error != null) {
      return UIUtils.buildErrorState(
        message: widget.error!,
        onRetry: widget.onRefresh,
      );
    }

    if (widget.items.isEmpty) {
      return UIUtils.buildEmptyState(
        title: widget.emptyTitle,
        subtitle: widget.emptySubtitle,
        icon: widget.emptyIcon,
        action: widget.onAdd != null
            ? ElevatedButton(
                onPressed: widget.onAdd,
                child: const Text('Add New'),
              )
            : null,
      );
    }

    return ListView.builder(
      itemCount: widget.items.length,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.responsiveSpacing(context),
        vertical: ResponsiveUtils.responsiveSpacing(context) * 0.5,
      ),
      itemBuilder: (context, index) {
        return widget.itemBuilder(widget.items[index], index);
      },
    );
  }
}

/// Generic search bar widget
class CommonSearchBar extends StatefulWidget {
  final String hintText;
  final void Function(String query) onChanged;
  final VoidCallback? onClear;

  const CommonSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onClear,
  });

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    widget.onClear?.call();
                  },
                )
              : null,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

/// Generic empty state widget
class CommonEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? action;

  const CommonEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return UIUtils.buildEmptyState(
      title: title,
      subtitle: subtitle,
      icon: icon,
      action: action,
    );
  }
}

/// Generic loading state widget
class CommonLoadingState extends StatelessWidget {
  final String message;

  const CommonLoadingState({
    super.key,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return UIUtils.buildLoadingWidget(message: message);
  }
}

/// Generic error state widget
class CommonErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CommonErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return UIUtils.buildErrorState(
      message: message,
      onRetry: onRetry,
    );
  }
}
