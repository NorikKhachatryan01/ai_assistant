import 'package:ai_assistant/providers/auth_provider.dart';
import 'package:ai_assistant/views/registeration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_screen.dart'; // Import your chat screen

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    if (authState.user != null) {
      // Use WidgetsBinding to schedule a callback for the end of this frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check if the current route is still active to prevent unwanted navigation
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }
      });
    } else if (authState.error != null) {
      // Use WidgetsBinding to show an error message if there is an error in the auth state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(authState.error ?? '')));
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Login'), backgroundColor: Colors.black),
      body: Center(
        child: authState.isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: LoginForm(),
              ),
      ),
    );
  }
}

class LoginForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState.user != null) {
      // Use WidgetsBinding to schedule a callback for the end of this frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check if the current route is still active to prevent unwanted navigation
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }
      });
    } else if (authState.error!.isNotEmpty) {
      // Use WidgetsBinding to show an error message if there is an error in the auth state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(authState.error ?? '')));
      });
    }

    // Automatically navigate when authenticated
    if (authState.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)!.isCurrent) {
          // Prevents multiple navigations
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        }
      });
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) =>
                !value!.contains('@') ? 'Please enter a valid email' : null,
            onSaved: (value) => _email = value ?? '',
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value!.length < 3
                ? 'Password must be at least 6 characters'
                : null,
            onSaved: (value) => _password = value ?? '',
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: Text('Login'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                await ref
                    .read(authStateProvider.notifier)
                    .login(_email, _password);
              }
            },
          ),
          TextButton(
            child: Text(
              'Register',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RegistrationScreen()), // Assuming you have a RegistrationScreen
            ),
          ),
          if (authState.error!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(authState.error ?? '',
                  style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
