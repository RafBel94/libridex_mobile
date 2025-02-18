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
              image: AssetImage('assets/images/background.png'),
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
