import 'package:flutter/material.dart';

import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',
      routes: {
        '/': (context) => const MyLogin(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const MyLogin(),
      },
    ),
  );
}
