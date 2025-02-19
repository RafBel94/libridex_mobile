import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/domain/models/http_responses/fetch_response.dart';
import 'package:libridex_mobile/services/token_service.dart';

class BookService {
  final String baseString = "https://libridex-api-8ym32.ondigitalocean.app/api/books";
  final TokenService tokenService;

  BookService(this.tokenService);

  // Fetch books endpoint
  Future<FetchResponse> fetchBooks() async {
    final endpoint = baseString;
    final token = await tokenService.getToken();
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }

  // Search books with filters endpoint
  Future<FetchResponse> fetchBooksWithFilters(String? genres, String? authors, String? sortBy, String? beforePublishingDate, String? afterPublishingDate, String? query) async {
    final queryParams = <String, String?>{
      'genres': genres,
      'authors': authors,
      'sortBy': sortBy,
      'beforePublishingDate': beforePublishingDate,
      'afterPublishingDate': afterPublishingDate,
      'query': query,
    };

    final queryString = queryParams.entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty)
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');


    final endpoint = '$baseString/search?$queryString';
    final token = await tokenService.getToken();
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }

  // Add book endpoint
  Future<FetchResponse> addBook(Book book) async {
    final endpoint = baseString;
    final token = await tokenService.getToken();
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(book.toJson()),
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }

  // Delete book endpoint
  Future<FetchResponse> deleteBook(int id) async {
    final endpoint = '$baseString/$id';
    final token = await tokenService.getToken();
    final response = await http.delete(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }

  // Update book endpoint
  Future<FetchResponse> updateBook(Book book) async {
    final endpoint = '$baseString/${book.id}';
    final token = await tokenService.getToken();
    final response = await http.put(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(book.toJson()),
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }
}
