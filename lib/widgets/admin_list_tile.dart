import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:libridex_mobile/domain/models/book.dart';
import 'package:libridex_mobile/screens/book_screen.dart';
import 'package:libridex_mobile/widgets/dialogs/show_delete_book_confirmation.dart';

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditBookScreen(book: book, editMode: true)));
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
