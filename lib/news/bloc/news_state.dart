import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class NewsState {
  List<TextEditingController> commentControllers = [];
}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<QueryDocumentSnapshot> newsDocs;

  NewsLoadedState(this.newsDocs);
}

class NewsErrorState extends NewsState {
  final String error;

  NewsErrorState(this.error);
}
