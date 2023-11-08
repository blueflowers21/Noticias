import 'package:flutter/material.dart';
import 'package:univalle_news/screens/commentsManagement%20.dart';
import 'package:univalle_news/screens/image.dart';
import 'package:univalle_news/screens/news.dart';
import 'package:univalle_news/screens/newsManagement.dart';
 // Import the ImageUpload screen

void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [    
          News(),
          NewsManagement(),        
          UploadImage(), 
          Comments(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_sharp),
            label: 'News',
            backgroundColor: Color.fromARGB(255, 0, 26, 158),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search),
            label: 'Management',
            backgroundColor: Color.fromARGB(255, 0, 26, 158),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'Imagen',
            backgroundColor: Color.fromARGB(255, 0, 26, 158),
          ),
          BottomNavigationBarItem( 
            icon: Icon(Icons.image),
            label: 'Comments',
            backgroundColor: Color.fromARGB(255, 0, 26, 158),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}
