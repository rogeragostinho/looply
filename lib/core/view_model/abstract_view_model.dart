import 'package:flutter/material.dart';

abstract class AbstractViewModel<T, R> extends ChangeNotifier {

  final R repository;

  AbstractViewModel(this.repository);

  /*Future<int> insert(T item);
  Future<int> update(T item);
  Future<int> delete(int id);
  Future<T?> getById(int id);
  Future<List<T>> getAll();*/
  
}