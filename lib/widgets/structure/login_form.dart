import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/auth_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/snackbar.dart';
import 'package:ripple/widgets/misc/custom_icon_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  Future<void> submit(AuthProvider provider) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      final res = await provider.signIn(
          _emailController.text, _passwordController.text);
      setState(() => _loading = false);
      if (res != null) {
        showCustomSnackbar(context, res.message, AppColors.errorRed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: AppColors.black,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: AppColors.black),
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: AppColors.black),
              focusColor: AppColors.black,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: AppColors.black)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: AppColors.black),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: AppColors.black,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: AppColors.black),
              hintText: 'Enter your password',
              hintStyle: TextStyle(color: AppColors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              focusColor: AppColors.black,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: AppColors.black)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: AppColors.black),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          if (_loading)
            const CircularProgressIndicator(
              color: AppColors.darkBlue,
            ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) => CustomIconButton(
                text: 'Sign in',
                colors: [AppColors.lightGray, AppColors.purple],
                function: () async {
                  await submit(authProvider);
                }),
          ),
        ],
      ),
    );
  }
}
