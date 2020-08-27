import 'package:app_patrimony/pages/login_page.dart';
import 'package:app_patrimony/rotas/route_generator.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: LoginPage(),
        theme: ThemeData(
          primaryColor: Color.fromRGBO(31, 45, 68, 1),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerate.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
