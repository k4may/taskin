import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskin/widgets/space.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool isLogin = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLogin ? Text('Login') : Text('Cadastro'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spc(height: 40),
                const Text('Pin Task',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.blueGrey)),
                Spc(height: 40),
                Container(
                    constraints: BoxConstraints(maxWidth: 400), // Defina a altura máxima desejada
                  child: TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Por favor, digite um e-mail';
                      }
                      return null;
                    },
                    onSaved: (input) => _email = input!,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'example@email.com',
                        border: OutlineInputBorder()),
                  ),
                ),
                Spc(height: 8),
                Container(
                    constraints: BoxConstraints(maxWidth: 400), // Defina a altura máxima desejada
                  child: TextFormField(
                    validator: (input) {
                      if (input!.length < 6) {
                        return 'Sua senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                    onSaved: (input) => _password = input!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    obscureText: true,
                  ),
                ),
                Spc(height: 8),
                Container(
                  constraints: BoxConstraints(maxWidth: 400), // Defina a altura máxima desejada
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : isLogin
                            ? signIn
                            : signUp,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.blueGrey)
                        : Text(isLogin ? 'Fazer Login' : 'Cadastrar'),
                  ),
                ),
                Spc(height: 8),
                TextButton(
                  onPressed: _toggleForm,
                  child: Text(isLogin
                      ? 'Ainda não tem cadastro? Faça agora!'
                      : 'Já tem login? Faça o login agora!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print(user.user!.email);
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route<dynamic> route) => false);
      } catch (e) {
        print(e.toString());
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential user = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print(user.user!.email);
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route<dynamic> route) => false);
      } catch (e) {
        print(e.toString());
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}
