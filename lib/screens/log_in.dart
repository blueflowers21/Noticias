// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univalle_news/screens/bottom.dart';
import 'package:univalle_news/screens/news.dart'; // Importa Firestore para acceder a la base de datos de Firebase

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
Future<bool> checkIfUserIsAdmin(User user) async {
  try {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      final userData = userDoc.data();
      final userEmail = userData?['email'];
      final userPassword = userData?['password'];

      // Comprueba si el usuario tiene las credenciales de administrador
      if (userEmail == 'admin@gmail.com' && userPassword == 'admin123456') {
        return true;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error al verificar si el usuario es administrador: $e');
    }
  }
  return false;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 0, 26, 158),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 0, 26, 158), Colors.blue],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () async {
                        final enteredEmail = emailController.text;
                        final enteredPassword = passwordController.text;

                        try {
                          final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: enteredEmail,
                            password: enteredPassword,
                          );

                          final user = userCredential.user;

                          if (user != null) {
                            bool isAdmin = await checkIfUserIsAdmin(user);

                            if (isAdmin) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()),
                              );
                            } else {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const  News()),
                              );
                            }
                          }
                        } catch (e) {
                          String errorMessage = 'Error during login.';
                          if (e is FirebaseAuthException) {
                            if (e.code == 'user-not-found') {
                              errorMessage = 'User not found. Please register first.';
                            } else if (e.code == 'wrong-password') {
                              errorMessage = 'Incorrect password. Please try again.';
                            }
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                            ),
                          );
                          if (kDebugMode) {
                            print('Error during login: $e');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 248, 248, 248),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
