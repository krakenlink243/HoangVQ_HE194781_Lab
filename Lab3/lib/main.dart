import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lab3/product.dart';
import 'package:lab3/product_repo.dart';
import 'package:lab3/settings.dart';
import 'package:lab3/user.dart';
import 'package:lab3/user_repo.dart';

void main() async {
  //BAI 1
  // final repo = ProductRepo();
  //
  // repo.liveAdded().listen(
  //       (p) => print('[Listener 2] Added: ${p.name}'),
  // );
  //
  // repo.add(Product(id: 1, name: 'Laptop', price: 999.99));
  // await Future.delayed(const Duration(seconds: 1));
  // repo.add(Product(id: 2, name: 'Mouse', price: 19.5));
  //
  // final all = await repo.getAll();
  // print('--- getAll() ---');
  // for (final p in all) {
  //   print(p.name);
  // }
  //
  // repo.dispose();

  //BAI2
  // String mockJson = '''
  // [
  //   {"name": "An",   "email": "an@example.com"},
  //   {"name": "Binh", "email": "binh@example.com"},
  //   {"name": "Chi",  "email": "chi@example.com"}
  // ]
  // ''';
  //
  // final userRepo = UserRepo();
  // final users = await userRepo.fetchUsersData(mockJson);
  // print('--- Danh sách user ---');
  // for (final u in users) {
  //   print(u);
  // }

  //BAI3
  // print("code dong bo");
  // Future(() => print("Event 1"));
  // scheduleMicrotask(() => print("microtask 1"));
  // Future(() => print("event 2"));
  // scheduleMicrotask(() => print('microtask 2'));
  // print("code dong bo 2");

  //BAI4
  // Stream<int> countStream() async* {
  //   for (var i = 1; i <= 5; i++) {
  //     await Future.delayed(const Duration(milliseconds: 1000));
  //     yield i;
  //   }
  // }
  // countStream()
  //     .map((n) => n * n)
  //     .where((n) => n.isOdd)
  //     .listen((n) => print(n));

  //BAI5
  Settings s = Settings();
  Settings c = Settings();
  print(identical(s, c));
  s.theme = "dark";
  print(c.theme);

}

