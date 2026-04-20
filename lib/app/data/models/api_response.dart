class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    // Handle different backend response formats (camelCase or PascalCase keys)
    bool success = json['success'] ?? json['Success'] ?? true;
    String message = json['message'] ?? json['Message'] ?? '';

    // If message contains "successful" or "OTP sent", treat as success
    if (message.toLowerCase().contains('successful') ||
        message.toLowerCase().contains('otp sent')) {
      success = true;
    }

    // Backend may return PascalCase ("Data") or camelCase ("data") depending on serializer config
    final rawData = json['data'] ?? json['Data'];

    return ApiResponse<T>(
      success: success,
      message: message,
      data: rawData != null && fromJsonT != null
          ? fromJsonT(rawData)
          : rawData as T?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data,
      };
}
