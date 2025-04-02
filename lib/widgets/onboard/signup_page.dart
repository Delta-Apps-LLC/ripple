import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Form(
              key: widget.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: widget.firstNameController,
                    keyboardType: TextInputType.name,
                    cursorColor: AppColors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'First name',
                      labelStyle: TextStyle(color: AppColors.black),
                      hintText: 'Enter your first name',
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
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: widget.lastNameController,
                    keyboardType: TextInputType.name,
                    cursorColor: AppColors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      labelStyle: TextStyle(color: AppColors.black),
                      hintText: 'Enter your last name',
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
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: widget.emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: AppColors.black,
                    textInputAction: TextInputAction.next,
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
                      // Basic email validation using regular expression
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: widget.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscurePassword,
                    cursorColor: AppColors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: AppColors.black),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: AppColors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      // Check for at least one special character
                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return 'Password must contain at least one special character';
                      }
                      // Check for at least one uppercase letter
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: widget.confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    cursorColor: AppColors.black,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      labelStyle: TextStyle(color: AppColors.black),
                      hintText: 'Confirm your password',
                      hintStyle: TextStyle(color: AppColors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
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
                        return 'Please confirm your password';
                      }
                      if (value != widget.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FormField<bool>(
                      initialValue: false,
                      validator: (value) {
                        if (value != true) {
                          return 'You must be over the age of 16';
                        }
                        return null;
                      },
                      builder: (FormFieldState<bool> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              title: Text(
                                'I am over the age of 16',
                                style: GoogleFonts.lato(
                                    color: AppColors.black, fontSize: 15),
                              ),
                              activeColor: AppColors.green,
                              value: state.value,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool? newValue) {
                                state.didChange(newValue);
                              },
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Text(
                                  state.errorText ?? '',
                                  style: TextStyle(color: AppColors.errorRed),
                                ),
                              ),
                          ],
                        );
                      }),
                  FormField<bool>(
                    initialValue: false,
                    validator: (value) {
                      if (value != true) {
                        return 'You must agree to the Terms and Policy';
                      }
                      return null;
                    },
                    builder: (FormFieldState<bool> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            title: Text(
                                'I agree to the Terms and Conditions and to the Privacy Policy',
                                style: GoogleFonts.lato(
                                    color: AppColors.black, fontSize: 15)),
                            activeColor: AppColors.green,
                            value: state.value,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? newValue) {
                              state.didChange(newValue);
                            },
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                state.errorText ?? '',
                                style: TextStyle(color: AppColors.errorRed),
                              ),
                            ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
