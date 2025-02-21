// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:libridex_mobile/widgets/shared/bg_auth.dart';
import 'package:provider/provider.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.book, required this.editMode});
  final Book book;
  final bool editMode;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _imageController;
  late TextEditingController _publishingDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _genreController = TextEditingController(text: widget.book.genre);
    _imageController = TextEditingController(text: widget.book.image);
    _publishingDateController = TextEditingController(
        text:
            '${widget.book.publishingDate.year}-${widget.book.publishingDate.month.toString().padLeft(2, '0')}-${widget.book.publishingDate.day.toString().padLeft(2, '0')}');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _imageController.dispose();
    _publishingDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.editMode) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.book.publishingDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != widget.book.publishingDate) {
      setState(() {
        _publishingDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  String _selectScreenTitle(Book book) {
    if (widget.book.id == -1) {
      return 'New Book';
    } else if (widget.editMode) {
      return 'Edit Book';
    } else {
      return 'View Book';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.read<BookProvider>();
    List<String> genres = bookProvider.books.map((book) => book.genre).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_selectScreenTitle(widget.book),
            style: const TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        backgroundColor: Colors.white,
        elevation: 10.0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      body: Stack(
        children: [
          const BgAuth(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(width: 5, color: Colors.brown),
                  bottom: BorderSide(width: 5, color: Colors.brown),
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Image
                    Image.network(
                      height: 180,
                      widget.book.image,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/defaultbook.png',
                          height: 180);
                      },
                    ),

                    // Form
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // Title
                          TextFormField(
                            controller: _titleController,
                            decoration:
                                const InputDecoration(labelText: 'Title', hintText: 'Book title', hintStyle: TextStyle(color: Colors.grey)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            readOnly: !widget.editMode,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                          ),

                          const SizedBox(height: 20),

                          // Author
                          TextFormField(
                            controller: _authorController,
                            decoration: const InputDecoration(labelText: 'Author'),
                            readOnly: !widget.editMode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an author';
                              }
                              return null;
                            },
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                          ),

                          const SizedBox(height: 20),

                          // Genre
                          Consumer<BookProvider>(
                            builder: (context, bookProvider, child) {
                              return widget.editMode
                                  ? DropdownButtonFormField<String>(
                                      value: _genreController.text == '' ? null : _genreController.text,
                                      decoration: const InputDecoration(labelText: 'Genre', hintText: 'Select a genre', hintStyle: TextStyle(color: Colors.grey)),
                                      items: genres.map((genre) {
                                        return DropdownMenuItem<String>(
                                          value: genre,
                                          child: Text(genre),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _genreController.text = value!;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a genre';
                                        }
                                        return null;
                                      },
                                    )
                                  : TextFormField(
                                      controller: _genreController,
                                      decoration: const InputDecoration(labelText: 'Genre'),
                                      readOnly: true,
                                    );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Image URL
                          TextFormField(
                            controller: _imageController,
                            decoration:
                                const InputDecoration(labelText: 'Image URL', hintText: 'Enter image URL (Link)', hintStyle: TextStyle(color: Colors.grey)),
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an image URL';
                                } else if (!RegExp(r'^(https?|ftp)://[^\s/$.?#].[^\s]*$').hasMatch(value)) {
                                  return 'Please enter a valid URL';
                                }
                              return null;
                            },
                            readOnly: !widget.editMode,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                          ),

                          const SizedBox(height: 20),

                          // Publishing Date
                          TextFormField(
                            controller: _publishingDateController,
                            decoration: const InputDecoration(
                                labelText: 'Publishing Date', hintText: 'Book publishing date', hintStyle: TextStyle(color: Colors.grey)),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Buttons
                    if (widget.editMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 113, 77, 63),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                widget.book.id == -1 ? _addBook(widget.book, bookProvider) : _updateBook(widget.book, bookProvider);
                              }
                            },
                            child: Text(
                              widget.book.id == -1 ? 'Create Book' : 'Update Book',
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateBook(Book book, BookProvider bookProvider) {
    widget.book.title = _titleController.text;
    widget.book.author = _authorController.text;
    widget.book.genre = _genreController.text;
    widget.book.image = _imageController.text;
    widget.book.publishingDate = DateTime.parse(_publishingDateController.text);

    bookProvider.editBook(widget.book);
    if (bookProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bookProvider.errorMessage!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book updated successfully!")),
      );
      Navigator.pop(context);
    }
  }

  void _addBook(Book book, BookProvider bookProvider) async {
    Book newBook = Book(
      id: -1,
      title: _titleController.text,
      author: _authorController.text,
      genre: _genreController.text,
      image: _imageController.text,
      publishingDate: DateTime.parse(_publishingDateController.text),
      createdAt: DateTime.now()
    );

    await bookProvider.addBook(newBook);
    await bookProvider.fetchBooksWithFilters(null, null, null, null, null, null);
    if (bookProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bookProvider.errorMessage!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book created successfully!")),
      );
      Navigator.pop(context);
    }
  }
}
