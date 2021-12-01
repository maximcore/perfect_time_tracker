import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perfect_time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:perfect_time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:perfect_time_tracker/app/home/models/job.dart';
import 'package:perfect_time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:perfect_time_tracker/services/auth.dart';
import 'package:perfect_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(
        context,
        listen: false,
      );
      await auth.signOut();
    } catch (e) {
      log(e.toString());
    }
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
        title: const Text('Jobs'),
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
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EditJobPage.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map((job) => JobListTile(
                    job: job,
                    onTap: () => EditJobPage.show(context, job: job),
                  ))
              .toList();
          return ListView(
            children: children,
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Some error occurred'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
