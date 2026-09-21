import 'dart:convert';

import 'package:lab3/user.dart';

class UserRepo {
  Future<List<User>> fetchUsersData(String mockJson) async{
    await Future.delayed(const Duration(seconds: 1));
    final List<dynamic> data = jsonDecode(mockJson);

    return data.map((item) => User.fromJson(item as Map<String,dynamic>)).toList();
  }
}