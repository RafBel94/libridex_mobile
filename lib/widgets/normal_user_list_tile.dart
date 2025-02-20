import 'package:flutter/material.dart';
import 'package:libridex_mobile/domain/models/book.dart';

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
