class Car {
  String _plate;

  Car(this._plate);

  void sayHello() {
    print("this is generic car");
  }


  String get plate => _plate;

  set plate(String value) {
    _plate = value;
  }
}