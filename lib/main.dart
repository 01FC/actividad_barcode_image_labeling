import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication_bloc/authentication_bloc.dart';
import 'home/home_page.dart';
import 'login/login_page.dart';

void main() async {
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc()..add(VerifyAuthenticatedUser()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Practica integradora 2",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.grey[50],
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticatedSuccessfully) return HomePage();
          if (state is UnAuthenticated) return LoginPage();
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
