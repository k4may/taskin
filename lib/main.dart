import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskin/firebase_options.dart';
import 'package:taskin/home/home_screen.dart';
import 'package:taskin/login/login_screen.dart';
import 'package:taskin/task/task_create.dart';
import 'package:taskin/user/user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      isLoggedIn = user != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: isLoggedIn ? '/home' : '/', // Define a rota inicial
      routes: {
        '/':(context) => AuthScreen(),
        '/login': (context) =>  AuthScreen(), // Rota inicial
        '/taskcreate': (context) => const TaskCreateScreen(), // Outras rotas
        '/user': (context) => const UserScreen(),
      '/home': (context) => WillPopScope(
        onWillPop: () async => false,
        child: const HomeScreen(),
      ),
      },
    );
  }
}
