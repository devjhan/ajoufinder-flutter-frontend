import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/navigations/auth_gate.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencies();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),  
        ChangeNotifierProvider(create: (_) => BoardViewModel()),  
        ChangeNotifierProvider(create: (_) => CommentViewModel()),  
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const lightColorScheme = ColorScheme(
      brightness: Brightness.light,

      primary: Colors.deepPurple,
      onPrimary: Colors.white,

      secondary: Colors.lime,
      onSecondary: Colors.black,

      error: Color(0xFFB00020),
      onError: Colors.white,

      surface: Color(0xFFFFFFFF),
      onSurface: Colors.black,

      primaryContainer: Colors.lightBlueAccent,
      onPrimaryContainer: Colors.black,    

      secondaryContainer: Colors.limeAccent,
      onSecondaryContainer: Colors.black,   

      tertiary: Color(0xFF03DAC5),        
      onTertiary: Colors.black,

      tertiaryContainer: Color(0xFFCEFFFF),
      onTertiaryContainer: Colors.black,

      errorContainer: Color(0xFFFCD8DF),
      onErrorContainer: Colors.black,

      onSurfaceVariant: Colors.black,

      outline: Color(0xFFBDBDBD),
      outlineVariant: Color(0xFFE0E0E0),

      shadow: Colors.black,
      scrim: Colors.black,

      inverseSurface: Color(0xFF303030),
      onInverseSurface: Colors.white,
      inversePrimary: Colors.indigoAccent,
    );

   final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,

      scaffoldBackgroundColor: Colors.white38,
      hintColor: Colors.grey[600],

      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: 4.0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: lightColorScheme.onPrimary,
        ),
      ),

      cardTheme: CardTheme(
        color: lightColorScheme.surface,
        elevation: 1.0,
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
        )
      ),
    );

    return MaterialApp(
      title: 'AjouFinder',
      home: AuthGate(),
      theme: lightTheme
    );
  }
}