import 'package:flutter/material.dart';
import 'package:perfect_time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:perfect_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await auth.signOut();
    } catch (e) {}
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      content: 'Are you sure that you want to Sign out?',
      title: 'Sign out',
      cancelActionText: 'Cancel',
      defaultActionText: 'Sign Out',
    );
    if (didRequestSignOut) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
