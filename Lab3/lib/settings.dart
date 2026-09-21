class Settings {
  String theme = "light";
  static final Settings _instance = Settings._internal();
  Settings._internal();
  factory Settings() => _instance;
}