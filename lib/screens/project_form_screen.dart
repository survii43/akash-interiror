import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../config/app_strings.dart';
import '../models/project_model.dart';
import '../services/client_provider.dart';
import '../services/project_provider.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/common_form_field.dart';
import '../utils/validation_utils.dart';
import '../utils/ui_utils.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;

  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _budgetController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  final _formKey = GlobalKey<FormState>();

  int? _selectedClientId;
  String _selectedStatus = 'Active';
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  final List<String> _statuses = [
    'Active',
    'Pending',
    'Completed',
    'On Hold',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.project?.description ?? '');
    _budgetController =
        TextEditingController(text: widget.project?.budget?.toString() ?? '');
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();

    _selectedClientId = widget.project?.clientId;
    _selectedStatus = widget.project?.status ?? 'Active';
    _selectedStartDate = widget.project?.startDate;
    _selectedEndDate = widget.project?.endDate;

    if (_selectedStartDate != null) {
      _startDateController.text =
          DateFormat('yyyy-MM-dd').format(_selectedStartDate!);
    }
    if (_selectedEndDate != null) {
      _endDateController.text = DateFormat('yyyy-MM-dd').format(_selectedEndDate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
        onDateSelected(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedClientId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.clientRequired)),
        );
        return;
      }

      final project = Project(
        id: widget.project?.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        clientId: _selectedClientId!,
        status: _selectedStatus,
        startDate: _selectedStartDate,
        endDate: _selectedEndDate,
        budget: _budgetController.text.isNotEmpty
            ? double.tryParse(_budgetController.text)
            : null,
        createdAt: widget.project?.createdAt,
      );

      try {
        if (widget.project == null) {
          await context.read<ProjectProvider>().addProject(project);
          if (mounted) {
            UIUtils.showSuccessSnackBar(context, AppStrings.projectAddedSuccess);
            Navigator.pop(context);
          }
        } else {
          await context.read<ProjectProvider>().updateProject(project);
          if (mounted) {
            UIUtils.showSuccessSnackBar(context, AppStrings.projectUpdatedSuccess);
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
    final isEditMode = widget.project != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? AppStrings.editProject : AppStrings.addProject),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Name Field
              CommonFormField(
                label: AppStrings.projectName,
                hintText: 'Enter project name',
                controller: _nameController,
                validator: ValidationUtils.validateName,
              ),

              // Client Selection
              Consumer<ClientProvider>(
                builder: (context, clientProvider, child) {
                  return CommonDropdownField<int>(
                    label: AppStrings.projectClient,
                    value: _selectedClientId,
                    hintText: 'Select a client',
                    items: clientProvider.clients
                        .map((client) => DropdownMenuItem(
                              value: client.id,
                              child: Text(client.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClientId = value;
                      });
                    },
                    validator: ValidationUtils.validateClient,
                  );
                },
              ),

              // Status Field
              CommonDropdownField<String>(
                label: AppStrings.projectStatus,
                value: _selectedStatus,
                hintText: 'Select status',
                items: _statuses
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              ),

              // Description Field
              CommonFormField(
                label: AppStrings.projectDescription,
                hintText: 'Enter project description',
                controller: _descriptionController,
                maxLines: 3,
              ),

              // Start Date
              CommonFormField(
                label: AppStrings.projectStartDate,
                hintText: 'Select start date',
                controller: _startDateController,
                readOnly: true,
                suffixIcon: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(
                  context,
                  _startDateController,
                  (date) {
                    _selectedStartDate = date;
                  },
                ),
              ),

              // End Date
              CommonFormField(
                label: AppStrings.projectEndDate,
                hintText: 'Select end date',
                controller: _endDateController,
                readOnly: true,
                suffixIcon: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(
                  context,
                  _endDateController,
                  (date) {
                    _selectedEndDate = date;
                  },
                ),
              ),

              // Budget Field
              CommonFormField(
                label: AppStrings.projectBudget,
                hintText: 'Enter budget amount',
                controller: _budgetController,
                keyboardType: TextInputType.number,
                prefixText: '\$ ',
                validator: ValidationUtils.validateBudget,
              ),

              const SizedBox(height: 12),

              // Image Upload Section (only show if project exists)
              if (isEditMode && _selectedClientId != null) ...[
                const Text(
                  'Project Images',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ImageUploadGrid(
                  projectId: widget.project!.id!,
                  clientId: _selectedClientId!,
                  maxImages: 10,
                  onImagesChanged: (imageIds) {
                    // Handle image changes if needed
                  },
                ),
                const SizedBox(height: 20),
              ],

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
