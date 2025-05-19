import 'package:ajoufinder/ui/views/notifications/keyword_screen.dart';
import 'package:ajoufinder/ui/views/notifications/notifications_screen.dart';
import 'package:flutter/material.dart';

class NotificationsTabScreen extends StatelessWidget {
  const NotificationsTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            '알림', 
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: '새 소식'),
              Tab(text: '키워드 알림'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NotificationScreen(),
            KeywordScreen(),
          ],
        ),
      ),
    );
  }
}