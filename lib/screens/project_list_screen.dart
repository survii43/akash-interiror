import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_strings.dart';
import '../models/project_model.dart';
import '../services/client_provider.dart';
import '../services/project_provider.dart';
import '../widgets/common_list_screen.dart';
import '../widgets/common_cards.dart';
import '../widgets/common_dialogs.dart';
import '../utils/navigation_utils.dart';
import 'project_form_screen.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProjectProvider>().loadProjects();
    });
  }

  void _navigateToForm({Project? project}) {
    NavigationUtils.push(
      context,
      ProjectFormScreen(project: project),
    );
  }

  Future<void> _showDeleteDialog(Project project) async {
    final confirmed = await CommonDialogs.showDeleteDialog(
      context,
      title: AppStrings.deleteProject,
      message: AppStrings.deleteProjectConfirm,
    );
    
    if (confirmed && mounted) {
      await context.read<ProjectProvider>().deleteProject(project.id!);
      NavigationUtils.showSuccessSnackBar(
        context,
        AppStrings.projectDeletedSuccess,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProjectProvider, ClientProvider>(
      builder: (context, projectProvider, clientProvider, child) {
        return CommonListScreen<Project>(
          title: AppStrings.projectList,
          searchHint: AppStrings.search,
          emptyTitle: AppStrings.emptyProjectsTitle,
          emptySubtitle: AppStrings.emptyProjectsSubtitle,
          emptyIcon: Icons.work_outline,
          items: projectProvider.projects,
          isLoading: projectProvider.isLoading,
          onSearch: (query) {
            if (query.isEmpty) {
              projectProvider.loadProjects();
            } else {
              projectProvider.searchProjects(query);
            }
          },
          onRefresh: () => projectProvider.loadProjects(),
          onAdd: () => _navigateToForm(),
          addButtonTooltip: AppStrings.addProject,
          itemBuilder: (project, index) => _buildProjectCard(project, clientProvider),
        );
      },
    );
  }

  Widget _buildProjectCard(Project project, ClientProvider clientProvider) {
    final client = clientProvider.clients
        .where((c) => c.id == project.clientId)
        .firstOrNull;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client?.name ?? 'Unknown Client',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(status: project.status),
            ],
          ),
          if (project.description != null && project.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              project.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.grey600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ActionButtonsCard(
            title: 'Actions',
            actions: [
              ActionButton(
                label: AppStrings.edit,
                icon: Icons.edit,
                onPressed: () => _navigateToForm(project: project),
                isOutlined: true,
              ),
              ActionButton(
                label: AppStrings.delete,
                icon: Icons.delete,
                onPressed: () => _showDeleteDialog(project),
                color: AppColors.error,
                isOutlined: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
