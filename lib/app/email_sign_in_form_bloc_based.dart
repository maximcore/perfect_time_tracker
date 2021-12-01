import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfect_time_tracker/app/email_sign_in_bloc.dart';
import 'package:perfect_time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:perfect_time_tracker/common_widgets/form_submit_button.dart';
import 'package:perfect_time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:perfect_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  const EmailSignInFormBlocBased({Key key, this.bloc}) : super(key: key);
  final EmailSignInChangeModel bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        exception: e,
        title: 'Sign in failed',
      );
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  Widget _emailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updateEmail,
      focusNode: _emailFocusNode,
      style: const TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        enabled: model.isLoading == false,
        errorText: model.emailErrorText,
        labelText: 'Email',
        hintText: 'example@example.com',
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      onEditingComplete: _submit,
      onChanged: widget.bloc.updatePassword,
      focusNode: _passwordFocusNode,
      style: const TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        enabled: model.isLoading == false,
        errorText: model.passwordErrorText,
        labelText: 'Password',
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _emailTextField(model),
      const SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
      const SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: !model.isLoading ? () => _toggleFormType : null,
        child: Text(
          model.secondaryButtonText,
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
