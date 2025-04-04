import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/person.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/views/loading.dart';
import 'package:ripple/views/login.dart';
import 'package:ripple/views/onboard.dart';
import 'package:ripple/widgets/structure/custom_scaffold.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserIdentityProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.loadingUser) return LoadingView();
        if (userProvider.person == null) return const LoginView();
        if (userProvider.person?.onboardLevel != OnboardLevel.complete) {
          return OnboardView(level: userProvider.person?.onboardLevel);
        }
        return CustomScaffold();
      },
    );
  }
}
