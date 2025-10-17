import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_strings.dart';
import '../models/client_model.dart';
import '../services/client_provider.dart';
import '../widgets/common_form_field.dart';
import '../utils/validation_utils.dart';
import '../utils/ui_utils.dart';

class ClientFormScreen extends StatefulWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _companyController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _addressController = TextEditingController(text: widget.client?.address ?? '');
    _companyController = TextEditingController(text: widget.client?.company ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _companyController.dispose();
    super.dispose();
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final client = Client(
        id: widget.client?.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        company: _companyController.text.trim(),
        createdAt: widget.client?.createdAt,
      );

      try {
        if (widget.client == null) {
          await context.read<ClientProvider>().addClient(client);
          if (mounted) {
            UIUtils.showSuccessSnackBar(context, AppStrings.clientAddedSuccess);
            Navigator.pop(context);
          }
        } else {
          await context.read<ClientProvider>().updateClient(client);
          if (mounted) {
            UIUtils.showSuccessSnackBar(context, AppStrings.clientUpdatedSuccess);
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          UIUtils.showErrorSnackBar(context, 'Error: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.client != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? AppStrings.editClient : AppStrings.addClient),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              CommonFormField(
                label: AppStrings.clientName,
                hintText: 'Enter full name',
                controller: _nameController,
                validator: ValidationUtils.validateName,
              ),

              // Email Field
              CommonFormField(
                label: AppStrings.clientEmail,
                hintText: 'Enter email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: ValidationUtils.validateEmail,
              ),

              // Phone Field
              CommonFormField(
                label: AppStrings.clientPhone,
                hintText: 'Enter phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: ValidationUtils.validatePhone,
              ),

              // Address Field
              CommonFormField(
                label: AppStrings.clientAddress,
                hintText: 'Enter address',
                controller: _addressController,
                maxLines: 2,
              ),

              // Company Field
              CommonFormField(
                label: AppStrings.clientCompany,
                hintText: 'Enter company name',
                controller: _companyController,
              ),

              const SizedBox(height: 12),

              // Buttons
              FormButtonRow(
                cancelText: AppStrings.cancel,
                submitText: isEditMode ? AppStrings.edit : AppStrings.add,
                onCancel: () => Navigator.pop(context),
                onSubmit: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
