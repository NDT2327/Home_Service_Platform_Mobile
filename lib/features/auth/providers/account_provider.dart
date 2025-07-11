import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/services/account_service.dart';

class AccountProvider extends ChangeNotifier {
  final AccountService _accountService = AccountService();
  List<Account> accounts = [];
  bool isLoading = false;
  String? errorMessage;

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
    await _accountService.createAccount(account);
    //await fetchAccounts();
  }

  // Future<void> updateAccount(Account account) async {
  //   await _accountService.updateAccount(account);
  //   await fetchAccounts();
  // }

  // Future<void> deleteAccount(int id) async {
  //   await _accountService.deleteAccount(id);
  //   await fetchAccounts();
  // }
}
