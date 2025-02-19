import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:libridex_mobile/domain/models/book.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<BookProvider>().fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a book...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = _searchController.text.isNotEmpty;
                    });
                    context.read<BookProvider>().fetchBooksWithFilters(
                      null, null, null, null, null, _searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, bookProvider, child) {
                if (bookProvider.errorMessage != null) {
                  return Center(child: Text(bookProvider.errorMessage!));
                }

                List<Book> books = _isSearching ? bookProvider.filteredBooks : bookProvider.books;

                if (books.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return _isSearching
                    ? ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Card(
                            child: ListTile(
                              leading: Image.network(book.image),
                              title: Text(book.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Author: ${book.author}'),
                                  Text('Genre: ${book.genre}'),
                                  Text('Published: ${book.publishingDate.toLocal()}'),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Created At: ${book.createdAt.toLocal()}'),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Card(
                            child: Column(
                              children: [
                                Image.network(book.image),
                                Text(book.title),
                                Text(book.author),
                              ],
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}