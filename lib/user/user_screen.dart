import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuário'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _signOut();
          },
          child: const Text('Sair'),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      // ignore: use_build_context_synchronously
      Navigator.restorablePushNamedAndRemoveUntil(
          context, '/login', (route) => false);
    } catch (e) {
      return null;
    }
  }
}
