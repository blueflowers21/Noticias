import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSh5mEF28B_KVNsDomNEsK7J-GwLus6O-Oh67ZKnBlNHiWFj0Q8'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.person,
                          color: Color.fromARGB(255, 0, 26, 158)),
                      title: Text("Nombre"),
                      subtitle:
                          Text(data['name'], style: TextStyle(fontSize: 20)),
                    ),
                    Divider(color: Color.fromARGB(255, 0, 26, 158)),
                    ListTile(
                      leading: Icon(Icons.email,
                          color: Color.fromARGB(255, 0, 26, 158)),
                      title: Text("Email"),
                      subtitle:
                          Text(data['email'], style: TextStyle(fontSize: 20)),
                    ),
                    Divider(color: Color.fromARGB(255, 0, 26, 158)),
                    ListTile(
                      leading: Icon(Icons.calendar_today,
                          color: Color.fromARGB(255, 0, 26, 158)),
                      title: Text("Fecha de Creación"),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(data['created'].toDate()),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
