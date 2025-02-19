// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:libridex_mobile/screens/edit_book_screen.dart';
import 'package:libridex_mobile/widgets/dialogs/show_delete_book_confirmation.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookProvider>().fetchBooks();
    context
        .read<BookProvider>()
        .fetchBooksWithFilters(null, null, null, null, null, null);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    final List<Book> books = context.watch<BookProvider>().filteredBooks;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Admin Panel',
            style: TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        backgroundColor: Colors.white,
        elevation: 10.0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, bookProvider, child) {
                if (bookProvider.errorMessage != null) {
                  return Center(child: Text(bookProvider.errorMessage!));
                }

                if (books.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SlidableAutoCloseBehavior(
                  closeWhenOpened:true,
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Card(
                        child: Slidable(
                          key: ValueKey(book.id),
                          closeOnScroll: true,
                          dragStartBehavior: DragStartBehavior.start,
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditBookScreen(book: book)));
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 103, 73, 33),
                                foregroundColor: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                autoClose: true,
                                icon: Icons.edit,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  showDeleteBookConfirmation(context, book);
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 35, 35, 35),
                                foregroundColor: Colors.white,
                                autoClose: true,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Image.network(
                              book.image,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/images/defaultbook.png');
                              },
                            ),
                            title: Text(
                              book.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
