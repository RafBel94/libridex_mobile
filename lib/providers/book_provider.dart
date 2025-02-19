import 'package:flutter/material.dart';
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/domain/models/http_responses/fetch_response.dart';
import 'package:libridex_mobile/services/book_service.dart';

class BookProvider extends ChangeNotifier {
  final BookService bookService;
  List<Book> books = [];
  List<Book> filteredBooks = [];
  String? errorMessage;

  BookProvider(this.bookService);

  // Fetch books
  Future<void> fetchBooks() async {
    if (books.isNotEmpty) {
      return;
    }
    try {
      FetchResponse response = await bookService.fetchBooks();
      if(response.success){
        books = response.data.map((book) => Book.fromFetchJson(book)).toList();
        errorMessage = null;
      } else {
        errorMessage = response.message[0];
      }
    } catch (error) {
      errorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  //Fetch books with filters (genres, authors, sortBy, beforePublishingDate, afterPublishingDate) and query, all as parameters
  Future<void> fetchBooksWithFilters(String? genres, String? authors, String? sortBy, String? beforePublishingDate, String? afterPublishingDate, String? query) async {
    try {
      FetchResponse response = await bookService.fetchBooksWithFilters(genres, authors, sortBy, beforePublishingDate, afterPublishingDate, query);
      if(response.success){
        filteredBooks = response.data.map((book) => Book.fromFetchJson(book)).toList();
        errorMessage = null;
      } else {
        errorMessage = response.message[0];
      }
    } catch (error) {
      errorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  // Delete book
  Future<void> deleteBook(int id) async {
    try {
      FetchResponse response = await bookService.deleteBook(id);
      if(response.success){
        books.removeWhere((book) => book.id == id);
        errorMessage = null;
      } else {
        errorMessage = response.message[0];
      }
    } catch (error) {
      errorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  // Update book
  Future<void> editBook(Book book) async {
    try {
      FetchResponse response = await bookService.updateBook(book);
      if(response.success){
        final index = books.indexWhere((element) => element.id == book.id);
        books[index] = book;
        errorMessage = null;
      } else {
        errorMessage = response.message[0];
      }
    } catch (error) {
      errorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }
}


