import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<AuthException?> signUp(String email, String password) async {
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      return null;
    } on AuthException catch (err) {
      return err;
    }
  }

  Future<AuthException?> signIn(String email, String password) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null;
    } on AuthException catch (err) {
      return err;
    }
  }

  User? getCurrentUser() {
    return Supabase.instance.client.auth.currentUser;
  }

  Session? getCurrentSession() {
    return Supabase.instance.client.auth.currentSession;
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    await Supabase.instance.client.auth.resetPasswordForEmail(email);
  }

  Future<AuthException?> deleteAuthUser(String userId) async {
    final supabaseUrl = dotenv.env["SUPABASE_URL"]!;
    final functionUrl = '$supabaseUrl/functions/v1/delete_user';
    final accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;

    try {
      final response = await http.post(
        Uri.parse(functionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        logout();
        return null;
      } else {
        final decodedResponse = jsonDecode(response.body);
        return AuthException(
          decodedResponse['error'] ?? 'Unknown error',
          statusCode: response.statusCode.toString(),
        );
      }
    } catch (e) {
      return AuthException(
        e.toString(),
        statusCode: 500.toString(),
      );
    }
  }
}
