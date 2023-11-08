// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univalle_news/screens/bottom.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromARGB(255, 0, 26, 158),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF261CBF), Color.fromARGB(255, 175, 219, 255)], 
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              
              Container(
                height: screenHeight-200,
               color: const Color.fromARGB(255, 234, 243, 255),
                margin: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.7,
                        height: 50,
                        child: const Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 26, 158),
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Card(
                        borderOnForeground: true,
          elevation: 10, 
          shadowColor: const Color.fromARGB(255, 0, 26, 158), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          
                        ),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Card(
                            borderOnForeground: true,
          elevation: 10, 
          shadowColor: const Color.fromARGB(255, 0, 26, 158), 
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
                            borderOnForeground: true,
          elevation: 10, 
          shadowColor: const Color.fromARGB(255, 0, 26, 158), 
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
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // validar password 
                    if (passwordController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password must have more than or equal to 6 digits'),
                        ),
                      );
                      return;
                    }

                    // Crear nuevo usuario
                    final UserCredential userCredential =
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Acceder al UID del usuario
                    final User? user = userCredential.user;
                    final String uid = user?.uid ?? '';

                    final FirebaseFirestore firestore = FirebaseFirestore.instance;

                    final Map<String, dynamic> userData = {
                      'name': nameController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                      'created': FieldValue.serverTimestamp(),
                    };

                    // Agregar usuario si es exitoso
                    await firestore.collection('users').doc(uid).set(userData);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()),
                    );
                  } catch (e) {
                    // Errores
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error durante el registro: $e'),
                      ),
                    );
                    print('Error durante el registro: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF261CBF), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(75),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
