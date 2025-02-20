import 'dart:async';

import 'package:flutter/material.dart';
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:libridex_mobile/providers/user_provider.dart';
import 'package:libridex_mobile/screens/book_screen.dart';
import 'package:libridex_mobile/screens/login_screen.dart';
import 'package:libridex_mobile/widgets/admin_list_tile.dart';
import 'package:libridex_mobile/widgets/catalog_drawer.dart';
import 'package:libridex_mobile/widgets/normal_user_list_tile.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
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

                      if (userProvider.currentUser!.role! == 'ROLE_USER') {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBookScreen(book: book, editMode: false),
                              ),
                            );
                          },
                          child: NormalUserListTile(book: book),
                        );
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
