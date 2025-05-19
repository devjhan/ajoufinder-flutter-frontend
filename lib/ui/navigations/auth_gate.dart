import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/views/logged_in/logged_in_screen.dart';
import 'package:ajoufinder/ui/views/not_logged_in/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Center(
      child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: authViewModel.isLoggedIn
      ? LoggedInScreen()
      : NotLoggedInScreen(),
      ),
    );
  }
}