import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perfect_time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:perfect_time_tracker/app/sign_in/sign_in_button.dart';
import 'package:perfect_time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:perfect_time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final AuthBase auth;

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      log(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailSignInPage(
          auth: auth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfect Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(
        context,
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 36.0,
          ),
          SocialSignInButton(
            color: Colors.white,
            text: 'Sign in with Google',
            textColor: Colors.black87,
            onPressed: _signInWithGoogle,
            assetName: 'images/google-logo.png',
          ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            color: const Color(0xFF334D92),
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            onPressed: () {},
            assetName: 'images/facebook-logo.png',
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
            color: Colors.teal,
            text: 'Sign in with email',
            textColor: Colors.white,
            onPressed: () => _signInWithEmail(
              context,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            'or',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
            color: Colors.blue,
            text: 'Go anonymous',
            textColor: Colors.black,
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
