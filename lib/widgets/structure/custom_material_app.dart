import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/app_providers.dart';
import 'package:ripple/providers/auth_provider.dart';
import 'package:ripple/views/auth.dart';
import 'package:ripple/views/loading.dart';
import 'package:ripple/views/login.dart';

class CustomMaterialApp extends StatelessWidget {
  const CustomMaterialApp({super.key, this.page});

  final Widget? page;

  @override
  Widget build(BuildContext context) {
    return AppProviders(
        child: MaterialApp(
      title: 'Ripple',
      home: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        if (authProvider.loadingUser) return LoadingView();
        if (authProvider.user == null) return const LoginView();
        return AuthPage();
      }),
    ));
  }
}
