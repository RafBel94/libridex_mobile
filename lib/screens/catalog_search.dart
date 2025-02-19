import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:libridex_mobile/domain/models/book.dart';

class CatalogSearchScreen extends StatefulWidget {
  const CatalogSearchScreen({super.key});

  @override
  _CatalogSearchScreenState createState() => _CatalogSearchScreenState();
}

class _CatalogSearchScreenState extends State<CatalogSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Results'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                        context.read<BookProvider>().fetchBooksWithFilters(
                          null, null, null, null, null, _searchController.text);
                      });
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

                  List<Book> books = bookProvider.filteredBooks;

                  if (books.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            book.image,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/defaultbook.png');
                            },
                          ),
                          title: Text(
                            book.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.author),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                book.genre,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${book.publishingDate.day}/${book.publishingDate.month}/${book.publishingDate.year}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
