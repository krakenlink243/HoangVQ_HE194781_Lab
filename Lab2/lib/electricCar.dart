import 'package:hello_flutter_lab1/car.dart';

class ElectricCar extends Car {
  new(super.plate);
  @override
  void sayHello(){
    print("this is e-car");
  }

}