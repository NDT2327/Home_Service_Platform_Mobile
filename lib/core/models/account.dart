class Account {
  final int accountId;
  final String email;
  final String password;
  final String? fullName;
  final String? avatar;
  final String? address;
  final String? phone;
  final int roleId;
  final int statusId;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final int? createdBy;
  final int? updatedBy;

  Account({
    required this.accountId,
    required this.email,
    required this.password,
    this.fullName,
    this.avatar,
    this.address,
    this.phone,
    required this.roleId,
    required this.statusId,
    this.createdDate,
    this.updatedDate,
    this.createdBy,
    this.updatedBy,
  });

  // Factory method to create an Account instance from a map
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      accountId: map['accountId'],
      email: map['email'],
      password: map['password'],
      fullName: map['fullName'],
      avatar: map['avatar'],
      address: map['address'],
      phone: map['phone'],
      roleId: map['roleId'],
      statusId: map['statusId'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
    );
  }
}


  