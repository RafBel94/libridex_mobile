import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:libridex_mobile/providers/user_provider.dart';
import 'package:libridex_mobile/screens/edit_book_screen.dart';
import 'package:libridex_mobile/screens/login_screen.dart';
import 'package:libridex_mobile/widgets/dialogs/show_delete_book_confirmation.dart';
import 'package:provider/provider.dart';
import 'package:libridex_mobile/widgets/catalog_drawer.dart';

class CatalogSearchScreen extends StatefulWidget {
  const CatalogSearchScreen({super.key});

  @override
  _CatalogSearchScreenState createState() => _CatalogSearchScreenState();
}

class _CatalogSearchScreenState extends State<CatalogSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _selectedSortField = 'title';
  String? _selectedSortOrder = 'asc';
  List<String> _selectedGenres = [];
  List<String> _selectedAuthors = [];
  DateTime? _beforePublishingDate;
  DateTime? _afterPublishingDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    context
        .read<BookProvider>()
        .fetchBooksWithFilters(null, null, null, null, null, null);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height * 0.15;
    final bookProvider = context.watch<BookProvider>();
    final userProvider = context.read<UserProvider>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,

        // Appbar
        appBar: AppBar(
            title: Center(
            child: Text(
                userProvider.currentUser!.role! == 'ROLE_USER' ? 'Catalog' : 'Admin Catalog',
                style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontSize: 24
                ),
              ),
            ),
          leading: context.read<UserProvider>().currentUser!.role! == 'ROLE_USER' ?
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
              : IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                icon: const Icon(Icons.logout)
              ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
            elevation: 4.0,
            shadowColor: Colors.black.withAlpha((0.5 * 255).toInt()),
            backgroundColor: Colors.white,
        ),

        // Drawer
        endDrawer: CatalogDrawer(
          maxHeight: maxHeight,
          selectedGenres: _selectedGenres,
          selectedAuthors: _selectedAuthors,
          selectedSortField: _selectedSortField,
          selectedSortOrder: _selectedSortOrder,
          beforePublishingDate: _beforePublishingDate,
          afterPublishingDate: _afterPublishingDate,
          onSelectedGenresChanged: (selectedItems) {
            setState(() {
              _selectedGenres = selectedItems;
            });
          },
          onSelectedAuthorsChanged: (selectedItems) {
            setState(() {
              _selectedAuthors = selectedItems;
            });
          },
          onSortFieldChanged: (value) {
            setState(() {
              _selectedSortField = value;
            });
          },
          onSortOrderChanged: (value) {
            setState(() {
              _selectedSortOrder = value;
            });
          },
          onBeforePublishingDateChanged: (pickedDate) {
            setState(() {
              _beforePublishingDate = pickedDate;
            });
          },
          onAfterPublishingDateChanged: (pickedDate) {
            setState(() {
              _afterPublishingDate = pickedDate;
            });
          },
          onApplyFilters: _applyFilters,
          onResetFilters: _resetFilters,
        ),

        // Scaffold body
        body: Column(
          children: [

            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a book...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _applyFilters,
                  ),
                ),
              ),
            ),

            // Book list
            Expanded(
              child: Builder(
                builder: (context) {
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

                      if (context.read<UserProvider>().currentUser!.role! == 'ROLE_USER') {
                        return AdminListTile(book: book);
                      }

                      return AdminListTile(book: book);
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

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      _applyFilters();
    });
  }

  void _applyFilters() {
    String? sortBy = _selectedSortField != null && _selectedSortOrder != null
        ? '${_selectedSortField}_$_selectedSortOrder'
        : null;
    context.read<BookProvider>().fetchBooksWithFilters(
          _selectedGenres.join(','),
          _selectedAuthors.join(','),
          sortBy,
          _beforePublishingDate?.toIso8601String().split('T')[0],
          _afterPublishingDate?.toIso8601String().split('T')[0],
          _searchController.text,
        );
  }

  void _resetFilters() {
    setState(() {
      _selectedSortField = 'title';
      _selectedSortOrder = 'asc';
      _selectedGenres = [];
      _selectedAuthors = [];
      _beforePublishingDate = null;
      _afterPublishingDate = null;
    });
    _applyFilters();
  }
}

// Normal user tiles
class NormalUserListTile extends StatelessWidget {
  const NormalUserListTile({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

// Admin tiles
class AdminListTile extends StatelessWidget {
  const AdminListTile({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: const Color.fromARGB(255, 103, 73, 33),
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
              backgroundColor: const Color.fromARGB(255, 35, 35, 35),
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
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final List<String> selectedItems;
  final Function(List<String>) onSelectedItemsChanged;

  const FilterChipWidget({
    required this.label,
    required this.selectedItems,
    required this.onSelectedItemsChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final items = label == 'Genres'
        ? bookProvider.books.map((book) => book.genre).toSet().toList()
        : bookProvider.books.map((book) => book.author).toSet().toList();

    return Wrap(
      spacing: 8.0,
      children: items.map((item) {
        return FilterChip(
          label: Text(item),
          selected: selectedItems.contains(item),
          onSelected: (isSelected) {
            List<String> updatedItems = List.from(selectedItems);
            if (isSelected) {
              updatedItems.add(item);
            } else {
              updatedItems.remove(item);
            }
            onSelectedItemsChanged(updatedItems);
          },
        );
      }).toList(),
    );
  }
}
