import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
  BookProvider bookProvider = context.read<BookProvider>();
  
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Admin Panel', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: Colors.white,
        elevation: 10.0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.book),
            title: Text('Item $index'),
            subtitle: Text('Subtitle $index'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle item tap
            },
          );
        },
      ),
    );
  }
}