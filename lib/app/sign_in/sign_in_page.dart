import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfect_time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:perfect_time_tracker/app/sign_in/sign_in_button.dart';
import 'package:perfect_time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:perfect_time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:perfect_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  void _showSignInError(
    BuildContext context,
    Exception exception,
  ) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await auth.signInWithGoogle();
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await auth.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(
        context,
        e,
      );
      log(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailSignInPage(),
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
          SizedBox(
            child: _buildHeader(),
            height: 50.0,
          ),
          const SizedBox(
            height: 36.0,
          ),
          SocialSignInButton(
            color: Colors.white,
            text: 'Sign in with Google',
            textColor: Colors.black87,
            onPressed: _isLoading ? null : () => _signInWithGoogle(context),
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
            onPressed: _isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: _isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
