import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:univalle_news/screens/welcome.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'news/bloc/news_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NewsBloc>(
            create: (context) => NewsBloc(),
          )
        ],
        child: MaterialApp(
          title: 'Coconut News',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: const Welcome(),
        ));
  }
}
