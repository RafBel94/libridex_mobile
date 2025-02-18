import 'package:flutter/material.dart';

class BgAuth extends StatelessWidget {
  const BgAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://trello-backgrounds.s3.amazonaws.com/SharedBackground/2215x2048/5fa9c73355b096b1e1786af0510a6fc4/photo-1481627834876-b7833e8f5570.webp'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
