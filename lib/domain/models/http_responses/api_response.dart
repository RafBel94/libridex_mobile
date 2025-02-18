class ApiResponse {
  final dynamic data;
  ApiResponse({required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: json['data'],
    );
  }
}