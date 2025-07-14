class BaseResponse<T> {
  final T? data;
  final String? message;
  final int statusCode;
  final String? code;

  BaseResponse({
    this.data,
    this.message,
    required this.statusCode,
    this.code,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return BaseResponse<T>(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
      statusCode: json['statusCode'],
      code: json['code'],
    );
  }
}
