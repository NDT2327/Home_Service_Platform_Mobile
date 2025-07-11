class Account {
  final int accountId;
  final String email;
  final String password;
  final String fullName;
  final String avatar;
  final String address;
  final String phone;
  final int roleId;
  final int statusId;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? createdBy;
  final String? updatedBy;

  Account({
    required this.accountId,
    required this.email,
    required this.password,
    required this.fullName,
    required this.avatar,
    required this.address,
    required this.phone,
    required this.roleId,
    required this.statusId,
    this.createdDate,
    this.updatedDate,
    this.createdBy,
    this.updatedBy,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      accountId: map['accountId'],
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      fullName: map['fullName'] ?? '',
      avatar: map['avatar'],
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      roleId: map['roleId'] ?? 0,
      statusId: map['statusId'] ?? 0,
      createdDate: _parseDate(map['createdDate']),
      updatedDate: _parseDate(map['updatedDate']),
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value == '') return null;
    return DateTime.tryParse(value.toString());
  }

    Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'email': email,
      'password': password,
      'fullName': fullName,
      'avatar': avatar,
      'address': address,
      'phone': phone,
      'roleId': roleId,
      'statusId': statusId,
    };
  }
}
