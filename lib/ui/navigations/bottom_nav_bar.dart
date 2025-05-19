import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.help_outline, color: theme.primaryColor,), label: '잃었어요'),
        BottomNavigationBarItem(icon: Icon(Icons.redeem_outlined, color: theme.primaryColor,), label: '주웠어요'),
        BottomNavigationBarItem(icon: Icon(Icons.fmd_good_outlined, color: theme.primaryColor,), label: '지도'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline, color: theme.primaryColor,), label: '나의 정보'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}