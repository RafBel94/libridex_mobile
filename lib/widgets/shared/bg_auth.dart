import 'package:flutter/material.dart';

class BgAuth extends StatelessWidget {
  const BgAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://trello-backgrounds.s3.amazonaws.com/SharedBackground/2215x2048/5fa9c73355b096b1e1786af0510a6fc4/photo-1481627834876-b7833e8f5570.webp'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: size.height,
          color: const Color.fromARGB(78, 0, 0, 0)
        ),
        // Positioned(
        //   top: size.height * 0.12,
        //   left: 0,
        //   right: 0,
        //   child: const Center(
        //     child: Text(
        //       'Libridex',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 52,
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
