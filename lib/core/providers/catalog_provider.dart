import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/category.dart';
import 'package:hsp_mobile/core/models/service.dart';
import 'package:hsp_mobile/core/models/service_detail.dart';
import 'package:hsp_mobile/core/services/catalog_service.dart';

class CatalogProvider with ChangeNotifier {
  final CatalogService catalogService;

  CatalogProvider({required this.catalogService});

  // CATEGORIES
  List<Category> _categories = [];
  bool _isLoadingCategories = false;

  List<Category> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;

  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    notifyListeners();
    try {
      _categories = await catalogService.getAllCategories();
    } catch (e) {
      debugPrint("Error loading categories: $e");
      _categories = [];
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // SERVICES
  List<Service> _services = [];
  bool _isLoadingServices = false;

  List<Service> get services => _services;
  bool get isLoadingServices => _isLoadingServices;

  Future<void> loadServicesByCategory(int categoryId) async {
    _isLoadingServices = true;
    notifyListeners();
    try {
      _services = await catalogService.getServicesByCategoryId(categoryId);
    } catch (e) {
      debugPrint("Error loading services: $e");
      _services = [];
    } finally {
      _isLoadingServices = false;
      notifyListeners();
    }
  }

  Future<void> loadAllServices() async {
    _isLoadingServices = true;
    notifyListeners();
    try {
      _services = await catalogService.getAllServices();
    } catch (e) {
      debugPrint("Error loading all services: $e");
      _services = [];
    } finally {
      _isLoadingServices = false;
      notifyListeners();
    }
  }

  // SERVICE DETAILS
  List<ServiceDetail> _serviceDetails = [];
  bool _isLoadingServiceDetails = false;

  List<ServiceDetail> get serviceDetails => _serviceDetails;
  bool get isLoadingServiceDetails => _isLoadingServiceDetails;

  Future<void> loadServiceDetails(int serviceId) async {
    _isLoadingServiceDetails = true;
    notifyListeners();
    try {
      _serviceDetails = await catalogService.getServiceDetailsByServiceId(serviceId);
    } catch (e) {
      debugPrint("Error loading service details: $e");
      _serviceDetails = [];
    } finally {
      _isLoadingServiceDetails = false;
      notifyListeners();
    }
  }

  // SERVICE BY ID
  Service? _selectedService;
  bool _isLoadingSelectedService = false;

  Service? get selectedService => _selectedService;
  bool get isLoadingSelectedService => _isLoadingSelectedService;

  Future<void> loadServiceById(int serviceId) async {
    _isLoadingSelectedService = true;
    notifyListeners();
    try {
      _selectedService = await catalogService.getServiceById(serviceId);
    } catch (e) {
      debugPrint("Error loading service by ID: $e");
      _selectedService = null;
    } finally {
      _isLoadingSelectedService = false;
      notifyListeners();
    }
  }
}
