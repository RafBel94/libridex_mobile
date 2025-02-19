import 'dart:async';

import 'package:flutter/material.dart';
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:provider/provider.dart';

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
          _beforePublishingDate?.toIso8601String(),
          _afterPublishingDate?.toIso8601String(),
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

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height * 0.15;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Search Results'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  color: Colors.brown,
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.brown,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Genres',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        child: SingleChildScrollView(
                          child: FilterChipWidget(
                            label: 'Genres',
                            selectedItems: _selectedGenres,
                            onSelectedItemsChanged: (selectedItems) {
                              setState(() {
                                _selectedGenres = selectedItems;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Authors',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        child: SingleChildScrollView(
                          child: FilterChipWidget(
                            label: 'Authors',
                            selectedItems: _selectedAuthors,
                            onSelectedItemsChanged: (selectedItems) {
                              setState(() {
                                _selectedAuthors = selectedItems;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Sort By',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          DropdownButton<String>(
                            hint: const Text('Field'),
                            value: _selectedSortField,
                            isExpanded: false,
                            items: const [
                              DropdownMenuItem(
                                  value: 'title', child: Text('Title')),
                              DropdownMenuItem(
                                  value: 'author', child: Text('Author')),
                              DropdownMenuItem(
                                  value: 'genre', child: Text('Genre')),
                              DropdownMenuItem(
                                  value: 'publishingDate',
                                  child: Text('Publishing Date')),
                              DropdownMenuItem(
                                  value: 'createdAt',
                                  child: Text('Created At')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedSortField = value;
                              });
                            },
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: DropdownButton<String>(
                              hint: const Text('Order'),
                              value: _selectedSortOrder,
                              isExpanded: false,
                              items: const [
                                DropdownMenuItem(
                                    value: 'asc', child: Text('Asc.')),
                                DropdownMenuItem(
                                    value: 'desc', child: Text('Desc.')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedSortOrder = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Text(_beforePublishingDate == null
                              ? 'YYYY/MM/DD'
                              : _beforePublishingDate!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]),
                          const SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _beforePublishingDate = pickedDate.toLocal();
                                });
                              }
                            },
                            child: const Text('Published Before...'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Text(_afterPublishingDate == null
                              ? 'YYYY/MM/DD'
                              : _afterPublishingDate!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]),
                          const SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _afterPublishingDate = pickedDate.toLocal();
                                });
                              }
                            },
                            child: const Text('Published After...'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    FocusScope.of(context).unfocus();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.brown,
                  ),
                  child: const Text('Apply Filters'),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _resetFilters,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.brown,
                  ),
                  child: const Text('Reset Filters'),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
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
                    onPressed: _applyFilters,
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
    final bookProvider = context.read<BookProvider>();
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
