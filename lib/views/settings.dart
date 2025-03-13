import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/auth_provider.dart';
import 'package:ripple/widgets/custom_material_app.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => ElevatedButton(
          onPressed: () async {
            await authProvider.logout();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CustomMaterialApp()));
          },
          child: Text('Logout')),
    );
  }
}
