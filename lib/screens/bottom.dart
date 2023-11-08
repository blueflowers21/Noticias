import 'package:flutter/material.dart';
import 'package:univalle_news/screens/news.dart';
import 'package:univalle_news/screens/newsManagement.dart';
import 'package:univalle_news/screens/userData.dart';

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

  AppBar _buildAppBar(int index) {
    switch (index) {
      case 0:
        return AppBar(
          title: const Text('News'),
          backgroundColor: const Color.fromARGB(255, 0, 26, 158),
        );
      case 1:
        return AppBar(
          title: const Text('News Management'),
          backgroundColor: const Color.fromARGB(255, 0, 26, 158),
        );
      case 2:
        return AppBar(
          title: const Text('Tu Data choquito'),
          backgroundColor: const Color.fromARGB(255, 0, 26, 158),
        );
      default:
        return AppBar(
          title: const Text('Default Title'),
          backgroundColor: const Color.fromARGB(255, 0, 26, 158),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(_selectedIndex),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          News(),
          NewsManagement(),
          UserData(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'News',
            backgroundColor: Color.fromARGB(255, 0, 26, 158),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Management',
            backgroundColor: Color.fromARGB(255, 0, 26, 158),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'data',
            backgroundColor: Color.fromARGB(255, 0, 26, 158),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 26, 158),
        onTap: _onItemTapped,
      ),
    );
  }
}
