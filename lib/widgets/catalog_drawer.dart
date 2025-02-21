import 'package:flutter/material.dart';
import 'package:libridex_mobile/screens/catalog_screen.dart';

class CatalogDrawer extends StatelessWidget {
  final double maxHeight;
  final List<String> selectedGenres;
  final List<String> selectedAuthors;
  final String? selectedSortField;
  final String? selectedSortOrder;
  final DateTime? beforePublishingDate;
  final DateTime? afterPublishingDate;
  final Function(List<String>) onSelectedGenresChanged;
  final Function(List<String>) onSelectedAuthorsChanged;
  final Function(String?) onSortFieldChanged;
  final Function(String?) onSortOrderChanged;
  final Function(DateTime?) onBeforePublishingDateChanged;
  final Function(DateTime?) onAfterPublishingDateChanged;
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;

  const CatalogDrawer({
    required this.maxHeight,
    required this.selectedGenres,
    required this.selectedAuthors,
    required this.selectedSortField,
    required this.selectedSortOrder,
    required this.beforePublishingDate,
    required this.afterPublishingDate,
    required this.onSelectedGenresChanged,
    required this.onSelectedAuthorsChanged,
    required this.onSortFieldChanged,
    required this.onSortOrderChanged,
    required this.onBeforePublishingDateChanged,
    required this.onAfterPublishingDateChanged,
    required this.onApplyFilters,
    required this.onResetFilters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.brown,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: const Align(
              alignment: Alignment.center,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Genres',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: SingleChildScrollView(
                      child: Center(
                        child: FilterChipWidget(
                          label: 'Genres',
                          selectedItems: selectedGenres,
                          onSelectedItemsChanged: onSelectedGenresChanged,
                        ),
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

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: SingleChildScrollView(
                      child: Center(
                        child: FilterChipWidget(
                          label: 'Authors',
                          selectedItems: selectedAuthors,
                          onSelectedItemsChanged: onSelectedAuthorsChanged,
                        ),
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

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<String>(
                          hint: const Text('Field'),
                          value: selectedSortField,
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
                                value: 'createdAt', child: Text('Created At')),
                          ],
                          onChanged: onSortFieldChanged,
                        ),
                    
                        const SizedBox(width: 8.0),
                    
                        Expanded(
                          child: DropdownButton<String>(
                            hint: const Text('Order'),
                            value: selectedSortOrder,
                            isExpanded: false,
                            items: const [
                              DropdownMenuItem(
                                  value: 'asc', child: Text('Asc.')),
                              DropdownMenuItem(
                                  value: 'desc', child: Text('Desc.')),
                            ],
                            onChanged: onSortOrderChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(beforePublishingDate == null
                          ? 'YYYY/MM/DD'
                          : beforePublishingDate!
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
                            onBeforePublishingDateChanged(pickedDate.toLocal());
                          }
                        },
                        child: const Text('Published Before...'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(afterPublishingDate == null
                          ? 'YYYY/MM/DD'
                          : afterPublishingDate!
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
                            onAfterPublishingDateChanged(pickedDate.toLocal());
                          }
                        },
                        child: const Text('Published After...'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onApplyFilters,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.brown,
            ),
            child: const Text('Apply Filters'),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: onResetFilters,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.brown,
            ),
            child: const Text('Reset Filters'),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
