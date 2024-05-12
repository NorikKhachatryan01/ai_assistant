import 'package:ai_assistant/providers/auth_provider.dart';
import 'package:ai_assistant/views/registeration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_screen.dart'; 

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    if (authState.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }
      });
    } else if (authState.error != null) {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }
      });
    } else if (authState.error!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(authState.error ?? '')));
      });
    }
    if (authState.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)!.isCurrent) {
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
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Image.asset('assets/images/logo.png', width: 300),
          ),
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
                      RegistrationScreen()), 
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
