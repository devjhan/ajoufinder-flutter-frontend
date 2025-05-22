import 'package:ajoufinder/ui/navigations/bottom_nav_bar.dart';
import 'package:ajoufinder/ui/viewmodels/page_view_model.dart';
import 'package:ajoufinder/ui/views/account/account_screen.dart';
import 'package:ajoufinder/ui/views/home/home_screen.dart';
import 'package:ajoufinder/ui/views/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Provider.of<PageViewModel>(context, listen: false).configureFab(index);
    });
  }

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pageViewModel = Provider.of<PageViewModel>(context, listen: false);
      pageViewModel.configureFab(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: Consumer<PageViewModel>(
        builder: (context, pageViewModel, child) {
          return pageViewModel.showFab 
          ? FloatingActionButton.extended(
            onPressed: pageViewModel.fabAction, 
            label: pageViewModel.fabLabel,
            icon: pageViewModel.fabIcon,  
          )
          : SizedBox();
        }
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
