import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:libridex_mobile/providers/user_provider.dart';
import 'package:libridex_mobile/screens/catalog_search.dart';
import 'package:libridex_mobile/screens/login_screen.dart';
import 'package:libridex_mobile/domain/models/book.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookProvider>().fetchBooks();
  }

  void _logout(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.logoutUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catalog'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  _logout(context);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a book...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CatalogSearchScreen()),
                      );
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

                  List<Book> books = bookProvider.books;

                  if (books.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Card(
                        child: Column(
                          children: [
                            Image.network(
                              book.image,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/defaultbook.png');
                              },
                            ),
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
      ),
    );
  }
}