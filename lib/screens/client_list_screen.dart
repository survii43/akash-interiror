import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_strings.dart';
import '../models/client_model.dart';
import '../services/client_provider.dart';
import '../widgets/common_list_screen.dart';
import '../widgets/common_cards.dart';
import '../widgets/common_dialogs.dart';
import '../utils/navigation_utils.dart';
import 'client_form_screen.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ClientProvider>().loadClients();
    });
  }

  void _navigateToForm({Client? client}) {
    NavigationUtils.push(
      context,
      ClientFormScreen(client: client),
    );
  }

  Future<void> _showDeleteDialog(Client client) async {
    final confirmed = await CommonDialogs.showDeleteDialog(
      context,
      title: AppStrings.deleteClient,
      message: AppStrings.deleteClientConfirm,
    );
    
    if (confirmed && mounted) {
      await context.read<ClientProvider>().deleteClient(client.id!);
      NavigationUtils.showSuccessSnackBar(
        context,
        AppStrings.clientDeletedSuccess,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, clientProvider, child) {
        return CommonListScreen<Client>(
          title: AppStrings.clientList,
          searchHint: AppStrings.search,
          emptyTitle: AppStrings.emptyClientsTitle,
          emptySubtitle: AppStrings.emptyClientsSubtitle,
          emptyIcon: Icons.people_outline,
          items: clientProvider.clients,
          isLoading: clientProvider.isLoading,
          onSearch: (query) {
            if (query.isEmpty) {
              clientProvider.loadClients();
            } else {
              clientProvider.searchClients(query);
            }
          },
          onRefresh: () => clientProvider.loadClients(),
          onAdd: () => _navigateToForm(),
          addButtonTooltip: AppStrings.addClient,
          itemBuilder: (client, index) => _buildClientCard(client),
        );
      },
    );
  }

  Widget _buildClientCard(Client client) {
    return ListTileCard(
      title: client.name,
      subtitle: client.email,
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: const Text(AppStrings.edit),
            onTap: () => _navigateToForm(client: client),
          ),
          PopupMenuItem(
            child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
            onTap: () => _showDeleteDialog(client),
          ),
        ],
      ),
      onTap: () => _navigateToForm(client: client),
    );
  }
}
