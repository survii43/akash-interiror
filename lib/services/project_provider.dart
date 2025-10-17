import 'package:flutter/material.dart';
import '../models/project_model.dart';
import 'database_service.dart';

class ProjectProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;

  ProjectProvider(this._databaseService);

  // Getters
  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all projects
  Future<void> loadProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _databaseService.getAllProjects();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load projects by client
  Future<void> loadProjectsByClient(int clientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _databaseService.getProjectsByClient(clientId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add project
  Future<void> addProject(Project project) async {
    try {
      await _databaseService.insertProject(project);
      await loadProjects();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update project
  Future<void> updateProject(Project project) async {
    try {
      await _databaseService.updateProject(project);
      await loadProjects();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete project
  Future<void> deleteProject(int id) async {
    try {
      await _databaseService.deleteProject(id);
      await loadProjects();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Search projects
  Future<void> searchProjects(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        await loadProjects();
      } else {
        _projects = await _databaseService.searchProjects(query);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get project by ID
  Future<Project?> getProjectById(int id) async {
    try {
      return await _databaseService.getProject(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
