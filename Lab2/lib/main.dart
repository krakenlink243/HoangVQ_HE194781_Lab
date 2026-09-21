import 'package:flutter/material.dart';
import 'package:hello_flutter_lab1/car.dart';
import 'package:hello_flutter_lab1/electricCar.dart';

void main() async{
  int score = 30;
  if(score < 4){
    print("Not Passed");
  }else if(score > 10){
    print("Not valid");
  }else{
    print("passed");
  }

  int dayOfWeek = 2;
  switch(dayOfWeek){
    case 2: print("monday");
    case 3: print("tuesday");
    case 4: print("Wed");
    case 5: print("thu");
    case 6: print("fri");
    case 7: print("sat");
    case 8: print("sun");
    default: print("not valid");
  }

  for(int i = 0; i <5; i++){
    print(i);
  }
  List<String> kudamono = ["banana","apple","orange"];
  for(String k in kudamono){
    print(k);
  }

  kudamono.forEach((kudamono) => print(kudamono));

  String sayHello(String greeting){
    return greeting;
  }
  String sayHi(String greeting) => greeting;

  print(sayHello("hello"));
  print(sayHi("hi"));

  Car c = Car("192A11298");
  c.sayHello();
  ElectricCar ec = ElectricCar("192E11321");
  ec.sayHello();

  await getReady();

  String? name;
  int? nameLength = name?.length;
  print(nameLength);
  String call = name ?? "Mr/Mrs";
  print(call);


  Stream<int> generateNumbers() async* {
    for (int i = 1; i <= 3; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
  }
  generateNumbers().listen((int value) {
    print("Dữ liệu mới tới: $value");
  });

}

Future<String?> getReady() async{
  String loading = "loading";
  for(int i = 0; i < 4; i++){
    print(loading);
    loading += ".";
    await Future.delayed(const Duration(seconds: 1));
  }


}
