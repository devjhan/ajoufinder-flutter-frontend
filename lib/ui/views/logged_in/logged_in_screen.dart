import 'package:ajoufinder/ui/navigations/bottom_nav_bar.dart';
import 'package:ajoufinder/ui/views/account/account_screen.dart';
import 'package:ajoufinder/ui/views/home/home_screen.dart';
import 'package:ajoufinder/ui/views/map/map_screen.dart';
import 'package:flutter/material.dart';

class LoggedInScreen extends StatefulWidget {
  const LoggedInScreen({super.key});

  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  
  int _selectedIndex = 0;

  final _pages = [
    HomeScreen(lostCategory: 'lost'),
    HomeScreen(lostCategory: 'found'),
    MapScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages
        )
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
