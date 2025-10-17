import 'package:flutter/material.dart';
import '../models/client_model.dart';
import 'database_service.dart';

class ClientProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Client> _clients = [];
  bool _isLoading = false;
  String? _error;

  ClientProvider(this._databaseService);

  // Getters
  List<Client> get clients => _clients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all clients
  Future<void> loadClients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clients = await _databaseService.getAllClients();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add client
  Future<void> addClient(Client client) async {
    try {
      await _databaseService.insertClient(client);
      await loadClients();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update client
  Future<void> updateClient(Client client) async {
    try {
      await _databaseService.updateClient(client);
      await loadClients();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete client
  Future<void> deleteClient(int id) async {
    try {
      await _databaseService.deleteClient(id);
      await loadClients();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Search clients
  Future<void> searchClients(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        await loadClients();
      } else {
        _clients = await _databaseService.searchClients(query);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get client by ID
  Future<Client?> getClientById(int id) async {
    try {
      return await _databaseService.getClient(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
