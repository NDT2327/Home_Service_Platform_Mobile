class UpdateAccountRequest {
  final String? address;
  final String? phone;
  final String? avatar;
  final String? fullName;
  final int? roleId;
  final int? statusId;

  UpdateAccountRequest({
    this.address,
    this.phone,
    this.avatar,
    this.fullName,
    this.roleId,
    this.statusId,
  });

  factory UpdateAccountRequest.fromJson(Map<String, dynamic> json) {
    return UpdateAccountRequest(
      fullName: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      roleId: json['roleId'] ?? 2,
      statusId: json['statusId'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'avatar': avatar,
      'address': address,
      'phone': phone,
      'roleId': roleId,
      'statusId': statusId,
    };
  }
}
