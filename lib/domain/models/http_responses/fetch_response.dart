class FetchResponse {
  final bool success;
  final List<dynamic> data;
  final List<dynamic> message;

  FetchResponse({required this.success, required this.data, required this.message});

  factory FetchResponse.fromJson(Map<String, dynamic> json) {
    return FetchResponse(
      success: json['success'],
      data: json['data'],
      message: json['message'],
    );
  }
}