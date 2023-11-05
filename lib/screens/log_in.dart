// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:univalle_news/screens/bottom.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            elevation: 4, // Elevación del Card
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
                          border: InputBorder.none, // Sin bordes
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()),
                            );
                          }
                        } catch (e) {
                          // errores
                          String errorMessage = 'Error durante el inicio de sesión.';
                          if (e is FirebaseAuthException) {
                            if (e.code == 'user-not-found') {
                              errorMessage = 'Usuario no encontrado. Por favor, regístrate primero.';
                            } else if (e.code == 'wrong-password') {
                              errorMessage = 'Contraseña incorrecta. Por favor, inténtalo de nuevo.';
                            }
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                            ),
                          );
                          print('Error durante el inicio de sesión: $e');
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
