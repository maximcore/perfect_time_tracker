import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfect_time_tracker/app/home/job_entries/job_entries_page.dart';
import 'package:perfect_time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:perfect_time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:perfect_time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:perfect_time_tracker/app/home/models/job.dart';
import 'package:perfect_time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:perfect_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: e);
    }
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(
              onPressed: () => EditJobPage.show(
                    context,
                    database: Provider.of<Database>(context, listen: false),
                  ),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
      body: _buildContents(context),
    );
  }
}
