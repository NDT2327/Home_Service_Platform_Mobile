import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/models/dtos/request/update_account_request.dart';
import 'package:hsp_mobile/core/services/account_service.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';

class AccountProvider extends ChangeNotifier {
  final AccountService _accountService = AccountService();
  Account? _currentAccount;
  List<Account> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;
  int? _accountId;

  // Getters
  Account? get currentAccount => _currentAccount;
  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get accountId => _accountId;

  AccountProvider() {
    _initialize();
  }

  // Thiết lập trạng thái loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Xóa thông báo lỗi
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Khởi tạo: Lấy accountId từ SharedPreferences và tải thông tin tài khoản
  Future<void> _initialize() async {
    _accountId = await SharedPrefsUtils.getAccountId();
    if (_accountId != null) {
      await fetchAccountById(_accountId!);
    }
    notifyListeners();
  }

  // Future<void> fetchAccounts() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     accounts = await _accountService.getAllAccounts();
  //     errorMessage = null;
  //   } catch (e) {
  //     errorMessage = e.toString();
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

  Future<void> addAccount(Account account) async {
    _setLoading(true);
    final response = await _accountService.createAccount(account);
    //no error
    if (response.message != null && response.statusCode != 500) {
      _currentAccount = response.data;
      _errorMessage = null;
    } else {
      _errorMessage = response.message ?? 'Failed to create account';
    }
    _setLoading(false);
    notifyListeners();
  }

  Future<bool> updateAccount(
    int accountId,
    UpdateAccountRequest request,
  ) async {
    _setLoading(true);
    final response = await _accountService.updateAccount(accountId, request);
    if (response.message != null && response.statusCode != 500) {
      _currentAccount = response.data;
      _errorMessage = null;
      return true;
    } else {
      _errorMessage = response.message ?? "Falied to update account";
    }
    _setLoading(false);
    notifyListeners();
    return false;
  }

  //Fetch account by id
  Future<void> fetchAccountById(int id) async {
    _setLoading(true);
    final response = await _accountService.getAccountById(id);
    if (response.statusCode != 500 && response.data != null) {
      _currentAccount = response.data;
      print(_currentAccount);
      _errorMessage = null;
    } else {
      _errorMessage = response.message ?? 'Failed to fetch account';
    }
    _setLoading(false);
    notifyListeners();
  }

  // Future<void> deleteAccount(int id) async {
  //   await _accountService.deleteAccount(id);
  //   await fetchAccounts();
  // }

  //load current account
  Future<void> loadCurrentAccount() async {
    final accountId = await SharedPrefsUtils.getAccountId();
    if (accountId == null) {
      return;
    }

    try {
      final response = await _accountService.getAccountById(accountId);
      _currentAccount = response.data;
      notifyListeners();
    } catch (e) {
      print("Error loading account: $e");
    }
  }

  //Logout
  Future<void> logout() async {
    _currentAccount = null;
    _accountId = null;
    _accounts = [];
    _errorMessage = null;
    await SharedPrefsUtils.clearSession();
    notifyListeners();
  }
}
