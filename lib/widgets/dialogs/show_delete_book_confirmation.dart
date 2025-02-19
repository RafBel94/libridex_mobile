// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:provider/provider.dart';

void showDeleteBookConfirmation(BuildContext context, Book book) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you really want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () async {
              await context.read<BookProvider>().deleteBook(book.id);
              await context.read<BookProvider>().fetchBooksWithFilters(null,null,null,null,null,null);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}
