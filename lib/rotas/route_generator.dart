import 'package:app_patrimony/pages/home_page.dart';
import 'package:app_patrimony/pages/login_page.dart';
import 'package:flutter/material.dart';

class RouteGenerate {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => LoginPage());
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (context) => HomePage());
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Tela não Encontrada'),
        ),
      ),
    );
  }
}
